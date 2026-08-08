import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:flutter/foundation.dart';

import '../data/app_database.dart';
import '../data/media_store.dart';
import 'peer_discovery.dart';
import 'peer_handshake.dart';
import 'peer_http_transport.dart';
import 'peer_identity_store.dart';

const _mediaChunkBytes = 24 * 1024;
const _maxMediaBytes = 16 * 1024 * 1024;
final _imageHashPattern = RegExp(r'^[0-9a-f]{64}$');

enum PeerSyncStatus { stopped, starting, running, stopping, error }

class PeerSyncRuntime extends ChangeNotifier {
  PeerSyncRuntime({
    required this.identity,
    required String groupId,
    this.database,
    this.mediaStore,
    this.trustStore,
    String? expectedRemoteDeviceName,
    this.bindAddress,
    this.httpPort = 0,
    this.discoveryPort = PeerDiscoveryService.defaultDiscoveryPort,
    this.discoveryBindPort,
    this.announceImmediately = true,
    this.syncInterval = const Duration(seconds: 60),
  }) : groupId = groupId.trim(),
       expectedRemoteDeviceName =
           (expectedRemoteDeviceName ?? identity.deviceName).trim() {
    if (this.groupId.isEmpty) throw ArgumentError.value(groupId, 'groupId');
    if (this.expectedRemoteDeviceName.isEmpty) {
      throw ArgumentError.value(
        expectedRemoteDeviceName,
        'expectedRemoteDeviceName',
      );
    }
    if (syncInterval <= Duration.zero) {
      throw ArgumentError.value(syncInterval, 'syncInterval');
    }
  }

  final PeerIdentity identity;
  final String groupId;
  final AppDatabase? database;
  final MediaStore? mediaStore;
  final PeerTrustStore? trustStore;
  final String expectedRemoteDeviceName;
  final InternetAddress? bindAddress;
  final int httpPort;
  final int discoveryPort;
  final int? discoveryBindPort;
  final bool announceImmediately;
  final Duration syncInterval;

  PeerHttpServer? _httpServer;
  PeerDiscoveryService? _discovery;
  StreamSubscription<PeerDiscoveryPeer>? _peerSubscription;
  StreamSubscription<LocalDevice>? _localChanges;
  Stream<List<PeerDevice>>? _devices;
  Stream<List<SyncConflict>>? _pendingConflicts;
  PeerSyncStatus _status = PeerSyncStatus.stopped;
  Object? _error;
  Future<void>? _startFuture;
  Future<void>? _stopFuture;
  Future<int>? _syncFuture;
  Timer? _syncTimer;
  final Map<String, PeerHttpClient> _clients = {};
  final Set<String> _autoConnecting = {};
  final Set<String> _pendingRejoinClients = {};
  final Map<String, _MediaUpload> _uploads = {};
  final Map<String, DateTime> _lastSyncByDevice = {};
  DateTime? _lastSyncAtUtc;
  Object? _syncError;
  bool _manualSyncing = false;
  bool _manualSyncRequested = false;
  int _syncCompletionSerial = 0;
  int _lastSyncTransferredCount = 0;
  bool _lastSyncWasManual = false;
  bool _closed = false;

  PeerSyncStatus get status => _status;
  Object? get error => _error;
  PairingCode? get pairingCode {
    final code = _httpServer?.pairingCode;
    return code?.isActive == true ? code : null;
  }

  bool get isRunning => _status == PeerSyncStatus.running;
  bool get isHttpListening => _httpServer?.isListening ?? false;
  bool get isDiscoveryRunning => _discovery?.isStarted ?? false;
  bool get isServerPaired => _httpServer?.isPaired ?? false;
  bool get isSyncing => _syncFuture != null;
  bool get isManualSyncing => _manualSyncing;
  bool get canSync => _clients.isNotEmpty;
  DateTime? get lastSyncAtUtc => _lastSyncAtUtc;
  Object? get syncError => _syncError;
  int get syncCompletionSerial => _syncCompletionSerial;
  int get lastSyncTransferredCount => _lastSyncTransferredCount;
  bool get lastSyncWasManual => _lastSyncWasManual;
  Set<String> get connectedDeviceIds =>
      Set.unmodifiable({..._clients.keys, ...?_httpServer?.pairedDeviceIds});

  DateTime? lastSyncFor(String deviceId) => _lastSyncByDevice[deviceId];

  int get localHttpPort {
    final server = _httpServer;
    if (server == null) throw StateError('HTTP服务尚未启动');
    return server.uri.port;
  }

  bool isPaired(String deviceId) => connectedDeviceIds.contains(deviceId);

  List<PeerDiscoveryPeer> get knownPeers =>
      _discovery?.knownPeers ?? const <PeerDiscoveryPeer>[];

  Future<void> start() async {
    if (_closed) throw StateError('同步运行时已关闭');
    final stopping = _stopFuture;
    if (stopping != null) await stopping;
    final current = _startFuture;
    if (current != null) return current;
    if (isRunning) return;
    final future = _start();
    _startFuture = future;
    try {
      await future;
    } finally {
      if (identical(_startFuture, future)) _startFuture = null;
    }
  }

  Future<void> stop() async {
    final starting = _startFuture;
    if (starting != null) {
      try {
        await starting;
      } catch (_) {}
    }
    final current = _stopFuture;
    if (current != null) return current;
    if (_httpServer == null && _discovery == null) {
      _setStatus(PeerSyncStatus.stopped);
      return;
    }
    final future = _stop();
    _stopFuture = future;
    try {
      await future;
    } finally {
      if (identical(_stopFuture, future)) _stopFuture = null;
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await stop();
    super.dispose();
  }

  void refreshPairingCode() {
    final server = _httpServer;
    if (server == null) throw StateError('同步服务尚未启动');
    server.refreshPairingCode();
    notifyListeners();
  }

  Future<void> _start() async {
    _error = null;
    _setStatus(PeerSyncStatus.starting);
    final httpServer = PeerHttpServer(
      identity: identity,
      groupId: groupId,
      pairingCode: PairingCode.issue(),
      expectedRemoteDeviceName: expectedRemoteDeviceName,
      onMessage: database == null ? null : _handleMessage,
      onPaired: notifyListeners,
      onReversePairing: (pairing) => unawaited(_connectBack(pairing)),
      trustedTokenForDevice: trustStore == null
          ? null
          : (deviceId, identityPublicKey) async {
              if (await database?.isPeerRevoked(deviceId) == true ||
                  await database?.isPeerPendingRejoin(deviceId) == true) {
                return null;
              }
              final trust = await trustStore!.find(deviceId);
              if (trust == null ||
                  !constantTimeBytesEquality.equals(
                    trust.identityPublicKey,
                    identityPublicKey,
                  )) {
                return null;
              }
              return trust.token;
            },
      onTrustEstablished: trustStore == null
          ? null
          : (deviceId, deviceName, identityPublicKey, trustToken) =>
                _rememberTrust(
                  deviceId,
                  deviceName,
                  identityPublicKey,
                  trustToken,
                ),
    );
    PeerDiscoveryService? discovery;
    StreamSubscription<PeerDiscoveryPeer>? peerSubscription;
    try {
      final address = bindAddress ?? InternetAddress.anyIPv4;
      await httpServer.start(address: address, port: httpPort);
      discovery = PeerDiscoveryService(
        groupId: groupId,
        deviceId: identity.deviceId,
        deviceName: identity.deviceName,
        httpPort: httpServer.uri.port,
        discoveryPort: discoveryPort,
      );
      peerSubscription = discovery.peers.listen((peer) {
        notifyListeners();
        unawaited(_autoConnect(peer));
      });
      await discovery.start(
        bindAddress: address,
        port: discoveryBindPort ?? discoveryPort,
        announceImmediately: announceImmediately,
      );
      _httpServer = httpServer;
      _discovery = discovery;
      _peerSubscription = peerSubscription;
      _setStatus(PeerSyncStatus.running);
      for (final peer in discovery.knownPeers) {
        unawaited(_autoConnect(peer));
      }
      if (database != null) {
        await _cleanupAcknowledgedDeletions();
        var lastLocalSequence = (await database!.localDevice()).deviceSeq;
        _localChanges = database!
            .select(database!.localDevices)
            .watchSingle()
            .listen((device) {
              if (device.deviceSeq <= lastLocalSequence) return;
              lastLocalSequence = device.deviceSeq;
              if (_clients.isNotEmpty) {
                unawaited(syncAll().catchError((_) {}));
              }
            });
        _syncTimer = Timer.periodic(syncInterval, (_) {
          if (_clients.isNotEmpty) {
            unawaited(syncAll().catchError((_) {}));
          }
        });
      }
    } catch (error) {
      await peerSubscription?.cancel();
      await discovery?.dispose();
      await httpServer.close();
      _error = error;
      _setStatus(PeerSyncStatus.error);
      rethrow;
    }
  }

  Future<void> _stop() async {
    _setStatus(PeerSyncStatus.stopping);
    _syncTimer?.cancel();
    _syncTimer = null;
    await _localChanges?.cancel();
    _localChanges = null;
    for (final client in _clients.values) {
      client.close();
    }
    _clients.clear();
    _autoConnecting.clear();
    _pendingRejoinClients.clear();
    _uploads.clear();
    final peerSubscription = _peerSubscription;
    _peerSubscription = null;
    await peerSubscription?.cancel();
    final discovery = _discovery;
    _discovery = null;
    await discovery?.dispose();
    final server = _httpServer;
    _httpServer = null;
    await server?.close();
    _setStatus(PeerSyncStatus.stopped);
  }

  Future<void> pair(PeerDiscoveryPeer peer, String pairingCode) async {
    if (!isRunning) throw StateError('同步服务尚未启动');
    final previous = _clients.remove(peer.advertisement.deviceId);
    previous?.close();
    final trustToken = trustStore == null ? null : PeerTrustStore.issueToken();
    final client = await PeerHttpClient.connect(
      identity: identity,
      groupId: groupId,
      serverUri: peer.httpUri,
      pairingCode: pairingCode.trim(),
      expectedRemoteDeviceName: peer.advertisement.deviceName,
      callbackPort: localHttpPort,
      reversePairingCode: _activePairingCode().value,
      rememberToken: trustToken,
    );
    if (client.session.remoteDeviceId != peer.advertisement.deviceId) {
      client.close();
      throw StateError('对端设备身份与发现结果不一致');
    }
    _clients[peer.advertisement.deviceId] = client;
    if (trustToken != null) {
      await _rememberTrust(
        client.session.remoteDeviceId,
        client.session.remoteDeviceName,
        client.session.remoteIdentityPublicKey,
        trustToken,
      );
    }
    final rejoining = await _preparePairedClient(client);
    _syncError = null;
    notifyListeners();
    if (!rejoining) await syncAll();
  }

  PairingCode _activePairingCode() {
    final code = pairingCode;
    if (code != null) return code;
    refreshPairingCode();
    return pairingCode!;
  }

  Future<void> _connectBack(PeerReversePairing pairing) async {
    if (!isRunning ||
        await database?.isPeerPendingRejoin(pairing.deviceId) == true ||
        _clients.containsKey(pairing.deviceId)) {
      return;
    }
    try {
      final client = await PeerHttpClient.connect(
        identity: identity,
        groupId: groupId,
        serverUri: Uri(
          scheme: 'http',
          host: pairing.address.address,
          port: pairing.httpPort,
        ),
        pairingCode: pairing.pairingCode,
        expectedRemoteDeviceName: pairing.deviceName,
        expectedRemoteIdentityPublicKey: pairing.identityPublicKey,
        rememberToken: pairing.trustToken,
      );
      if (client.session.remoteDeviceId != pairing.deviceId) {
        client.close();
        throw StateError('对端设备身份与反向配对信息不一致');
      }
      _clients[pairing.deviceId] = client;
      if (pairing.trustToken != null) {
        await _rememberTrust(
          client.session.remoteDeviceId,
          client.session.remoteDeviceName,
          client.session.remoteIdentityPublicKey,
          pairing.trustToken!,
        );
      }
      final rejoining = await _preparePairedClient(client);
      notifyListeners();
      if (!rejoining) await syncAll();
    } catch (error) {
      _syncError = error;
      notifyListeners();
    }
  }

  Future<void> _autoConnect(PeerDiscoveryPeer peer) async {
    final store = trustStore;
    final deviceId = peer.advertisement.deviceId;
    if (!isRunning ||
        store == null ||
        _clients.containsKey(deviceId) ||
        !_autoConnecting.add(deviceId)) {
      return;
    }
    PeerHttpClient? client;
    try {
      final trust = await store.find(deviceId);
      if (trust == null ||
          await database?.isPeerRevoked(deviceId) == true ||
          await database?.isPeerPendingRejoin(deviceId) == true ||
          _clients.containsKey(deviceId)) {
        return;
      }
      client = await PeerHttpClient.connect(
        identity: identity,
        groupId: groupId,
        serverUri: peer.httpUri,
        pairingCode: trust.token,
        trustedToken: trust.token,
        rememberToken: trust.token,
        expectedRemoteDeviceName: peer.advertisement.deviceName,
        expectedRemoteIdentityPublicKey: trust.identityPublicKey,
      );
      if (client.session.remoteDeviceId != deviceId) {
        throw StateError('对端设备身份与已授权设备不一致');
      }
      if (_clients.containsKey(deviceId)) {
        client.close();
        return;
      }
      _clients[deviceId] = client;
      client = null;
      _syncError = null;
      notifyListeners();
      await syncAll();
    } catch (error) {
      client?.close();
      _syncError = error;
      notifyListeners();
    } finally {
      _autoConnecting.remove(deviceId);
    }
  }

  Future<void> _rememberTrust(
    String deviceId,
    String deviceName,
    List<int> identityPublicKey,
    String token,
  ) async {
    final store = trustStore;
    if (store == null) return;
    final current = await database?.peerDevice(deviceId);
    final pendingRejoin =
        current?.isRevoked == true || current?.isPendingRejoin == true;
    await store.save(
      PeerTrust(
        deviceId: deviceId,
        deviceName: deviceName,
        token: token,
        identityPublicKey: identityPublicKey,
      ),
    );
    await database?.rememberPeerDevice(
      deviceId: deviceId,
      deviceName: deviceName,
      identityPublicKey: identityPublicKey,
      pendingRejoin: pendingRejoin,
    );
  }

  Future<bool> _preparePairedClient(PeerHttpClient client) async {
    if (database == null) return false;
    final deviceId = client.session.remoteDeviceId;
    final localRequiresRejoin = await database!.isPeerPendingRejoin(deviceId);
    final status = _mapResult(
      await client.request({'kind': 'peer-status'}),
      'peer-status-result',
    );
    final remoteRequiresRejoin = status['requiresRejoin'] == true;
    if (remoteRequiresRejoin) {
      await _uploadRejoin(client, _syncVector(status['vector']));
    }
    if (localRequiresRejoin) await _pullRejoin(client);
    final rejoining = localRequiresRejoin || remoteRequiresRejoin;
    if (rejoining) _pendingRejoinClients.add(deviceId);
    return rejoining;
  }

  Future<void> removeDevice(String deviceId) async {
    final client = _clients.remove(deviceId);
    await database?.revokePeerDevice(deviceId);
    if (client != null) {
      try {
        await _syncWithClient(client);
      } catch (error) {
        _syncError = error;
      }
    }
    await trustStore?.remove(deviceId);
    client?.close();
    _httpServer?.disconnect(deviceId);
    notifyListeners();
  }

  Stream<List<PeerDevice>> watchDevices() =>
      _devices ??= database?.watchPeerDevices() ?? const Stream.empty();

  Stream<List<SyncConflict>> watchPendingConflicts() => _pendingConflicts ??=
      database?.watchPendingSyncConflicts() ?? const Stream.empty();

  Future<void> completeDeviceRejoin(String deviceId) async {
    await database?.completePeerRejoin(deviceId);
    notifyListeners();
  }

  Future<void> syncAll() async => _runSync();

  Future<int> manualSync() => _runSync(manual: true);

  Future<int> _runSync({bool manual = false}) async {
    if (manual) {
      _manualSyncing = true;
      _manualSyncRequested = true;
      notifyListeners();
    }
    if (_clients.isEmpty) {
      if (manual) {
        _publishSyncCompletion(0, manual: true);
        _manualSyncing = false;
        _manualSyncRequested = false;
        notifyListeners();
      }
      return 0;
    }
    final current = _syncFuture;
    if (current != null) return current;
    final future = _syncAll();
    _syncFuture = future;
    notifyListeners();
    try {
      final transferred = await future;
      _publishSyncCompletion(transferred, manual: _manualSyncRequested);
      return transferred;
    } finally {
      if (identical(_syncFuture, future)) _syncFuture = null;
      _manualSyncing = false;
      _manualSyncRequested = false;
      notifyListeners();
    }
  }

  Future<void> syncPeer(String deviceId) async {
    final current = _syncFuture;
    if (current != null) await current;
    final client = _clients[deviceId];
    if (client == null) throw StateError('设备尚未连接');
    await _syncWithClient(client);
  }

  Future<int> _syncAll() async {
    if (database == null) return 0;
    Object? firstError;
    var transferred = 0;
    for (final deviceId in _clients.keys.toList()..sort()) {
      final client = _clients[deviceId]!;
      try {
        if (await database?.isPeerRevoked(deviceId) == true) {
          client.close();
          _clients.remove(deviceId);
          continue;
        }
        if (_pendingRejoinClients.contains(deviceId)) {
          if (!await _finishPendingRejoin(client)) continue;
        }
        transferred += await _syncWithClient(client);
      } catch (error) {
        client.close();
        _clients.remove(deviceId);
        firstError ??= error;
      }
    }
    if (firstError != null) {
      _syncError = firstError;
      throw firstError;
    }
    return transferred;
  }

  Future<int> _syncWithClient(PeerHttpClient client) async {
    final db = database;
    if (db == null) return 0;
    var remoteVector = <String, int>{};
    var transferred = 0;
    for (var round = 0; round < 4; round++) {
      final localVector = await db.syncVector();
      final outgoing = await db.syncOperationsMissingFrom(remoteVector);
      final localMediaHashes = (await db.referencedImageHashes()).toList()
        ..sort();
      final response = await client.request({
        'kind': 'sync-batch',
        'vector': localVector,
        'operations': [for (final item in outgoing) syncOperationToJson(item)],
        'mediaHashes': localMediaHashes,
      });
      final result = _syncResult(response);
      remoteVector = _syncVector(result['vector']);
      final incoming = _syncOperations(result['operations']);
      final remoteApplied = result['applied'];
      if (remoteApplied is! int || remoteApplied < 0) {
        throw const FormatException('同步变更数量无效');
      }
      transferred += remoteApplied;
      transferred += await db.applyRemoteSyncOperations(incoming);
      await _uploadMedia(
        client,
        _syncImageHashes(result['missingMediaHashes']),
      );
      await _downloadMedia(client, _syncImageHashes(result['mediaHashes']));
      if (outgoing.isEmpty && incoming.isEmpty) break;
    }
    await db.recordPeerSyncState(client.session.remoteDeviceId, remoteVector);
    await _cleanupAcknowledgedDeletions();
    _lastSyncAtUtc = DateTime.now().toUtc();
    _lastSyncByDevice[client.session.remoteDeviceId] = _lastSyncAtUtc!;
    _syncError = null;
    notifyListeners();
    return transferred;
  }

  Future<void> _uploadRejoin(
    PeerHttpClient client,
    Map<String, int> remoteVector,
  ) async {
    final db = database;
    if (db == null) return;
    for (var round = 0; round < 16; round++) {
      final outgoing = await db.syncOperationsMissingFrom(
        remoteVector,
        forRejoin: true,
      );
      if (outgoing.isEmpty) break;
      final localMediaHashes = (await db.referencedImageHashes()).toList()
        ..sort();
      final result = _mapResult(
        await client.request({
          'kind': 'rejoin-upload',
          'operations': [
            for (final operation in outgoing) syncOperationToJson(operation),
          ],
          'mediaHashes': localMediaHashes,
        }),
        'rejoin-upload-result',
      );
      remoteVector = _syncVector(result['vector']);
      await _uploadMedia(
        client,
        _syncImageHashes(result['missingMediaHashes']),
      );
    }
  }

  Future<void> _pullRejoin(PeerHttpClient client) async {
    final db = database;
    if (db == null) return;
    for (var round = 0; round < 16; round++) {
      final result = _mapResult(
        await client.request({
          'kind': 'rejoin-download',
          'vector': await db.syncVector(),
        }),
        'rejoin-download-result',
      );
      final incoming = _syncOperations(result['operations']);
      if (incoming.isNotEmpty) {
        await db.receiveQuarantinedSyncOperations(
          client.session.remoteDeviceId,
          incoming,
        );
      }
      await _downloadMedia(client, _syncImageHashes(result['mediaHashes']));
      if (incoming.isEmpty) break;
    }
  }

  Future<bool> _finishPendingRejoin(PeerHttpClient client) async {
    if (await database?.isPeerPendingRejoin(client.session.remoteDeviceId) ==
        true) {
      await _pullRejoin(client);
      return false;
    }
    final status = _mapResult(
      await client.request({'kind': 'peer-status'}),
      'peer-status-result',
    );
    if (status['requiresRejoin'] == true) return false;
    _pendingRejoinClients.remove(client.session.remoteDeviceId);
    return true;
  }

  Future<Object?> _handleMessage(String remoteDeviceId, Object? payload) async {
    if (await database?.isPeerRevoked(remoteDeviceId) == true) {
      throw StateError('该设备已被移除');
    }
    if (payload is Map && payload['kind'] == 'peer-status') {
      return {
        'kind': 'peer-status-result',
        'requiresRejoin':
            await database?.isPeerPendingRejoin(remoteDeviceId) == true,
        'vector': await database?.syncVector() ?? const <String, int>{},
      };
    }
    if (await database?.isPeerPendingRejoin(remoteDeviceId) == true) {
      if (payload is Map && payload['kind'] == 'rejoin-upload') {
        return _receiveRejoinUpload(
          remoteDeviceId,
          Map<String, dynamic>.from(payload),
        );
      }
      throw StateError('该设备正在保护性重新加入');
    }
    if (payload is Map && payload['kind'] == 'rejoin-download') {
      final db = database;
      if (db == null) throw StateError('同步数据库尚未准备好');
      final request = Map<String, dynamic>.from(payload);
      final operations = await db.syncOperationsMissingFrom(
        _syncVector(request['vector']),
        forRejoin: true,
      );
      final localMediaHashes = (await db.referencedImageHashes()).toList()
        ..sort();
      return {
        'kind': 'rejoin-download-result',
        'operations': [
          for (final operation in operations) syncOperationToJson(operation),
        ],
        'mediaHashes': localMediaHashes,
      };
    }
    if (payload is Map && payload['kind'] == 'sync-batch') {
      final db = database;
      if (db == null) throw StateError('同步数据库尚未准备好');
      final request = Map<String, dynamic>.from(payload);
      final vector = _syncVector(request['vector']);
      final remoteMediaHashes = _syncImageHashes(request['mediaHashes']);
      await db.recordPeerSyncState(remoteDeviceId, vector);
      final applied = await db.applyRemoteSyncOperations(
        _syncOperations(request['operations']),
      );
      final operations = await db.syncOperationsMissingFrom(vector);
      final localMediaHashes = (await db.referencedImageHashes()).toList()
        ..sort();
      final missingMediaHashes = <String>[];
      final media = mediaStore;
      if (media != null) {
        for (final hash in remoteMediaHashes) {
          if (!await media.fileFor(hash).exists()) missingMediaHashes.add(hash);
        }
      }
      await _cleanupAcknowledgedDeletions();
      _lastSyncAtUtc = DateTime.now().toUtc();
      _lastSyncByDevice[remoteDeviceId] = _lastSyncAtUtc!;
      _syncError = null;
      if (applied > 0) {
        _publishSyncCompletion(applied, manual: false);
      } else {
        notifyListeners();
      }
      return {
        'kind': 'sync-batch-result',
        'vector': await db.syncVector(),
        'applied': applied,
        'operations': [
          for (final operation in operations) syncOperationToJson(operation),
        ],
        'mediaHashes': localMediaHashes,
        'missingMediaHashes': missingMediaHashes,
      };
    }
    if (payload is Map && payload['kind'] == 'media-chunk') {
      return _readMediaChunk(Map<String, dynamic>.from(payload));
    }
    if (payload is Map && payload['kind'] == 'media-put') {
      return _receiveMediaChunk(Map<String, dynamic>.from(payload));
    }
    if (payload is Map && payload['kind'] == 'ping') {
      return {'kind': 'pong', 'value': payload['value']};
    }
    return {'kind': 'echo', 'payload': payload};
  }

  Future<Map<String, Object?>> _receiveRejoinUpload(
    String remoteDeviceId,
    Map<String, dynamic> request,
  ) async {
    final db = database;
    if (db == null) throw StateError('同步数据库尚未准备好');
    final operations = _syncOperations(request['operations']);
    final result = await db.receiveQuarantinedSyncOperations(
      remoteDeviceId,
      operations,
    );
    final missingMediaHashes = <String>[];
    final media = mediaStore;
    if (media != null) {
      for (final hash in _syncImageHashes(request['mediaHashes'])) {
        if (!await media.fileFor(hash).exists()) missingMediaHashes.add(hash);
      }
    }
    return {
      'kind': 'rejoin-upload-result',
      'vector': await db.syncVector(),
      'accepted': result['accepted'],
      'conflicts': result['conflicts'],
      'missingMediaHashes': missingMediaHashes,
    };
  }

  Future<Map<String, Object?>> _readMediaChunk(
    Map<String, dynamic> request,
  ) async {
    final media = mediaStore;
    if (media == null) throw StateError('图片目录尚未准备好');
    final hash = _syncImageHash(request['hash']);
    final offset = _boundedInt(request['offset'], 0, _maxMediaBytes);
    final requested = _boundedInt(request['length'], 1, _mediaChunkBytes);
    final file = media.fileFor(hash);
    if (!await file.exists()) throw StateError('图片文件不存在');
    final totalBytes = await file.length();
    if (totalBytes <= 0 || totalBytes > _maxMediaBytes || offset > totalBytes) {
      throw const FormatException('图片文件大小无效');
    }
    final handle = await file.open();
    try {
      await handle.setPosition(offset);
      final bytes = await handle.read(min(requested, totalBytes - offset));
      return {
        'kind': 'media-chunk-result',
        'hash': hash,
        'offset': offset,
        'totalBytes': totalBytes,
        'data': base64Encode(bytes),
      };
    } finally {
      await handle.close();
    }
  }

  Future<Map<String, Object?>> _receiveMediaChunk(
    Map<String, dynamic> request,
  ) async {
    final media = mediaStore;
    if (media == null) throw StateError('图片目录尚未准备好');
    final hash = _syncImageHash(request['hash']);
    final totalBytes = _boundedInt(request['totalBytes'], 1, _maxMediaBytes);
    final offset = _boundedInt(request['offset'], 0, totalBytes);
    final encoded = request['data'];
    if (encoded is! String || encoded.length > _mediaChunkBytes * 2) {
      throw const FormatException('图片分块无效');
    }
    final bytes = base64Decode(encoded);
    if (bytes.isEmpty ||
        bytes.length > _mediaChunkBytes ||
        offset + bytes.length > totalBytes) {
      throw const FormatException('图片分块无效');
    }
    if (await media.fileFor(hash).exists()) {
      return {
        'kind': 'media-put-result',
        'hash': hash,
        'nextOffset': totalBytes,
        'complete': true,
      };
    }
    final upload = _uploads.putIfAbsent(hash, () => _MediaUpload(totalBytes));
    if (upload.totalBytes != totalBytes || upload.length != offset) {
      _uploads.remove(hash);
      throw const FormatException('图片分块顺序无效');
    }
    upload.bytes.add(bytes);
    final complete = upload.length == totalBytes;
    if (complete) {
      final data = upload.bytes.takeBytes();
      _uploads.remove(hash);
      if (await _hashBytes(data) != hash) {
        throw const FormatException('图片哈希校验失败');
      }
      await media.putJpeg(data);
    }
    return {
      'kind': 'media-put-result',
      'hash': hash,
      'nextOffset': complete ? totalBytes : upload.length,
      'complete': complete,
    };
  }

  Future<void> _uploadMedia(PeerHttpClient client, List<String> hashes) async {
    final media = mediaStore;
    if (media == null) return;
    for (final hash in hashes) {
      final file = media.fileFor(hash);
      if (!await file.exists()) throw StateError('本机缺少图片文件：$hash');
      final totalBytes = await file.length();
      if (totalBytes <= 0 || totalBytes > _maxMediaBytes) {
        throw const FormatException('图片文件大小无效');
      }
      final handle = await file.open();
      try {
        var offset = 0;
        while (offset < totalBytes) {
          await handle.setPosition(offset);
          final bytes = await handle.read(
            min(_mediaChunkBytes, totalBytes - offset),
          );
          final response = await client.request({
            'kind': 'media-put',
            'hash': hash,
            'offset': offset,
            'totalBytes': totalBytes,
            'data': base64Encode(bytes),
          });
          final result = _mapResult(response, 'media-put-result');
          if (result['hash'] != hash) {
            throw const FormatException('图片上传响应无效');
          }
          final nextOffset = _boundedInt(
            result['nextOffset'],
            offset + 1,
            totalBytes,
          );
          offset = nextOffset;
        }
      } finally {
        await handle.close();
      }
    }
  }

  Future<void> _downloadMedia(
    PeerHttpClient client,
    List<String> hashes,
  ) async {
    final media = mediaStore;
    if (media == null) return;
    for (final hash in hashes) {
      if (await media.fileFor(hash).exists()) continue;
      final bytes = BytesBuilder(copy: false);
      int? totalBytes;
      while (totalBytes == null || bytes.length < totalBytes) {
        final response = await client.request({
          'kind': 'media-chunk',
          'hash': hash,
          'offset': bytes.length,
          'length': _mediaChunkBytes,
        });
        final result = _mapResult(response, 'media-chunk-result');
        if (result['hash'] != hash || result['offset'] != bytes.length) {
          throw const FormatException('图片下载响应无效');
        }
        final nextTotal = _boundedInt(result['totalBytes'], 1, _maxMediaBytes);
        if (totalBytes != null && totalBytes != nextTotal) {
          throw const FormatException('图片大小在传输中改变');
        }
        totalBytes = nextTotal;
        final encoded = result['data'];
        if (encoded is! String || encoded.length > _mediaChunkBytes * 2) {
          throw const FormatException('图片下载分块无效');
        }
        final chunk = base64Decode(encoded);
        if (chunk.isEmpty ||
            chunk.length > _mediaChunkBytes ||
            bytes.length + chunk.length > totalBytes) {
          throw const FormatException('图片下载分块无效');
        }
        bytes.add(chunk);
      }
      final data = bytes.takeBytes();
      if (await _hashBytes(data) != hash) {
        throw const FormatException('图片哈希校验失败');
      }
      await media.putJpeg(data);
    }
  }

  Map<String, dynamic> _syncResult(Object? value) =>
      _mapResult(value, 'sync-batch-result');

  Map<String, dynamic> _mapResult(Object? value, String kind) {
    if (value is! Map) throw const FormatException('同步响应无效');
    final result = Map<String, dynamic>.from(value);
    if (result['kind'] != kind) {
      throw const FormatException('同步响应类型无效');
    }
    return result;
  }

  Map<String, int> _syncVector(Object? value) {
    if (value is! Map) throw const FormatException('同步位置向量无效');
    final vector = <String, int>{};
    for (final entry in value.entries) {
      if (entry.key is! String || entry.value is! int || entry.value < 0) {
        throw const FormatException('同步位置向量无效');
      }
      vector[entry.key as String] = entry.value as int;
    }
    return vector;
  }

  List<Map<String, dynamic>> _syncOperations(Object? value) {
    if (value is! List || value.length > 128) {
      throw const FormatException('同步操作批次无效');
    }
    return [
      for (final item in value)
        if (item is Map)
          Map<String, dynamic>.from(item)
        else
          throw const FormatException('同步操作无效'),
    ];
  }

  List<String> _syncImageHashes(Object? value) {
    if (value == null) return const [];
    if (value is! List || value.length > 512) {
      throw const FormatException('同步图片清单无效');
    }
    return [for (final item in value) _syncImageHash(item)];
  }

  String _syncImageHash(Object? value) {
    if (value is! String || !_imageHashPattern.hasMatch(value)) {
      throw const FormatException('图片标识无效');
    }
    return value;
  }

  int _boundedInt(Object? value, int minimum, int maximum) {
    if (value is! int || value < minimum || value > maximum) {
      throw const FormatException('数值范围无效');
    }
    return value;
  }

  Future<String> _hashBytes(List<int> bytes) async => (await Sha256().hash(
    bytes,
  )).bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  Future<void> _cleanupAcknowledgedDeletions() async {
    final db = database;
    if (db == null) return;
    final hashes = await db.purgeAcknowledgedDeletions();
    await mediaStore?.deleteHashes(hashes);
  }

  void _publishSyncCompletion(int transferred, {required bool manual}) {
    _lastSyncTransferredCount = transferred;
    _lastSyncWasManual = manual;
    _syncCompletionSerial++;
    notifyListeners();
  }

  void _setStatus(PeerSyncStatus value) {
    if (_status == value || _closed) return;
    _status = value;
    notifyListeners();
  }
}

class _MediaUpload {
  _MediaUpload(this.totalBytes);

  final int totalBytes;
  final BytesBuilder bytes = BytesBuilder(copy: false);
  int get length => bytes.length;
}
