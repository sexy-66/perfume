import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/services/peer_handshake.dart';
import 'package:xiangfangbu/services/peer_http_transport.dart';

Future<(PeerSession, PeerSession)> _openSessions({
  String initiatorCode = '123456',
  String responderCode = '123456',
}) async {
  final alice = await PeerIdentity.create(
    deviceId: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    deviceName: '前台平板',
  );
  final bob = await PeerIdentity.create(
    deviceId: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
    deviceName: '后仓手机',
  );
  final aliceHandshake = await PeerHandshake.create(
    identity: alice,
    groupId: 'store-1',
    role: PeerHandshakeRole.initiator,
  );
  final bobHandshake = await PeerHandshake.create(
    identity: bob,
    groupId: 'store-1',
    role: PeerHandshakeRole.responder,
  );
  final aliceHello = PeerHandshakeHello.fromJson(aliceHandshake.hello.toJson());
  final bobHello = PeerHandshakeHello.fromJson(bobHandshake.hello.toJson());
  final aliceProof = PeerHandshakeProof.fromJson(
    (await aliceHandshake.sign(bobHello)).toJson(),
  );
  final bobProof = PeerHandshakeProof.fromJson(
    (await bobHandshake.sign(aliceHello)).toJson(),
  );
  final aliceSession = await aliceHandshake.finish(
    bobHello,
    remoteProof: bobProof,
    pairingCode: initiatorCode,
    expectedRemoteDeviceName: '后仓手机',
  );
  final bobSession = await bobHandshake.finish(
    aliceHello,
    remoteProof: aliceProof,
    pairingCode: responderCode,
    expectedRemoteDeviceName: '前台平板',
  );
  return (aliceSession, bobSession);
}

void main() {
  test('pairing code expires, is one-time, and limits failures', () {
    final now = DateTime.utc(2026, 8, 7, 10);
    final code = PairingCode.issue(
      now: now,
      lifetime: const Duration(minutes: 1),
      maxAttempts: 2,
      random: Random(1),
    );

    expect(code.verify('000000', now: now), isFalse);
    expect(code.verify('111111', now: now), isFalse);
    expect(code.verify(code.value, now: now), isFalse);
    expect(code.failedAttempts, 2);

    final expired = PairingCode.issue(
      now: now,
      lifetime: const Duration(seconds: 1),
      random: Random(2),
    );
    expect(
      expired.verify(expired.value, now: now.add(const Duration(seconds: 1))),
      isFalse,
    );

    final oneTime = PairingCode.issue(now: now, random: Random(3));
    expect(oneTime.verify(oneTime.value, now: now), isTrue);
    expect(oneTime.isConsumed, isTrue);
    expect(oneTime.verify(oneTime.value, now: now), isFalse);
  });

  test(
    'two peers sign the transcript and exchange authenticated JSON',
    () async {
      final sessions = await _openSessions();
      final alice = sessions.$1;
      final bob = sessions.$2;
      addTearDown(alice.close);
      addTearDown(bob.close);

      final request = await alice.encryptJson({'kind': 'ping', 'value': 42});
      final requestOnWire = PeerEncryptedMessage.fromJson(request.toJson());
      expect(await bob.decryptJson(requestOnWire), {
        'kind': 'ping',
        'value': 42,
      });

      final response = await bob.encryptJson({'kind': 'pong'});
      final responseOnWire = PeerEncryptedMessage.fromJson(response.toJson());
      expect(await alice.decryptJson(responseOnWire), {'kind': 'pong'});
      await expectLater(bob.decryptJson(requestOnWire), throwsStateError);
    },
  );

  test(
    'tampering and a different pairing code cannot decrypt a session',
    () async {
      final sessions = await _openSessions(
        initiatorCode: '123456',
        responderCode: '654321',
      );
      final alice = sessions.$1;
      final bob = sessions.$2;
      addTearDown(alice.close);
      addTearDown(bob.close);

      final request = await alice.encryptBytes(utf8.encode('secret'));
      final tamperedJson = request.toJson();
      final packed = base64Url.decode(tamperedJson['box'] as String);
      packed[0] ^= 1;
      tamperedJson['box'] = base64Url.encode(packed);
      final tampered = PeerEncryptedMessage.fromJson(tamperedJson);
      await expectLater(
        bob.decryptBytes(tampered),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );

      final wrongCode = await alice.encryptBytes(utf8.encode('secret'));
      await expectLater(
        bob.decryptBytes(wrongCode),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    },
  );

  test(
    'device name confirmation is required before session creation',
    () async {
      final alice = await PeerIdentity.create(
        deviceId: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        deviceName: '前台平板',
      );
      final bob = await PeerIdentity.create(
        deviceId: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
        deviceName: '后仓手机',
      );
      final aliceHandshake = await PeerHandshake.create(
        identity: alice,
        groupId: 'store-1',
        role: PeerHandshakeRole.initiator,
      );
      final bobHandshake = await PeerHandshake.create(
        identity: bob,
        groupId: 'store-1',
        role: PeerHandshakeRole.responder,
      );
      final proof = await bobHandshake.sign(aliceHandshake.hello);
      await expectLater(
        aliceHandshake.finish(
          bobHandshake.hello,
          remoteProof: proof,
          pairingCode: '123456',
          expectedRemoteDeviceName: '未知设备',
        ),
        throwsStateError,
      );
    },
  );

  test('HTTP loopback completes pairing and encrypted ping/pong', () async {
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
      random: Random(9),
    );
    final server = PeerHttpServer(
      identity: serverIdentity,
      groupId: 'store-1',
      pairingCode: code,
      expectedRemoteDeviceName: '前台平板',
    );
    await server.start();
    addTearDown(server.close);

    await expectLater(
      PeerHttpClient.connect(
        identity: clientIdentity,
        groupId: 'store-1',
        serverUri: server.uri,
        pairingCode: '000000',
        expectedRemoteDeviceName: '后仓手机',
      ),
      throwsA(isA<PeerHttpFailure>()),
    );
    expect(code.failedAttempts, 1);

    final client = await PeerHttpClient.connect(
      identity: clientIdentity,
      groupId: 'store-1',
      serverUri: server.uri,
      pairingCode: code.value,
      expectedRemoteDeviceName: '后仓手机',
    );
    addTearDown(client.close);

    expect(server.isPaired, isTrue);
    expect(await client.request({'kind': 'ping', 'value': 42}), {
      'kind': 'pong',
      'value': 42,
    });

    final thirdIdentity = await PeerIdentity.create(
      deviceId: 'cccccccccccccccccccccccccccccccc',
      deviceName: '前台第三台手机',
    );
    final third = await PeerHttpClient.connect(
      identity: thirdIdentity,
      groupId: 'store-1',
      serverUri: server.uri,
      pairingCode: server.pairingCode.value,
      expectedRemoteDeviceName: '后仓手机',
    );
    addTearDown(third.close);
    expect(server.pairedDeviceIds, hasLength(2));
    expect(await third.request({'kind': 'ping', 'value': 43}), {
      'kind': 'pong',
      'value': 43,
    });
  });

  test('pairing publishes a reverse invite for a symmetric link', () async {
    final first = await PeerIdentity.create(
      deviceId: '11111111111111111111111111111111',
      deviceName: '第一台手机',
    );
    final second = await PeerIdentity.create(
      deviceId: '22222222222222222222222222222222',
      deviceName: '第二台手机',
    );
    final firstCode = PairingCode.issue();
    final secondCode = PairingCode.issue();
    PeerReversePairing? reverse;
    final firstServer = PeerHttpServer(
      identity: first,
      groupId: 'store-1',
      pairingCode: firstCode,
      expectedRemoteDeviceName: second.deviceName,
      onReversePairing: (value) => reverse = value,
    );
    final secondServer = PeerHttpServer(
      identity: second,
      groupId: 'store-1',
      pairingCode: secondCode,
      expectedRemoteDeviceName: first.deviceName,
    );
    await firstServer.start();
    await secondServer.start();
    addTearDown(firstServer.close);
    addTearDown(secondServer.close);

    final secondClient = await PeerHttpClient.connect(
      identity: second,
      groupId: 'store-1',
      serverUri: firstServer.uri,
      pairingCode: firstCode.value,
      expectedRemoteDeviceName: first.deviceName,
      callbackPort: secondServer.uri.port,
      reversePairingCode: secondCode.value,
    );
    addTearDown(secondClient.close);

    final invite = reverse;
    expect(invite, isNotNull);
    expect(invite!.deviceId, second.deviceId);
    final firstClient = await PeerHttpClient.connect(
      identity: first,
      groupId: 'store-1',
      serverUri: secondServer.uri,
      pairingCode: invite.pairingCode,
      expectedRemoteDeviceName: second.deviceName,
    );
    addTearDown(firstClient.close);
    expect(firstServer.isPaired, isTrue);
    expect(secondServer.isPaired, isTrue);
  });
}
