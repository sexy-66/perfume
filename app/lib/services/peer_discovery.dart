import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

const _discoveryVersion = 1;
const _discoveryKind = 'xiangfangbu-peer-discovery';
const _discoveryNonceLength = 16;
const _maxKnownPeers = 32;
const _peerStaleAfter = Duration(seconds: 10);

class PeerDiscoveryAdvertisement {
  PeerDiscoveryAdvertisement({
    required String groupId,
    required String deviceId,
    required this.httpPort,
    String? deviceName,
    required List<int> nonce,
  }) : groupId = _text(groupId, 'groupId'),
       deviceId = _text(deviceId, 'deviceId'),
       deviceName = _text(deviceName ?? deviceId, 'deviceName'),
       nonce = List.unmodifiable(_bytes(nonce));

  final String groupId;
  final String deviceId;
  final String deviceName;
  final int httpPort;
  final List<int> nonce;

  Map<String, dynamic> toJson() => {
    'version': _discoveryVersion,
    'kind': _discoveryKind,
    'groupId': groupId,
    'deviceId': deviceId,
    'deviceName': deviceName,
    'httpPort': httpPort,
    'nonce': base64Url.encode(nonce),
  };

  factory PeerDiscoveryAdvertisement.fromJson(Map<String, dynamic> json) {
    if (json['version'] != _discoveryVersion ||
        json['kind'] != _discoveryKind) {
      throw const FormatException('发现包版本或类型无效');
    }
    final httpPort = json['httpPort'];
    if (httpPort is! int || httpPort < 1 || httpPort > 65535) {
      throw const FormatException('HTTP端口无效');
    }
    final encodedNonce = json['nonce'];
    if (encodedNonce is! String) {
      throw const FormatException('发现随机数无效');
    }
    try {
      return PeerDiscoveryAdvertisement(
        groupId: _jsonText(json['groupId'], 'groupId'),
        deviceId: _jsonText(json['deviceId'], 'deviceId'),
        deviceName: json['deviceName'] == null
            ? _jsonText(json['deviceId'], 'deviceId')
            : _jsonText(json['deviceName'], 'deviceName'),
        httpPort: httpPort,
        nonce: base64Url.decode(encodedNonce),
      );
    } on ArgumentError {
      throw const FormatException('发现包字段无效');
    } on FormatException {
      rethrow;
    }
  }
}

class PeerDiscoveryPeer {
  const PeerDiscoveryPeer({
    required this.advertisement,
    required this.address,
    required this.lastSeenUtc,
  });

  final PeerDiscoveryAdvertisement advertisement;
  final InternetAddress address;
  final DateTime lastSeenUtc;

  Uri get httpUri =>
      Uri(scheme: 'http', host: address.address, port: advertisement.httpPort);
}

class PeerDiscoveryService {
  static const defaultDiscoveryPort = 43872;

  PeerDiscoveryService({
    required String groupId,
    required String deviceId,
    required this.httpPort,
    String? deviceName,
    this.discoveryPort = defaultDiscoveryPort,
  }) : groupId = _text(groupId, 'groupId'),
       deviceId = _text(deviceId, 'deviceId'),
       deviceName = _text(deviceName ?? deviceId, 'deviceName') {
    if (httpPort < 1 || httpPort > 65535) {
      throw ArgumentError.value(httpPort, 'httpPort');
    }
    if (discoveryPort < 1 || discoveryPort > 65535) {
      throw ArgumentError.value(discoveryPort, 'discoveryPort');
    }
  }

  final String groupId;
  final String deviceId;
  final String deviceName;
  final int httpPort;
  final int discoveryPort;

  final _peers = StreamController<PeerDiscoveryPeer>.broadcast();
  final Map<String, PeerDiscoveryPeer> _known = {};
  RawDatagramSocket? _socket;
  StreamSubscription<RawSocketEvent>? _subscription;
  Timer? _announceTimer;
  Timer? _pruneTimer;
  List<InternetAddress> _defaultAnnounceAddresses = const [];
  int? _announcePort;

  Stream<PeerDiscoveryPeer> get peers => _peers.stream;
  bool get isStarted => _socket != null;

  int get localPort {
    final socket = _socket;
    if (socket == null) throw StateError('UDP发现服务尚未启动');
    return socket.port;
  }

  List<PeerDiscoveryPeer> get knownPeers {
    _pruneStale();
    final result = List<PeerDiscoveryPeer>.of(_known.values)
      ..sort(
        (a, b) => a.advertisement.deviceId.compareTo(b.advertisement.deviceId),
      );
    return List.unmodifiable(result);
  }

  Future<int> start({
    InternetAddress? bindAddress,
    int? port,
    InternetAddress? announceAddress,
    int? announcePort,
    Duration announceInterval = const Duration(seconds: 3),
    bool announceImmediately = true,
  }) async {
    final current = _socket;
    if (current != null) return current.port;
    if (announceInterval <= Duration.zero) {
      throw ArgumentError.value(announceInterval, 'announceInterval');
    }
    final socket = await RawDatagramSocket.bind(
      bindAddress ?? InternetAddress.anyIPv4,
      port ?? discoveryPort,
      reuseAddress: true,
    );
    socket.broadcastEnabled = true;
    _socket = socket;
    _defaultAnnounceAddresses = announceAddress == null
        ? await _lanBroadcastAddresses()
        : [announceAddress];
    _announcePort = announcePort ?? discoveryPort;
    _subscription = socket.listen((event) {
      if (event == RawSocketEvent.read) _receive(socket);
    });
    if (announceImmediately) announce();
    _announceTimer = Timer.periodic(announceInterval, (_) => announce());
    _pruneTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pruneStale(),
    );
    return socket.port;
  }

  void announce({InternetAddress? destinationAddress, int? destinationPort}) {
    final socket = _socket;
    if (socket == null) throw StateError('UDP发现服务尚未启动');
    final addresses = destinationAddress == null
        ? _defaultAnnounceAddresses
        : [destinationAddress];
    final port = destinationPort ?? _announcePort ?? discoveryPort;
    final packet = utf8.encode(
      jsonEncode(
        PeerDiscoveryAdvertisement(
          groupId: groupId,
          deviceId: deviceId,
          deviceName: deviceName,
          httpPort: httpPort,
          nonce: _randomBytes(_discoveryNonceLength),
        ).toJson(),
      ),
    );
    var sent = false;
    for (final address in addresses) {
      try {
        sent = socket.send(packet, address, port) == packet.length || sent;
      } on SocketException {
        continue;
      }
    }
    if (!sent) {
      throw StateError('UDP发现包发送失败');
    }
  }

  Future<void> stop() async {
    _announceTimer?.cancel();
    _announceTimer = null;
    _pruneTimer?.cancel();
    _pruneTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    _socket?.close();
    _socket = null;
    _defaultAnnounceAddresses = const [];
  }

  Future<void> dispose() async {
    await stop();
    await _peers.close();
  }

  void _receive(RawDatagramSocket socket) {
    Datagram? datagram;
    while ((datagram = socket.receive()) != null) {
      final packet = datagram!;
      try {
        final decoded = jsonDecode(utf8.decode(packet.data));
        final advertisement = PeerDiscoveryAdvertisement.fromJson(
          _map(decoded),
        );
        if (advertisement.groupId != groupId ||
            advertisement.deviceId == deviceId) {
          continue;
        }
        final peer = PeerDiscoveryPeer(
          advertisement: advertisement,
          address: packet.address,
          lastSeenUtc: DateTime.now().toUtc(),
        );
        final previous = _known[advertisement.deviceId];
        if (previous == null && _known.length >= _maxKnownPeers) continue;
        _known[advertisement.deviceId] = peer;
        if (previous == null || !_samePeer(previous, peer)) {
          _peers.add(peer);
        }
      } on Object {
        continue;
      }
    }
  }

  void _pruneStale() {
    final cutoff = DateTime.now().toUtc().subtract(_peerStaleAfter);
    final stale = [
      for (final peer in _known.values)
        if (peer.lastSeenUtc.isBefore(cutoff)) peer,
    ];
    for (final peer in stale) {
      _known.remove(peer.advertisement.deviceId);
      _peers.add(peer);
    }
  }
}

Future<List<InternetAddress>> _lanBroadcastAddresses() async {
  final addresses = <String>{'255.255.255.255'};
  try {
    for (final interface in await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    )) {
      for (final address in interface.addresses) {
        final broadcast = ipv4Subnet24BroadcastAddress(address);
        if (broadcast != null) addresses.add(broadcast.address);
      }
    }
  } on SocketException {
    // Keep the global broadcast fallback when interfaces cannot be listed.
  }
  return [for (final address in addresses) InternetAddress(address)];
}

InternetAddress? ipv4Subnet24BroadcastAddress(InternetAddress address) {
  // ponytail: Dart exposes interface addresses but not Android netmasks here;
  // /24 covers the target home LAN. Add a native netmask lookup if needed.
  if (address.type != InternetAddressType.IPv4) return null;
  final parts = address.address.split('.');
  if (parts.length != 4 || parts.any((part) => int.tryParse(part) == null)) {
    return null;
  }
  return InternetAddress('${parts[0]}.${parts[1]}.${parts[2]}.255');
}

bool _samePeer(PeerDiscoveryPeer a, PeerDiscoveryPeer b) {
  return a.address.address == b.address.address &&
      a.advertisement.httpPort == b.advertisement.httpPort &&
      a.advertisement.deviceName == b.advertisement.deviceName;
}

String _text(String value, String field) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized.length > 128) {
    throw ArgumentError.value(value, field, '文本不能为空且不能超过128个字符');
  }
  return normalized;
}

String _jsonText(Object? value, String field) {
  if (value is! String) throw const FormatException('发现包文本无效');
  try {
    return _text(value, field);
  } on ArgumentError {
    throw FormatException('$field 无效');
  }
}

List<int> _bytes(List<int> value) {
  if (value.length != _discoveryNonceLength) {
    throw ArgumentError.value(value, 'nonce', '发现随机数长度无效');
  }
  return List<int>.from(value, growable: false);
}

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) throw const FormatException('发现包JSON无效');
  return Map<String, dynamic>.from(value);
}

List<int> _randomBytes(int length) {
  final random = Random.secure();
  return List<int>.generate(
    length,
    (_) => random.nextInt(256),
    growable: false,
  );
}
