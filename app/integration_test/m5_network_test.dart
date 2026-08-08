import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xiangfangbu/services/peer_discovery.dart';
import 'package:xiangfangbu/services/peer_handshake.dart';
import 'package:xiangfangbu/services/peer_http_transport.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Android executes UDP discovery and encrypted HTTP loopback', (
    _,
  ) async {
    final serverIdentity = await PeerIdentity.create(
      deviceId: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
      deviceName: '后仓手机',
    );
    final clientIdentity = await PeerIdentity.create(
      deviceId: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      deviceName: '前台平板',
    );
    final code = PairingCode.issue(
      lifetime: const Duration(minutes: 1),
      random: Random(17),
    );
    final httpServer = PeerHttpServer(
      identity: serverIdentity,
      groupId: 'store-1',
      pairingCode: code,
      expectedRemoteDeviceName: '前台平板',
    );
    await httpServer.start(address: InternetAddress.loopbackIPv4);

    final serverDiscovery = PeerDiscoveryService(
      groupId: 'store-1',
      deviceId: serverIdentity.deviceId,
      httpPort: httpServer.uri.port,
    );
    final clientDiscovery = PeerDiscoveryService(
      groupId: 'store-1',
      deviceId: clientIdentity.deviceId,
      httpPort: 41003,
    );
    await serverDiscovery.start(
      bindAddress: InternetAddress.loopbackIPv4,
      port: 0,
      announceImmediately: false,
    );
    await clientDiscovery.start(
      bindAddress: InternetAddress.loopbackIPv4,
      port: 0,
      announceImmediately: false,
    );
    addTearDown(httpServer.close);
    addTearDown(serverDiscovery.dispose);
    addTearDown(clientDiscovery.dispose);

    final discoveredPeer = clientDiscovery.peers.first;
    serverDiscovery.announce(
      destinationAddress: InternetAddress.loopbackIPv4,
      destinationPort: clientDiscovery.localPort,
    );
    final peer = await discoveredPeer.timeout(const Duration(seconds: 3));
    expect(peer.httpUri.port, httpServer.uri.port);

    final client = await PeerHttpClient.connect(
      identity: clientIdentity,
      groupId: 'store-1',
      serverUri: peer.httpUri,
      pairingCode: code.value,
      expectedRemoteDeviceName: '后仓手机',
    );
    addTearDown(client.close);

    expect(await client.request({'kind': 'ping', 'value': 7}), {
      'kind': 'pong',
      'value': 7,
    });
  });
}
