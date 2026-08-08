import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'peer_handshake.dart';

class PeerIdentitySettings {
  const PeerIdentitySettings({required this.identity, required this.groupId});

  final PeerIdentity identity;
  final String groupId;
}

class PeerTrust {
  const PeerTrust({
    required this.deviceId,
    required this.deviceName,
    required this.token,
    required this.identityPublicKey,
  });

  final String deviceId;
  final String deviceName;
  final String token;
  final List<int> identityPublicKey;
}

class PeerTrustStore {
  PeerTrustStore(this.file);

  final File file;
  Map<String, PeerTrust>? _peers;
  Future<void> _writeTail = Future<void>.value();

  static Future<PeerTrustStore> defaults() async {
    final directory = await getApplicationSupportDirectory();
    return PeerTrustStore(File(p.join(directory.path, 'peer-trust.json')));
  }

  Future<Map<String, PeerTrust>> all() async {
    final cached = _peers;
    if (cached != null) return Map.unmodifiable(cached);
    if (!await file.exists()) {
      _peers = {};
      return const {};
    }
    final json = _map(jsonDecode(await file.readAsString()));
    if (json['version'] != 1 || json['peers'] is! List) {
      throw const FormatException('璇濈敤璁惧鏂囦欢鐗堟湰鏃犳晥');
    }
    final peers = <String, PeerTrust>{};
    for (final value in json['peers'] as List) {
      final peer = _peer(value);
      peers[peer.deviceId] = peer;
    }
    _peers = peers;
    return Map.unmodifiable(peers);
  }

  Future<PeerTrust?> find(String deviceId) async => (await all())[deviceId];

  Future<void> save(PeerTrust peer) async {
    final validated = _validatedPeer(peer);
    final write = _writeTail.then((_) async {
      final peers = Map<String, PeerTrust>.of(await all())
        ..[validated.deviceId] = validated;
      await _write({
        'version': 1,
        'peers': [for (final item in peers.values) _peerJson(item)],
      });
      _peers = peers;
    });
    _writeTail = write.catchError((_) {});
    await write;
  }

  Future<void> remove(String deviceId) async {
    final write = _writeTail.then((_) async {
      final peers = Map<String, PeerTrust>.of(await all())..remove(deviceId);
      await _write({
        'version': 1,
        'peers': [for (final item in peers.values) _peerJson(item)],
      });
      _peers = peers;
    });
    _writeTail = write.catchError((_) {});
    await write;
  }

  Future<void> reset() async {
    await _writeTail;
    if (await file.exists()) await file.delete();
    _peers = {};
  }

  static String issueToken() => base64Url.encode(
    List<int>.generate(32, (_) => Random.secure().nextInt(256)),
  );

  Future<void> _write(Map<String, Object?> value) async {
    await file.parent.create(recursive: true);
    final temporary = File('${file.path}.tmp');
    if (await temporary.exists()) await temporary.delete();
    await temporary.writeAsString(jsonEncode(value), flush: true);
    await temporary.rename(file.path);
  }
}

class PeerIdentityStore {
  PeerIdentityStore(this.file);

  static const defaultDeviceName = '香方簿设备';
  static const defaultGroupId = 'xiangfangbu-m5';

  final File file;

  static Future<PeerIdentityStore> defaults() async {
    final directory = await getApplicationSupportDirectory();
    return PeerIdentityStore(
      File(p.join(directory.path, 'peer-identity.json')),
    );
  }

  Future<PeerIdentitySettings> loadOrCreate({
    required String deviceId,
    String deviceName = defaultDeviceName,
    String groupId = defaultGroupId,
  }) async {
    if (await file.exists()) {
      final decoded = jsonDecode(await file.readAsString());
      final json = _map(decoded);
      if (json['version'] != 1) {
        throw const FormatException('设备身份文件版本无效');
      }
      final storedDeviceId = _text(json['deviceId'], 'deviceId');
      if (storedDeviceId != deviceId) {
        throw StateError('设备身份与本地数据库不一致，请重新配对');
      }
      var storedDeviceName = _text(json['deviceName'], 'deviceName');
      final preferredDeviceName = _text(deviceName, 'deviceName');
      if (storedDeviceName == defaultDeviceName &&
          preferredDeviceName != defaultDeviceName) {
        storedDeviceName = preferredDeviceName;
        json['deviceName'] = storedDeviceName;
        await _write(json);
      }
      final storedGroupId = _text(json['groupId'], 'groupId');
      final seed = _seed(json['ed25519Seed']);
      try {
        final keyPair = await Ed25519().newKeyPairFromSeed(seed);
        return PeerIdentitySettings(
          identity: PeerIdentity(
            deviceId: storedDeviceId,
            deviceName: storedDeviceName,
            signingKeyPair: keyPair,
          ),
          groupId: storedGroupId,
        );
      } finally {
        seed.fillRange(0, seed.length, 0);
      }
    }

    final identity = await PeerIdentity.create(
      deviceId: deviceId,
      deviceName: deviceName,
    );
    final seed = List<int>.from(
      await (identity.signingKeyPair as SimpleKeyPair).extractPrivateKeyBytes(),
    );
    try {
      await _write({
        'version': 1,
        'deviceId': identity.deviceId,
        'deviceName': identity.deviceName,
        'groupId': _text(groupId, 'groupId'),
        'ed25519Seed': base64Url.encode(seed),
      });
    } catch (_) {
      identity.signingKeyPair.destroy();
      rethrow;
    } finally {
      seed.fillRange(0, seed.length, 0);
    }
    return PeerIdentitySettings(identity: identity, groupId: groupId.trim());
  }

  Future<bool> resetIfDeviceChanged(String deviceId) async {
    final expectedDeviceId = _text(deviceId, 'deviceId');
    if (!await file.exists()) return false;
    final json = _map(jsonDecode(await file.readAsString()));
    if (json['version'] != 1) return false;
    if (_text(json['deviceId'], 'deviceId') == expectedDeviceId) return false;
    await file.delete();
    return true;
  }

  Future<void> _write(Map<String, Object?> value) async {
    await file.parent.create(recursive: true);
    final temporary = File('${file.path}.tmp');
    if (await temporary.exists()) await temporary.delete();
    await temporary.writeAsString(jsonEncode(value), flush: true);
    await temporary.rename(file.path);
  }
}

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) throw const FormatException('设备身份文件格式无效');
  return Map<String, dynamic>.from(value);
}

String _text(Object? value, String field) {
  if (value is! String) throw FormatException('$field 无效');
  final normalized = value.trim();
  if (normalized.isEmpty || normalized.length > 128) {
    throw FormatException('$field 无效');
  }
  return normalized;
}

List<int> _seed(Object? value) {
  if (value is! String) throw const FormatException('身份密钥无效');
  try {
    final decoded = base64Url.decode(value);
    if (decoded.length != 32) throw const FormatException('身份密钥长度无效');
    return List<int>.from(decoded);
  } on FormatException {
    rethrow;
  } on Object {
    throw const FormatException('身份密钥编码无效');
  }
}

PeerTrust _peer(Object? value) {
  final json = _map(value);
  final deviceId = _text(json['deviceId'], 'deviceId');
  final deviceName = _text(json['deviceName'], 'deviceName');
  final token = _token(json['token']);
  final publicKey = _bytes(json['identityPublicKey'], 32, 'identityPublicKey');
  return PeerTrust(
    deviceId: deviceId,
    deviceName: deviceName,
    token: token,
    identityPublicKey: publicKey,
  );
}

PeerTrust _validatedPeer(PeerTrust peer) => PeerTrust(
  deviceId: _text(peer.deviceId, 'deviceId'),
  deviceName: _text(peer.deviceName, 'deviceName'),
  token: _token(peer.token),
  identityPublicKey: _validatedBytes(
    peer.identityPublicKey,
    32,
    'identityPublicKey',
  ),
);

Map<String, Object?> _peerJson(PeerTrust peer) => {
  'deviceId': peer.deviceId,
  'deviceName': peer.deviceName,
  'token': peer.token,
  'identityPublicKey': base64Url.encode(peer.identityPublicKey),
};

String _token(Object? value) {
  if (value is! String) throw const FormatException('璇濈敤浠ょ墝鏃犳晥');
  try {
    final decoded = base64Url.decode(value);
    if (decoded.length != 32) throw const FormatException('璇濈敤浠ょ墝闀垮害鏃犳晥');
    return value;
  } on FormatException {
    rethrow;
  } on Object {
    throw const FormatException('璇濈敤浠ょ墝缂栫爜鏃犳晥');
  }
}

List<int> _bytes(Object? value, int length, String field) {
  if (value is! String) throw FormatException('$field 鏃犳晥');
  try {
    final decoded = base64Url.decode(value);
    if (decoded.length != length) throw FormatException('$field 闀垮害鏃犳晥');
    return List<int>.unmodifiable(decoded);
  } on FormatException {
    rethrow;
  } on Object {
    throw FormatException('$field 缂栫爜鏃犳晥');
  }
}

List<int> _validatedBytes(List<int> value, int length, String field) {
  if (value.length != length || value.any((byte) => byte < 0 || byte > 255)) {
    throw FormatException('$field 无效');
  }
  return List<int>.unmodifiable(value);
}
