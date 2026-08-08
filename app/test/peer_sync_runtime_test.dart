import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/features/settings/settings_page.dart';
import 'package:xiangfangbu/services/peer_handshake.dart';
import 'package:xiangfangbu/services/peer_sync_runtime.dart';

void main() {
  test('runtime starts and stops both foreground network services', () async {
    final identity = await PeerIdentity.create(
      deviceId: 'device-a',
      deviceName: '香方簿设备',
    );
    final runtime = PeerSyncRuntime(
      identity: identity,
      groupId: 'store-1',
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    addTearDown(runtime.close);

    await runtime.start();
    expect(runtime.status, PeerSyncStatus.running);
    expect(runtime.isHttpListening, isTrue);
    expect(runtime.isDiscoveryRunning, isTrue);
    expect(runtime.pairingCode, isNotNull);

    await runtime.stop();
    expect(runtime.status, PeerSyncStatus.stopped);
    expect(runtime.isHttpListening, isFalse);
    expect(runtime.isDiscoveryRunning, isFalse);
    expect(runtime.pairingCode, isNull);
  });

  test('foreground restart waits for an in-progress background stop', () async {
    final identity = await PeerIdentity.create(
      deviceId: 'device-a',
      deviceName: '香方簿设备',
    );
    final runtime = PeerSyncRuntime(
      identity: identity,
      groupId: 'store-1',
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    addTearDown(runtime.close);

    await runtime.start();
    final stopping = runtime.stop();
    final restarting = runtime.start();
    await Future.wait([stopping, restarting]);

    expect(runtime.status, PeerSyncStatus.running);
    expect(runtime.isHttpListening, isTrue);
    expect(runtime.isDiscoveryRunning, isTrue);
  });

  testWidgets('sync page exposes runtime state', (tester) async {
    final identity = await PeerIdentity.create(
      deviceId: 'device-a',
      deviceName: '香方簿设备',
    );
    final runtime = PeerSyncRuntime(identity: identity, groupId: 'store-1');
    addTearDown(runtime.close);

    await tester.pumpWidget(
      MaterialApp(home: SyncDevicesPage(runtime: runtime)),
    );

    expect(find.text('同步与设备'), findsOneWidget);
    expect(find.text('暂未发现同组设备'), findsOneWidget);
    expect(find.text('设备组'), findsOneWidget);
  });

  test('runtime exposes authorized and pending devices', () async {
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    final identity = await PeerIdentity.create(
      deviceId: 'device-a',
      deviceName: 'Pad',
    );
    await database.rememberPeerDevice(
      deviceId: 'device-b',
      deviceName: 'Xiaomi 15 Pro',
      identityPublicKey: List<int>.filled(32, 1),
    );
    await database.rememberPeerDevice(
      deviceId: 'device-c',
      deviceName: '仓库手机',
      identityPublicKey: List<int>.filled(32, 2),
      pendingRejoin: true,
    );
    final runtime = PeerSyncRuntime(
      identity: identity,
      groupId: 'store-1',
      database: database,
    );
    addTearDown(database.close);
    addTearDown(runtime.close);

    final devices = await runtime.watchDevices().first;
    expect(devices.map((device) => device.deviceName), {
      'Xiaomi 15 Pro',
      '仓库手机',
    });
    expect(
      devices.singleWhere((device) => device.id == 'device-c').isPendingRejoin,
      isTrue,
    );
  });
}
