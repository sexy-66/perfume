import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';

const _protocolVersion = 'xiangfangbu/peer-v1';
const _identityKeyLength = 32;
const _ephemeralKeyLength = 32;
const _challengeLength = 32;
const _signatureLength = 64;
const _trustProofLength = 32;
const _sessionKeyLength = 32;
const _sessionKeyMaterialLength = _sessionKeyLength * 2;
const _messageNonceLength = 12;
const _messageMacLength = 16;

enum PeerHandshakeRole { initiator, responder }

class PairingCode {
  PairingCode._({
    required this.value,
    required this.expiresAtUtc,
    required this.maxAttempts,
  });

  factory PairingCode.issue({
    DateTime? now,
    Duration lifetime = const Duration(minutes: 2),
    int maxAttempts = 5,
    Random? random,
  }) {
    if (lifetime <= Duration.zero) {
      throw ArgumentError.value(lifetime, 'lifetime');
    }
    if (maxAttempts <= 0) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts');
    }
    final source = random ?? Random.secure();
    final issuedAt = (now ?? DateTime.now()).toUtc();
    final value = source.nextInt(1000000).toString().padLeft(6, '0');
    return PairingCode._(
      value: value,
      expiresAtUtc: issuedAt.add(lifetime),
      maxAttempts: maxAttempts,
    );
  }

  factory PairingCode.fromValue(
    String value, {
    DateTime? now,
    Duration lifetime = const Duration(minutes: 2),
    int maxAttempts = 5,
  }) {
    _validatePairingCode(value);
    if (lifetime <= Duration.zero) {
      throw ArgumentError.value(lifetime, 'lifetime');
    }
    if (maxAttempts <= 0) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts');
    }
    final issuedAt = (now ?? DateTime.now()).toUtc();
    return PairingCode._(
      value: value,
      expiresAtUtc: issuedAt.add(lifetime),
      maxAttempts: maxAttempts,
    );
  }

  final String value;
  final DateTime expiresAtUtc;
  final int maxAttempts;

  int _failedAttempts = 0;
  bool _used = false;

  int get failedAttempts => _failedAttempts;
  bool get isConsumed => _used;
  bool get isActive => isActiveAt();

  bool isActiveAt({DateTime? now}) {
    final current = (now ?? DateTime.now()).toUtc();
    return !_used &&
        _failedAttempts < maxAttempts &&
        current.isBefore(expiresAtUtc);
  }

  bool registerFailure({DateTime? now}) {
    if (!isActiveAt(now: now)) return false;
    _failedAttempts++;
    return true;
  }

  bool consume({DateTime? now}) {
    if (!isActiveAt(now: now)) return false;
    _used = true;
    return true;
  }

  bool verify(String candidate, {DateTime? now}) {
    final current = (now ?? DateTime.now()).toUtc();
    if (!isActiveAt(now: current)) return false;

    final valid =
        RegExp(r'^\d{6}$').hasMatch(candidate) &&
        constantTimeBytesEquality.equals(
          utf8.encode(candidate),
          utf8.encode(value),
        );
    if (!valid) {
      registerFailure(now: current);
      return false;
    }
    return consume(now: current);
  }
}

class PeerIdentity {
  PeerIdentity({
    required String deviceId,
    required String deviceName,
    required this.signingKeyPair,
  }) : deviceId = _text(deviceId, 'deviceId'),
       deviceName = _text(deviceName, 'deviceName');

  static Future<PeerIdentity> create({
    required String deviceId,
    required String deviceName,
  }) async {
    return PeerIdentity(
      deviceId: deviceId,
      deviceName: deviceName,
      signingKeyPair: await Ed25519().newKeyPair(),
    );
  }

  final String deviceId;
  final String deviceName;
  final KeyPair signingKeyPair;
}

class PeerHandshakeHello {
  PeerHandshakeHello({
    required String groupId,
    required String deviceId,
    required String deviceName,
    required this.role,
    required List<int> identityPublicKey,
    required List<int> ephemeralPublicKey,
    required List<int> challenge,
  }) : groupId = _text(groupId, 'groupId'),
       deviceId = _text(deviceId, 'deviceId'),
       deviceName = _text(deviceName, 'deviceName'),
       identityPublicKey = List.unmodifiable(
         _bytes(identityPublicKey, _identityKeyLength, 'identityPublicKey'),
       ),
       ephemeralPublicKey = List.unmodifiable(
         _bytes(ephemeralPublicKey, _ephemeralKeyLength, 'ephemeralPublicKey'),
       ),
       challenge = List.unmodifiable(
         _bytes(challenge, _challengeLength, 'challenge'),
       );

  static const protocolVersion = _protocolVersion;

  final String groupId;
  final String deviceId;
  final String deviceName;
  final PeerHandshakeRole role;
  final List<int> identityPublicKey;
  final List<int> ephemeralPublicKey;
  final List<int> challenge;

  Map<String, dynamic> toJson() => {
    'version': protocolVersion,
    'groupId': groupId,
    'deviceId': deviceId,
    'deviceName': deviceName,
    'role': _roleName(role),
    'identityPublicKey': base64Url.encode(identityPublicKey),
    'ephemeralPublicKey': base64Url.encode(ephemeralPublicKey),
    'challenge': base64Url.encode(challenge),
  };

  factory PeerHandshakeHello.fromJson(Map<String, dynamic> json) {
    final version = _jsonText(json['version'], 'version');
    if (version != protocolVersion) {
      throw FormatException('不支持的握手版本：$version');
    }
    return PeerHandshakeHello(
      groupId: _jsonText(json['groupId'], 'groupId'),
      deviceId: _jsonText(json['deviceId'], 'deviceId'),
      deviceName: _jsonText(json['deviceName'], 'deviceName'),
      role: _parseRole(json['role']),
      identityPublicKey: _jsonBytes(
        json['identityPublicKey'],
        _identityKeyLength,
        'identityPublicKey',
      ),
      ephemeralPublicKey: _jsonBytes(
        json['ephemeralPublicKey'],
        _ephemeralKeyLength,
        'ephemeralPublicKey',
      ),
      challenge: _jsonBytes(json['challenge'], _challengeLength, 'challenge'),
    );
  }
}

class PeerHandshakeProof {
  PeerHandshakeProof({
    required List<int> identityPublicKey,
    required List<int> signature,
    List<int>? trustedProof,
  }) : identityPublicKey = List.unmodifiable(
         _bytes(identityPublicKey, _identityKeyLength, 'identityPublicKey'),
       ),
       signature = List.unmodifiable(
         _bytes(signature, _signatureLength, 'signature'),
       ),
       trustedProof = trustedProof == null
           ? null
           : List.unmodifiable(
               _bytes(trustedProof, _trustProofLength, 'trustedProof'),
             );

  final List<int> identityPublicKey;
  final List<int> signature;
  final List<int>? trustedProof;

  Map<String, dynamic> toJson() => {
    'identityPublicKey': base64Url.encode(identityPublicKey),
    'signature': base64Url.encode(signature),
    if (trustedProof != null) 'trustedProof': base64Url.encode(trustedProof!),
  };

  factory PeerHandshakeProof.fromJson(Map<String, dynamic> json) {
    return PeerHandshakeProof(
      identityPublicKey: _jsonBytes(
        json['identityPublicKey'],
        _identityKeyLength,
        'identityPublicKey',
      ),
      signature: _jsonBytes(json['signature'], _signatureLength, 'signature'),
      trustedProof: json['trustedProof'] == null
          ? null
          : _jsonBytes(json['trustedProof'], _trustProofLength, 'trustedProof'),
    );
  }
}

class PeerHandshake {
  PeerHandshake._({
    required this.identity,
    required this.groupId,
    required this.role,
    required this.hello,
    required this._ephemeralKeyPair,
  });

  static Future<PeerHandshake> create({
    required PeerIdentity identity,
    required String groupId,
    required PeerHandshakeRole role,
  }) async {
    final normalizedGroupId = _text(groupId, 'groupId');
    final signingPublicKey = await identity.signingKeyPair.extractPublicKey();
    final ephemeralKeyPair = await X25519().newKeyPair();
    final ephemeralPublicKey = await ephemeralKeyPair.extractPublicKey();
    if (signingPublicKey is! SimplePublicKey ||
        signingPublicKey.type != KeyPairType.ed25519) {
      ephemeralKeyPair.destroy();
      throw StateError('身份密钥必须使用 Ed25519');
    }
    if (ephemeralPublicKey.type != KeyPairType.x25519) {
      ephemeralKeyPair.destroy();
      throw StateError('临时密钥必须使用 X25519');
    }

    return PeerHandshake._(
      identity: identity,
      groupId: normalizedGroupId,
      role: role,
      hello: PeerHandshakeHello(
        groupId: normalizedGroupId,
        deviceId: identity.deviceId,
        deviceName: identity.deviceName,
        role: role,
        identityPublicKey: signingPublicKey.bytes,
        ephemeralPublicKey: ephemeralPublicKey.bytes,
        challenge: _randomBytes(_challengeLength),
      ),
      ephemeralKeyPair: ephemeralKeyPair,
    );
  }

  final PeerIdentity identity;
  final String groupId;
  final PeerHandshakeRole role;
  final PeerHandshakeHello hello;
  final KeyPair _ephemeralKeyPair;
  final _signatureAlgorithm = Ed25519();
  final _keyExchangeAlgorithm = X25519();

  bool _finished = false;

  Future<PeerHandshakeProof> sign(
    PeerHandshakeHello remote, {
    String? trustToken,
  }) async {
    _ensureOpen();
    _validateRemote(remote);
    final signature = await _signatureAlgorithm.sign(
      _transcript(remote),
      keyPair: identity.signingKeyPair,
    );
    return PeerHandshakeProof(
      identityPublicKey: hello.identityPublicKey,
      signature: signature.bytes,
      trustedProof: trustToken == null
          ? null
          : await _trustProof(_transcript(remote), trustToken),
    );
  }

  Future<PeerSession> finish(
    PeerHandshakeHello remote, {
    required PeerHandshakeProof remoteProof,
    required String pairingCode,
    required String expectedRemoteDeviceName,
    String? trustToken,
  }) async {
    _ensureOpen();
    try {
      _validateRemote(remote);
      _validatePairingCode(pairingCode);
      if (_text(expectedRemoteDeviceName, 'expectedRemoteDeviceName') !=
          remote.deviceName) {
        throw StateError('对端设备名称未确认');
      }
      if (!constantTimeBytesEquality.equals(
        remote.identityPublicKey,
        remoteProof.identityPublicKey,
      )) {
        throw StateError('对端身份公钥与握手消息不一致');
      }

      final remoteIdentityKey = SimplePublicKey(
        remote.identityPublicKey,
        type: KeyPairType.ed25519,
      );
      final validSignature = await _signatureAlgorithm.verify(
        _transcript(remote),
        signature: Signature(
          remoteProof.signature,
          publicKey: remoteIdentityKey,
        ),
      );
      if (!validSignature) throw StateError('对端握手签名无效');
      if (trustToken != null &&
          !constantTimeBytesEquality.equals(
            remoteProof.trustedProof ?? const [],
            await _trustProof(_transcript(remote), trustToken),
          )) {
        throw StateError('对端设备信任验证失败');
      }

      final sharedSecret = await _keyExchangeAlgorithm.sharedSecretKey(
        keyPair: _ephemeralKeyPair,
        remotePublicKey: SimplePublicKey(
          remote.ephemeralPublicKey,
          type: KeyPairType.x25519,
        ),
      );
      final transcript = _transcript(remote);
      final derivedKey =
          await Hkdf(
            hmac: Hmac.sha256(),
            outputLength: _sessionKeyMaterialLength,
          ).deriveKey(
            secretKey: sharedSecret,
            nonce: _sessionSalt(remote),
            info: <int>[
              ...utf8.encode('xiangfangbu/m5/session-key/v1'),
              ..._pairingSecretBytes(pairingCode),
              ...transcript,
            ],
          );
      try {
        final material = await derivedKey.extractBytes();
        final initiatorKey = material.sublist(0, _sessionKeyLength);
        final responderKey = material.sublist(_sessionKeyLength);
        final sendKey = role == PeerHandshakeRole.initiator
            ? initiatorKey
            : responderKey;
        final receiveKey = role == PeerHandshakeRole.initiator
            ? responderKey
            : initiatorKey;
        final sessionId = _hex(
          (await Sha256().hash(<int>[
            ...utf8.encode('xiangfangbu/m5/session-id/v1'),
            ...transcript,
          ])).bytes,
        );
        return PeerSession._(
          sessionId: sessionId,
          localRole: role,
          remoteDeviceId: remote.deviceId,
          remoteDeviceName: remote.deviceName,
          remoteIdentityPublicKey: List.unmodifiable(remote.identityPublicKey),
          sendKey: SecretKeyData(sendKey, overwriteWhenDestroyed: true),
          receiveKey: SecretKeyData(receiveKey, overwriteWhenDestroyed: true),
        );
      } finally {
        sharedSecret.destroy();
        derivedKey.destroy();
      }
    } finally {
      _finished = true;
      _ephemeralKeyPair.destroy();
    }
  }

  void _ensureOpen() {
    if (_finished) throw StateError('握手已结束');
  }

  void _validateRemote(PeerHandshakeHello remote) {
    if (remote.groupId != groupId) throw StateError('设备不属于同一设备组');
    if (remote.deviceId == hello.deviceId) {
      throw StateError('不能与本机建立对等会话');
    }
    if (remote.role == role) throw StateError('握手角色无效');
  }

  List<int> _transcript(PeerHandshakeHello remote) {
    final initiator = role == PeerHandshakeRole.initiator ? hello : remote;
    final responder = role == PeerHandshakeRole.responder ? hello : remote;
    return utf8.encode(
      jsonEncode({
        'version': PeerHandshakeHello.protocolVersion,
        'initiator': initiator.toJson(),
        'responder': responder.toJson(),
      }),
    );
  }

  List<int> _sessionSalt(PeerHandshakeHello remote) {
    final initiator = role == PeerHandshakeRole.initiator ? hello : remote;
    final responder = role == PeerHandshakeRole.responder ? hello : remote;
    return <int>[...initiator.challenge, ...responder.challenge];
  }
}

Future<List<int>> _trustProof(List<int> transcript, String token) async {
  final key = SecretKeyData(base64Url.decode(token));
  try {
    return (await Hmac.sha256().calculateMac(transcript, secretKey: key)).bytes;
  } finally {
    key.destroy();
  }
}

List<int> _pairingSecretBytes(String value) {
  if (RegExp(r'^\d{6}$').hasMatch(value)) return utf8.encode(value);
  return base64Url.decode(value);
}

class PeerEncryptedMessage {
  PeerEncryptedMessage({
    required String sessionId,
    required this.fromRole,
    required this.sequence,
    required this.box,
  }) : sessionId = _text(sessionId, 'sessionId') {
    if (sequence < 0) throw ArgumentError.value(sequence, 'sequence');
    if (box.nonce.length != _messageNonceLength ||
        box.mac.bytes.length != _messageMacLength) {
      throw ArgumentError.value(box, 'box', '消息密封格式无效');
    }
  }

  final String sessionId;
  final PeerHandshakeRole fromRole;
  final int sequence;
  final SecretBox box;

  Map<String, dynamic> toJson() => {
    'version': 1,
    'sessionId': sessionId,
    'fromRole': _roleName(fromRole),
    'sequence': sequence,
    'box': base64Url.encode(box.concatenation()),
  };

  factory PeerEncryptedMessage.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1) throw FormatException('消息版本无效');
    final packed = _jsonBytes(json['box'], null, 'box');
    if (packed.length < _messageNonceLength + _messageMacLength) {
      throw FormatException('消息密封长度无效');
    }
    return PeerEncryptedMessage(
      sessionId: _jsonText(json['sessionId'], 'sessionId'),
      fromRole: _parseRole(json['fromRole']),
      sequence: _jsonInt(json['sequence'], 'sequence'),
      box: SecretBox.fromConcatenation(
        packed,
        nonceLength: _messageNonceLength,
        macLength: _messageMacLength,
      ),
    );
  }
}

class PeerSession {
  PeerSession._({
    required this.sessionId,
    required this.localRole,
    required this.remoteDeviceId,
    required this.remoteDeviceName,
    required this.remoteIdentityPublicKey,
    required this._sendKey,
    required this._receiveKey,
  });

  final String sessionId;
  final PeerHandshakeRole localRole;
  final String remoteDeviceId;
  final String remoteDeviceName;
  final List<int> remoteIdentityPublicKey;
  final SecretKey _sendKey;
  final SecretKey _receiveKey;
  final Cipher _cipher = AesGcm.with256bits();

  int _sendSequence = 0;
  int _lastReceivedSequence = -1;
  bool _closed = false;

  bool get isClosed => _closed;

  Future<PeerEncryptedMessage> encryptJson(Object? payload) =>
      encryptBytes(utf8.encode(jsonEncode(payload)));

  Future<PeerEncryptedMessage> encryptBytes(List<int> clearText) async {
    _ensureOpen();
    if (_sendSequence == 0x7fffffff) {
      throw StateError('会话消息序号耗尽');
    }
    final sequence = _sendSequence++;
    final box = await _cipher.encrypt(
      clearText,
      secretKey: _sendKey,
      aad: _aad(fromRole: localRole, sequence: sequence),
    );
    return PeerEncryptedMessage(
      sessionId: sessionId,
      fromRole: localRole,
      sequence: sequence,
      box: box,
    );
  }

  Future<Object?> decryptJson(PeerEncryptedMessage message) async {
    return jsonDecode(utf8.decode(await decryptBytes(message)));
  }

  Future<List<int>> decryptBytes(PeerEncryptedMessage message) async {
    _ensureOpen();
    if (message.sessionId != sessionId) throw StateError('会话标识不一致');
    if (message.fromRole == localRole) throw StateError('消息方向无效');
    if (message.sequence <= _lastReceivedSequence) {
      throw StateError('重复或过期的会话消息');
    }
    final clearText = await _cipher.decrypt(
      message.box,
      secretKey: _receiveKey,
      aad: _aad(fromRole: message.fromRole, sequence: message.sequence),
    );
    _lastReceivedSequence = message.sequence;
    return clearText;
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _sendKey.destroy();
    _receiveKey.destroy();
  }

  List<int> _aad({
    required PeerHandshakeRole fromRole,
    required int sequence,
  }) => utf8.encode(
    '$_protocolVersion|$sessionId|${_roleName(fromRole)}|$sequence',
  );

  void _ensureOpen() {
    if (_closed) throw StateError('会话已关闭');
  }
}

String _roleName(PeerHandshakeRole role) => switch (role) {
  PeerHandshakeRole.initiator => 'initiator',
  PeerHandshakeRole.responder => 'responder',
};

PeerHandshakeRole _parseRole(Object? value) {
  return switch (value) {
    'initiator' => PeerHandshakeRole.initiator,
    'responder' => PeerHandshakeRole.responder,
    _ => throw FormatException('握手角色无效'),
  };
}

String _text(String value, String field) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized.length > 128) {
    throw ArgumentError.value(value, field, '文本不能为空且不能超过128个字符');
  }
  return normalized;
}

List<int> _bytes(List<int> value, int length, String field) {
  if (value.length != length) {
    throw ArgumentError.value(value, field, '字节长度无效');
  }
  return List<int>.from(value, growable: false);
}

String _jsonText(Object? value, String field) {
  if (value is! String) throw FormatException('$field 必须是字符串');
  try {
    return _text(value, field);
  } on ArgumentError {
    throw FormatException('$field 无效');
  }
}

int _jsonInt(Object? value, String field) {
  if (value is! int || value < 0) throw FormatException('$field 无效');
  return value;
}

List<int> _jsonBytes(Object? value, int? length, String field) {
  if (value is! String) throw FormatException('$field 必须是Base64字符串');
  try {
    final decoded = base64Url.decode(value);
    if (length != null && decoded.length != length) {
      throw FormatException('$field 字节长度无效');
    }
    return decoded;
  } on FormatException {
    rethrow;
  } on Object {
    throw FormatException('$field 不是有效的Base64');
  }
}

void _validatePairingCode(String value) {
  if (!RegExp(r'^\d{6}$').hasMatch(value) && !_isTrustToken(value)) {
    throw ArgumentError.value(value, 'pairingCode', '配对码必须是六位数字');
  }
}

bool _isTrustToken(String value) {
  try {
    return base64Url.decode(value).length == 32;
  } on Object {
    return false;
  }
}

List<int> _randomBytes(int length) {
  final random = Random.secure();
  return List<int>.generate(
    length,
    (_) => random.nextInt(256),
    growable: false,
  );
}

String _hex(List<int> bytes) =>
    bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
