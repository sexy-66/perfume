import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';

import 'peer_handshake.dart';

const _maxJsonBodyBytes = 64 * 1024;

class PeerHttpFailure implements Exception {
  const PeerHttpFailure(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'PeerHttpFailure($statusCode): $message';
}

class PeerReversePairing {
  const PeerReversePairing({
    required this.deviceId,
    required this.deviceName,
    required this.address,
    required this.httpPort,
    required this.pairingCode,
    this.identityPublicKey,
    this.trustToken,
  });

  final String deviceId;
  final String deviceName;
  final InternetAddress address;
  final int httpPort;
  final String pairingCode;
  final List<int>? identityPublicKey;
  final String? trustToken;
}

class PeerHttpServer {
  PeerHttpServer({
    required this.identity,
    required String groupId,
    required PairingCode pairingCode,
    required String expectedRemoteDeviceName,
    this.onMessage,
    this.onPaired,
    this.onReversePairing,
    this.trustedTokenForDevice,
    this.onTrustEstablished,
  }) : groupId = groupId.trim(),
       expectedRemoteDeviceName = expectedRemoteDeviceName.trim() {
    _pairingCode = pairingCode;
    if (this.groupId.isEmpty) throw ArgumentError.value(groupId, 'groupId');
    if (this.expectedRemoteDeviceName.isEmpty) {
      throw ArgumentError.value(
        expectedRemoteDeviceName,
        'expectedRemoteDeviceName',
      );
    }
  }

  final PeerIdentity identity;
  final String groupId;
  final String expectedRemoteDeviceName;
  final Future<Object?> Function(String remoteDeviceId, Object? payload)?
  onMessage;
  final void Function()? onPaired;
  final void Function(PeerReversePairing pairing)? onReversePairing;
  final Future<String?> Function(String deviceId, List<int> identityPublicKey)?
  trustedTokenForDevice;
  final Future<void> Function(
    String deviceId,
    String deviceName,
    List<int> identityPublicKey,
    String trustToken,
  )?
  onTrustEstablished;
  late PairingCode _pairingCode;

  HttpServer? _server;
  final Map<String, _PeerServerAttempt> _attempts = {};
  final Map<String, PeerSession> _sessions = {};

  bool get isListening => _server != null;
  bool get isPaired => _sessions.isNotEmpty;
  PairingCode get pairingCode => _pairingCode;
  Set<String> get pairedDeviceIds => Set.unmodifiable(_sessions.keys);

  Uri get uri {
    final server = _server;
    if (server == null) throw StateError('HTTP服务尚未启动');
    return Uri(scheme: 'http', host: server.address.address, port: server.port);
  }

  Future<Uri> start({InternetAddress? address, int port = 0}) async {
    if (_server != null) return uri;
    _server = await HttpServer.bind(
      address ?? InternetAddress.loopbackIPv4,
      port,
    );
    _server!.listen(_handle);
    return uri;
  }

  Future<void> close() async {
    for (final attempt in _attempts.values) {
      attempt.session?.close();
    }
    for (final session in _sessions.values) {
      session.close();
    }
    _attempts.clear();
    _sessions.clear();
    final server = _server;
    _server = null;
    await server?.close(force: true);
  }

  void refreshPairingCode() {
    for (final attempt in _attempts.values) {
      attempt.session?.close();
    }
    _attempts.clear();
    _pairingCode = PairingCode.issue();
  }

  void disconnect(String deviceId) {
    _attempts.remove(deviceId)?.session?.close();
    _sessions.remove(deviceId)?.close();
  }

  Future<void> _handle(HttpRequest request) async {
    try {
      if (request.method != 'POST') {
        throw const _PeerHttpFailure(405, '只支持POST');
      }
      final body = await _readJson(request);
      late final Map<String, dynamic> response;
      switch (request.uri.path) {
        case '/m5/hello':
          response = await _receiveHello(body);
        case '/m5/proof':
          response = await _receiveProof(body);
        case '/m5/confirm':
          response = await _receiveConfirmation(
            body,
            request.connectionInfo?.remoteAddress,
          );
        case '/m5/message':
          response = await _receiveMessage(body);
        default:
          throw const _PeerHttpFailure(404, '路径不存在');
      }
      await _writeJson(request.response, 200, response);
    } on _PeerHttpFailure catch (error) {
      await _writeJson(request.response, error.statusCode, {
        'error': error.message,
      });
    } on Object {
      await _writeJson(request.response, 400, {'error': '请求无效'});
    }
  }

  Future<Map<String, dynamic>> _receiveHello(Map<String, dynamic> body) async {
    final remoteHello = PeerHandshakeHello.fromJson(_map(body['hello']));
    final trustedToken = await trustedTokenForDevice?.call(
      remoteHello.deviceId,
      remoteHello.identityPublicKey,
    );
    final pairingCode = _pairingCode;
    if (trustedToken == null && !pairingCode.isActive) {
      throw const _PeerHttpFailure(410, '配对码不可用');
    }

    _attempts.remove(remoteHello.deviceId)?.session?.close();
    final handshake = await PeerHandshake.create(
      identity: identity,
      groupId: groupId,
      role: PeerHandshakeRole.responder,
    );
    final localProof = await handshake.sign(
      remoteHello,
      trustToken: trustedToken,
    );
    _attempts[remoteHello.deviceId] = _PeerServerAttempt(
      remoteHello: remoteHello,
      handshake: handshake,
      localProof: localProof,
      pairingCode: pairingCode,
      trustedToken: trustedToken,
    );
    return {'hello': handshake.hello.toJson()};
  }

  Future<Map<String, dynamic>> _receiveProof(Map<String, dynamic> body) async {
    final remoteProof = PeerHandshakeProof.fromJson(_map(body['proof']));
    _PeerServerAttempt? attempt;
    for (final candidate in _attempts.values) {
      if (constantTimeBytesEquality.equals(
        candidate.remoteHello.identityPublicKey,
        remoteProof.identityPublicKey,
      )) {
        attempt = candidate;
        break;
      }
    }
    if (attempt == null) {
      throw const _PeerHttpFailure(409, '缺少握手请求');
    }
    try {
      final trusted =
          attempt.trustedToken != null &&
          constantTimeBytesEquality.equals(
            remoteProof.trustedProof ?? const [],
            attempt.localProof.trustedProof ?? const [],
          );
      if (!trusted && !attempt.pairingCode.isActive) {
        throw const _PeerHttpFailure(410, '配对码不可用');
      }
      attempt.trusted = trusted;
      attempt.pairingSecret = trusted
          ? attempt.trustedToken!
          : attempt.pairingCode.value;
      attempt.session = await attempt.handshake.finish(
        attempt.remoteHello,
        remoteProof: remoteProof,
        pairingCode: attempt.pairingSecret!,
        expectedRemoteDeviceName: attempt.remoteHello.deviceName,
        trustToken: trusted ? attempt.trustedToken : null,
      );
      return {'proof': attempt.localProof.toJson()};
    } catch (error) {
      _resetAttempt(attempt.remoteHello.deviceId);
      if (error is PeerHttpFailure) rethrow;
      throw const _PeerHttpFailure(400, '握手验证失败');
    }
  }

  Future<Map<String, dynamic>> _receiveConfirmation(
    Map<String, dynamic> body,
    InternetAddress? remoteAddress,
  ) async {
    _PeerServerAttempt? attempt;
    try {
      final message = PeerEncryptedMessage.fromJson(_map(body['message']));
      for (final candidate in _attempts.values) {
        if (candidate.session?.sessionId == message.sessionId) {
          attempt = candidate;
          break;
        }
      }
      final session = attempt?.session;
      if (attempt == null || session == null) {
        throw const _PeerHttpFailure(409, '会话尚未建立');
      }
      final payload = await session.decryptJson(message);
      if (payload is! Map ||
          payload['kind'] != 'm5-confirm' ||
          payload['sessionId'] != session.sessionId) {
        throw const _PeerHttpFailure(401, '会话确认内容无效');
      }
      PeerReversePairing? reversePairing;
      final callbackPort = payload['callbackPort'];
      final reverseCode = payload['reversePairingCode'];
      final trustToken = payload['trustToken'];
      if (trustToken != null) _validateTrustToken(trustToken);
      if (callbackPort != null || reverseCode != null) {
        if (remoteAddress == null ||
            callbackPort is! int ||
            callbackPort < 1 ||
            callbackPort > 65535 ||
            reverseCode is! String ||
            !RegExp(r'^\d{6}$').hasMatch(reverseCode)) {
          throw const _PeerHttpFailure(400, '反向配对信息无效');
        }
        reversePairing = PeerReversePairing(
          deviceId: attempt.remoteHello.deviceId,
          deviceName: attempt.remoteHello.deviceName,
          address: remoteAddress,
          httpPort: callbackPort,
          pairingCode: reverseCode,
          identityPublicKey: attempt.remoteHello.identityPublicKey,
          trustToken: trustToken as String?,
        );
      }
      if (!attempt.trusted && !attempt.pairingCode.consume()) {
        throw const _PeerHttpFailure(410, '配对码不可用');
      }
      final acknowledgement = await session.encryptJson({
        'kind': 'm5-confirmed',
        'sessionId': session.sessionId,
      });
      _sessions.remove(attempt.remoteHello.deviceId)?.close();
      _sessions[attempt.remoteHello.deviceId] = session;
      _attempts.remove(attempt.remoteHello.deviceId);
      _pairingCode = PairingCode.issue();
      if (trustToken is String) {
        await onTrustEstablished?.call(
          attempt.remoteHello.deviceId,
          attempt.remoteHello.deviceName,
          attempt.remoteHello.identityPublicKey,
          trustToken,
        );
      }
      onPaired?.call();
      if (reversePairing != null) onReversePairing?.call(reversePairing);
      return {'message': acknowledgement.toJson()};
    } on _PeerHttpFailure {
      if (attempt?.trusted != true) attempt?.pairingCode.registerFailure();
      if (attempt != null) _resetAttempt(attempt.remoteHello.deviceId);
      rethrow;
    } on Object {
      if (attempt?.trusted != true) attempt?.pairingCode.registerFailure();
      if (attempt != null) _resetAttempt(attempt.remoteHello.deviceId);
      throw const _PeerHttpFailure(401, '会话确认失败');
    }
  }

  Future<Map<String, dynamic>> _receiveMessage(
    Map<String, dynamic> body,
  ) async {
    final message = PeerEncryptedMessage.fromJson(_map(body['message']));
    PeerSession? session;
    for (final candidate in _sessions.values) {
      if (candidate.sessionId == message.sessionId) {
        session = candidate;
        break;
      }
    }
    if (session == null) {
      throw const _PeerHttpFailure(409, '会话尚未确认');
    }

    try {
      final payload = await session.decryptJson(message);
      final responsePayload = onMessage == null
          ? payload is Map && payload['kind'] == 'ping'
                ? {'kind': 'pong', 'value': payload['value']}
                : {'kind': 'echo', 'payload': payload}
          : await onMessage!(session.remoteDeviceId, payload);
      final response = await session.encryptJson(responsePayload);
      return {'message': response.toJson()};
    } on PeerHttpFailure {
      rethrow;
    } on SecretBoxAuthenticationError {
      throw const _PeerHttpFailure(401, '消息认证失败');
    } on Object {
      throw const _PeerHttpFailure(400, '消息无效');
    }
  }

  void _resetAttempt(String deviceId) {
    _attempts.remove(deviceId)?.session?.close();
  }
}

class _PeerServerAttempt {
  _PeerServerAttempt({
    required this.remoteHello,
    required this.handshake,
    required this.localProof,
    required this.pairingCode,
    required this.trustedToken,
  });

  final PeerHandshakeHello remoteHello;
  final PeerHandshake handshake;
  final PeerHandshakeProof localProof;
  final PairingCode pairingCode;
  final String? trustedToken;
  bool trusted = false;
  String? pairingSecret;
  PeerSession? session;
}

class PeerHttpClient {
  PeerHttpClient._({
    required this._client,
    required this.serverUri,
    required this.session,
  });

  final HttpClient _client;
  final Uri serverUri;
  final PeerSession session;
  bool _closed = false;

  static Future<PeerHttpClient> connect({
    required PeerIdentity identity,
    required String groupId,
    required Uri serverUri,
    required String pairingCode,
    required String expectedRemoteDeviceName,
    List<int>? expectedRemoteIdentityPublicKey,
    int? callbackPort,
    String? reversePairingCode,
    String? trustedToken,
    String? rememberToken,
  }) async {
    if ((callbackPort == null) != (reversePairingCode == null) ||
        (callbackPort != null &&
            (callbackPort < 1 ||
                callbackPort > 65535 ||
                !RegExp(r'^\d{6}$').hasMatch(reversePairingCode!)))) {
      throw ArgumentError('反向配对信息无效');
    }
    if (trustedToken != null) _validateTrustToken(trustedToken);
    if (rememberToken != null) _validateTrustToken(rememberToken);
    final client = HttpClient();
    PeerSession? session;
    try {
      final handshake = await PeerHandshake.create(
        identity: identity,
        groupId: groupId,
        role: PeerHandshakeRole.initiator,
      );
      final helloResponse = await _postJson(client, serverUri, '/m5/hello', {
        'hello': handshake.hello.toJson(),
      });
      final remoteHello = PeerHandshakeHello.fromJson(
        _map(helloResponse['hello']),
      );
      if (expectedRemoteIdentityPublicKey != null &&
          !constantTimeBytesEquality.equals(
            remoteHello.identityPublicKey,
            expectedRemoteIdentityPublicKey,
          )) {
        throw const PeerHttpFailure(401, '对端设备身份已变化');
      }
      final proof = await handshake.sign(remoteHello, trustToken: trustedToken);
      final proofResponse = await _postJson(client, serverUri, '/m5/proof', {
        'proof': proof.toJson(),
      });
      final remoteProof = PeerHandshakeProof.fromJson(
        _map(proofResponse['proof']),
      );
      session = await handshake.finish(
        remoteHello,
        remoteProof: remoteProof,
        pairingCode: trustedToken ?? pairingCode,
        expectedRemoteDeviceName: expectedRemoteDeviceName,
        trustToken: trustedToken,
      );
      final confirmationPayload = <String, Object?>{
        'kind': 'm5-confirm',
        'sessionId': session.sessionId,
        'callbackPort': callbackPort,
        'reversePairingCode': reversePairingCode,
        'trustToken': rememberToken ?? trustedToken,
      };
      final confirmation = await session.encryptJson(confirmationPayload);
      final confirmationResponse = await _postJson(
        client,
        serverUri,
        '/m5/confirm',
        {'message': confirmation.toJson()},
      );
      final acknowledgement = await session.decryptJson(
        PeerEncryptedMessage.fromJson(_map(confirmationResponse['message'])),
      );
      if (acknowledgement is! Map ||
          acknowledgement['kind'] != 'm5-confirmed' ||
          acknowledgement['sessionId'] != session.sessionId) {
        throw const PeerHttpFailure(400, '服务端确认无效');
      }
      return PeerHttpClient._(
        client: client,
        serverUri: serverUri,
        session: session,
      );
    } catch (error) {
      session?.close();
      client.close(force: true);
      rethrow;
    }
  }

  Future<Object?> request(Object? payload) async {
    if (_closed) throw StateError('HTTP会话已关闭');
    final message = await session.encryptJson(payload);
    final response = await _postJson(_client, serverUri, '/m5/message', {
      'message': message.toJson(),
    });
    return session.decryptJson(
      PeerEncryptedMessage.fromJson(_map(response['message'])),
    );
  }

  void close() {
    if (_closed) return;
    _closed = true;
    session.close();
    _client.close(force: true);
  }
}

Future<Map<String, dynamic>> _postJson(
  HttpClient client,
  Uri baseUri,
  String path,
  Map<String, dynamic> body,
) async {
  final request = await client.postUrl(baseUri.resolve(path));
  final bytes = utf8.encode(jsonEncode(body));
  request.headers.contentType = ContentType.json;
  request.contentLength = bytes.length;
  request.add(bytes);
  final response = await request.close();
  final responseBody = await _readJson(response);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw PeerHttpFailure(
      response.statusCode,
      responseBody['error'] as String? ?? 'HTTP请求失败',
    );
  }
  return responseBody;
}

Future<Map<String, dynamic>> _readJson(Stream<List<int>> stream) async {
  final bytes = <int>[];
  await for (final chunk in stream) {
    if (bytes.length + chunk.length > _maxJsonBodyBytes) {
      throw const _PeerHttpFailure(413, '请求体过大');
    }
    bytes.addAll(chunk);
  }
  final decoded = jsonDecode(utf8.decode(bytes));
  return _map(decoded);
}

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) throw const FormatException('JSON对象无效');
  return Map<String, dynamic>.from(value);
}

void _validateTrustToken(Object? value) {
  if (value is! String) throw const FormatException('信任令牌无效');
  try {
    if (base64Url.decode(value).length != 32) {
      throw const FormatException('信任令牌长度无效');
    }
  } on FormatException {
    rethrow;
  } on Object {
    throw const FormatException('信任令牌编码无效');
  }
}

class _PeerHttpFailure implements Exception {
  const _PeerHttpFailure(this.statusCode, this.message);

  final int statusCode;
  final String message;
}

Future<void> _writeJson(
  HttpResponse response,
  int statusCode,
  Map<String, dynamic> body,
) async {
  final bytes = utf8.encode(jsonEncode(body));
  response.statusCode = statusCode;
  response.headers.contentType = ContentType.json;
  response.contentLength = bytes.length;
  response.add(bytes);
  await response.close();
}
