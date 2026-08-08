import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xiangfangbu/services/peer_discovery.dart';
import 'package:xiangfangbu/services/peer_handshake.dart';
import 'package:xiangfangbu/services/peer_http_transport.dart';

const _role = String.fromEnvironment('M5_ROLE');
const _pairingCode = String.fromEnvironment('M5_CODE', defaultValue: '123456');
const _groupId = 'm5-two-device-test';
const _serverId = 'm5-server-device';
const _clientId = 'm5-client-device';
const _serverName = 'M5服务端手机';
const _clientName = 'M5客户端手机';
const _httpPort = 48721;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('M5 two-device network role', (_) async {
    switch (_role) {
      case 'server':
        await _runServer();
      case 'client':
        await _runClient();
      default:
        fail('M5_ROLE must be server or client');
    }
  });
}

Future<void> _runServer() async {
  final identity = await PeerIdentity.create(
    deviceId: _serverId,
    deviceName: _serverName,
  );
  final pairingCode = PairingCode.fromValue(
    _pairingCode,
    lifetime: const Duration(minutes: 5),
  );
  final httpServer = PeerHttpServer(
    identity: identity,
    groupId: _groupId,
    pairingCode: pairingCode,
    expectedRemoteDeviceName: _clientName,
  );
  final discovery = PeerDiscoveryService(
    groupId: _groupId,
    deviceId: identity.deviceId,
    httpPort: _httpPort,
  );
  await httpServer.start(address: InternetAddress.anyIPv4, port: _httpPort);
  await discovery.start(
    bindAddress: InternetAddress.anyIPv4,
    port: PeerDiscoveryService.defaultDiscoveryPort,
    announceInterval: const Duration(seconds: 1),
  );
  try {
    final deadline = DateTime.now().add(const Duration(seconds: 90));
    while (!httpServer.isPaired && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    expect(httpServer.isPaired, isTrue);
  } finally {
    await discovery.dispose();
    await httpServer.close();
  }
}

Future<void> _runClient() async {
  final identity = await PeerIdentity.create(
    deviceId: _clientId,
    deviceName: _clientName,
  );
  final discovery = PeerDiscoveryService(
    groupId: _groupId,
    deviceId: identity.deviceId,
    httpPort: 48722,
  );
  await discovery.start(
    bindAddress: InternetAddress.anyIPv4,
    port: PeerDiscoveryService.defaultDiscoveryPort,
    announceImmediately: false,
  );
  PeerHttpClient? client;
  try {
    final peer = await discovery.peers
        .where((item) => item.advertisement.deviceId == _serverId)
        .first
        .timeout(const Duration(seconds: 90));
    client = await PeerHttpClient.connect(
      identity: identity,
      groupId: _groupId,
      serverUri: peer.httpUri,
      pairingCode: _pairingCode,
      expectedRemoteDeviceName: _serverName,
    );
    expect(await client.request({'kind': 'ping', 'value': 'two-device'}), {
      'kind': 'pong',
      'value': 'two-device',
    });
  } finally {
    client?.close();
    await discovery.dispose();
  }
}
