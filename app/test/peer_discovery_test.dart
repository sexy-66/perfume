import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/services/peer_discovery.dart';

void main() {
  test(
    'UDP discovery exchanges only public routing data and sorts peers',
    () async {
      final receiver = PeerDiscoveryService(
        groupId: 'store-1',
        deviceId: 'receiver',
        httpPort: 41000,
      );
      final first = PeerDiscoveryService(
        groupId: 'store-1',
        deviceId: 'bbbb',
        httpPort: 41001,
      );
      final second = PeerDiscoveryService(
        groupId: 'store-1',
        deviceId: 'aaaa',
        httpPort: 41002,
      );
      await receiver.start(
        bindAddress: InternetAddress.loopbackIPv4,
        port: 0,
        announceImmediately: false,
      );
      await first.start(
        bindAddress: InternetAddress.loopbackIPv4,
        port: 0,
        announceImmediately: false,
      );
      await second.start(
        bindAddress: InternetAddress.loopbackIPv4,
        port: 0,
        announceImmediately: false,
      );
      addTearDown(receiver.dispose);
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      final firstPeer = receiver.peers.first;
      first.announce(
        destinationAddress: InternetAddress.loopbackIPv4,
        destinationPort: receiver.localPort,
      );
      final discoveredFirst = await firstPeer.timeout(
        const Duration(seconds: 1),
      );
      expect(discoveredFirst.advertisement.deviceId, 'bbbb');
      expect(discoveredFirst.advertisement.deviceName, 'bbbb');
      expect(discoveredFirst.advertisement.httpPort, 41001);
      expect(discoveredFirst.httpUri.port, 41001);

      var repeatedEvents = 0;
      final repeated = receiver.peers.listen((_) => repeatedEvents++);
      first.announce(
        destinationAddress: InternetAddress.loopbackIPv4,
        destinationPort: receiver.localPort,
      );
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await repeated.cancel();
      expect(repeatedEvents, 0, reason: '同一设备周期广播不应反复刷新界面或触发自动连接');

      final secondPeer = receiver.peers.first;
      second.announce(
        destinationAddress: InternetAddress.loopbackIPv4,
        destinationPort: receiver.localPort,
      );
      await secondPeer.timeout(const Duration(seconds: 1));

      expect(receiver.knownPeers.map((peer) => peer.advertisement.deviceId), [
        'aaaa',
        'bbbb',
      ]);
      final wire = jsonEncode(discoveredFirst.advertisement.toJson());
      expect(wire, contains('deviceName'));
      expect(wire, isNot(contains('顾客')));
    },
  );

  test('discovery rejects wrong group and malformed packets', () {
    final valid = PeerDiscoveryAdvertisement(
      groupId: 'store-1',
      deviceId: 'device-a',
      httpPort: 41000,
      nonce: List<int>.filled(16, 1),
    );
    expect(
      PeerDiscoveryAdvertisement.fromJson(valid.toJson()).deviceId,
      'device-a',
    );
    expect(
      () => PeerDiscoveryAdvertisement.fromJson({
        ...valid.toJson(),
        'kind': 'wrong-group',
      }),
      throwsFormatException,
    );
    expect(
      () => PeerDiscoveryAdvertisement.fromJson({
        ...valid.toJson(),
        'httpPort': 0,
      }),
      throwsFormatException,
    );
  });

  test('derives the common home LAN directed broadcast address', () {
    expect(
      ipv4Subnet24BroadcastAddress(InternetAddress('192.168.31.172'))?.address,
      '192.168.31.255',
    );
    expect(ipv4Subnet24BroadcastAddress(InternetAddress.loopbackIPv6), isNull);
  });
}
