import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/services/peer_identity_store.dart';

void main() {
  test('identity store keeps the same signing key across launches', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-identity-');
    addTearDown(() => directory.delete(recursive: true));
    final store = PeerIdentityStore(File('${directory.path}/identity.json'));

    final first = await store.loadOrCreate(deviceId: 'device-a');
    final firstKey =
        (await first.identity.signingKeyPair.extractPublicKey())
            as SimplePublicKey;
    final second = await store.loadOrCreate(deviceId: 'device-a');
    final secondKey =
        (await second.identity.signingKeyPair.extractPublicKey())
            as SimplePublicKey;

    expect(first.groupId, PeerIdentityStore.defaultGroupId);
    expect(second.identity.deviceId, 'device-a');
    expect(secondKey.bytes, firstKey.bytes);
    expect(await File('${directory.path}/identity.json').exists(), isTrue);
  });

  test('trust store keeps a paired device across launches', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-trust-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/trust.json');
    final token = PeerTrustStore.issueToken();

    await PeerTrustStore(file).save(
      PeerTrust(
        deviceId: 'device-b',
        deviceName: 'Xiaomi 15 Pro',
        token: token,
        identityPublicKey: List<int>.generate(32, (index) => index),
      ),
    );
    final restored = await PeerTrustStore(file).find('device-b');

    expect(restored?.deviceName, 'Xiaomi 15 Pro');
    expect(restored?.token, token);
    expect(restored?.identityPublicKey, List<int>.generate(32, (i) => i));
  });

  test('trust store serializes concurrent writes', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-trust-');
    addTearDown(() => directory.delete(recursive: true));
    final store = PeerTrustStore(File('${directory.path}/trust.json'));

    await Future.wait([
      store.save(
        PeerTrust(
          deviceId: 'device-b',
          deviceName: '设备 B',
          token: PeerTrustStore.issueToken(),
          identityPublicKey: List<int>.filled(32, 1),
        ),
      ),
      store.save(
        PeerTrust(
          deviceId: 'device-c',
          deviceName: '设备 C',
          token: PeerTrustStore.issueToken(),
          identityPublicKey: List<int>.filled(32, 2),
        ),
      ),
    ]);

    expect((await store.all()).keys, containsAll(['device-b', 'device-c']));
  });

  test('database identity replacement resets private pairing state', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-reset-');
    addTearDown(() => directory.delete(recursive: true));
    final identityStore = PeerIdentityStore(
      File('${directory.path}/identity.json'),
    );
    final trustStore = PeerTrustStore(File('${directory.path}/trust.json'));
    final original = await identityStore.loadOrCreate(deviceId: 'device-a');
    await trustStore.save(
      PeerTrust(
        deviceId: 'device-b',
        deviceName: '设备 B',
        token: PeerTrustStore.issueToken(),
        identityPublicKey: List<int>.filled(32, 1),
      ),
    );

    expect(await identityStore.resetIfDeviceChanged('device-b'), isTrue);
    await trustStore.reset();
    final replacement = await identityStore.loadOrCreate(deviceId: 'device-b');
    final originalKey =
        (await original.identity.signingKeyPair.extractPublicKey())
            as SimplePublicKey;
    final replacementKey =
        (await replacement.identity.signingKeyPair.extractPublicKey())
            as SimplePublicKey;

    expect(replacement.identity.deviceId, 'device-b');
    expect(await trustStore.all(), isEmpty);
    expect(replacementKey.bytes, isNot(originalKey.bytes));
  });
}
