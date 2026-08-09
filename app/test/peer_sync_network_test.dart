import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';
import 'package:xiangfangbu/services/peer_discovery.dart';
import 'package:xiangfangbu/services/peer_handshake.dart';
import 'package:xiangfangbu/services/peer_http_transport.dart';
import 'package:xiangfangbu/services/peer_identity_store.dart';
import 'package:xiangfangbu/services/peer_sync_runtime.dart';

void main() {
  test('pairs two runtimes and replicates ingredients with images', () async {
    final serverDatabase = AppDatabase(NativeDatabase.memory());
    final clientDatabase = AppDatabase(NativeDatabase.memory());
    final serverDirectory = await Directory.systemTemp.createTemp(
      'xiang-m5-server-',
    );
    final clientDirectory = await Directory.systemTemp.createTemp(
      'xiang-m5-client-',
    );
    final serverMedia = MediaStore(serverDirectory);
    final clientMedia = MediaStore(clientDirectory);
    await serverDatabase.initialize();
    await clientDatabase.initialize();
    await serverMedia.initialize();
    await clientMedia.initialize();
    final serverIdentity = await PeerIdentity.create(
      deviceId: 'server-device',
      deviceName: '香方簿设备',
    );
    final clientIdentity = await PeerIdentity.create(
      deviceId: 'client-device',
      deviceName: '香方簿设备',
    );
    final server = PeerSyncRuntime(
      identity: serverIdentity,
      groupId: 'store-1',
      database: serverDatabase,
      mediaStore: serverMedia,
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    final client = PeerSyncRuntime(
      identity: clientIdentity,
      groupId: 'store-1',
      database: clientDatabase,
      mediaStore: clientMedia,
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    addTearDown(server.close);
    addTearDown(client.close);
    addTearDown(serverDatabase.close);
    addTearDown(clientDatabase.close);
    addTearDown(() => serverDirectory.delete(recursive: true));
    addTearDown(() => clientDirectory.delete(recursive: true));
    await server.start();
    await client.start();

    final category = await clientDatabase.createIngredientCategory('木类');
    final firstImage = Uint8List.fromList(List<int>.generate(70000, (i) => i));
    final firstHash = await clientMedia.putJpeg(firstImage);
    final batchImage2 = Uint8List.fromList(
      List<int>.generate(50000, (i) => (i * 3) % 256),
    );
    final batchHash2 = await clientMedia.putJpeg(batchImage2);
    final batchImage3 = Uint8List.fromList(
      List<int>.generate(90000, (i) => 255 - (i % 256)),
    );
    final batchHash3 = await clientMedia.putJpeg(batchImage3);
    final ingredient = await clientDatabase.createIngredient(
      name: '沉香',
      categoryId: category.id,
      imageHash: firstHash,
    );
    await clientDatabase.createIngredient(
      name: '檀香',
      categoryId: category.id,
      imageHash: batchHash2,
    );
    await clientDatabase.createIngredient(
      name: '乳香',
      categoryId: category.id,
      imageHash: batchHash3,
    );
    final peer = PeerDiscoveryPeer(
      advertisement: PeerDiscoveryAdvertisement(
        groupId: 'store-1',
        deviceId: serverIdentity.deviceId,
        deviceName: serverIdentity.deviceName,
        httpPort: server.localHttpPort,
        nonce: List<int>.filled(16, 1),
      ),
      address: InternetAddress.loopbackIPv4,
      lastSeenUtc: DateTime.now().toUtc(),
    );

    await client.pair(peer, server.pairingCode!.value);

    final synced = await (serverDatabase.select(
      serverDatabase.ingredients,
    )..where((row) => row.id.equals(ingredient.id))).getSingle();
    expect(synced.name, '沉香');
    expect(await serverMedia.fileFor(firstHash).readAsBytes(), firstImage);
    expect(await serverMedia.fileFor(batchHash2).readAsBytes(), batchImage2);
    expect(await serverMedia.fileFor(batchHash3).readAsBytes(), batchImage3);
    expect(client.isPaired(serverIdentity.deviceId), isTrue);
    expect(server.isPaired(clientIdentity.deviceId), isTrue);
    expect(server.isServerPaired, isTrue);
    expect(server.pairingCode, isNotNull);

    final automatic = await clientDatabase.createIngredientCategory('自动同步');
    for (var i = 0; i < 50; i++) {
      final found = await (serverDatabase.select(
        serverDatabase.ingredientCategories,
      )..where((row) => row.id.equals(automatic.id))).getSingleOrNull();
      if (found != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(
      await (serverDatabase.select(
        serverDatabase.ingredientCategories,
      )..where((row) => row.id.equals(automatic.id))).getSingle(),
      isNotNull,
    );

    final secondImage = Uint8List.fromList(
      List<int>.generate(50000, (i) => 255 - (i % 256)),
    );
    final secondHash = await serverMedia.putJpeg(secondImage);
    await serverDatabase.updateIngredient(
      synced.id,
      name: synced.name,
      categoryId: synced.categoryId,
      imageHash: secondHash,
      alias: synced.alias,
      notes: synced.notes,
    );
    await client.syncAll();
    expect(await clientMedia.fileFor(secondHash).readAsBytes(), secondImage);
  });

  test('first sync drains large batches beyond 256 operations', () async {
    final serverDatabase = AppDatabase(NativeDatabase.memory());
    final clientDatabase = AppDatabase(NativeDatabase.memory());
    await serverDatabase.initialize();
    await clientDatabase.initialize();
    final serverIdentity = await PeerIdentity.create(
      deviceId: 'z-server-device',
      deviceName: 'Xiaomi 15 Pro',
    );
    final clientIdentity = await PeerIdentity.create(
      deviceId: 'a-client-device',
      deviceName: 'Redmi Pad',
    );
    final server = PeerSyncRuntime(
      identity: serverIdentity,
      groupId: 'store-1',
      database: serverDatabase,
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    final client = PeerSyncRuntime(
      identity: clientIdentity,
      groupId: 'store-1',
      database: clientDatabase,
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    addTearDown(server.close);
    addTearDown(client.close);
    addTearDown(serverDatabase.close);
    addTearDown(clientDatabase.close);
    await server.start();
    await client.start();

    final category = await serverDatabase.createIngredientCategory('木类');
    final notes = List.filled(2048, '香').join();
    for (var i = 0; i < 260; i++) {
      await serverDatabase.createIngredient(
        name: '香料$i',
        categoryId: category.id,
        notes: notes,
      );
    }

    await client.pair(
      PeerDiscoveryPeer(
        advertisement: PeerDiscoveryAdvertisement(
          groupId: 'store-1',
          deviceId: serverIdentity.deviceId,
          deviceName: serverIdentity.deviceName,
          httpPort: server.localHttpPort,
          nonce: List<int>.filled(16, 4),
        ),
        address: InternetAddress.loopbackIPv4,
        lastSeenUtc: DateTime.now().toUtc(),
      ),
      server.pairingCode!.value,
    );

    expect(
      await clientDatabase.select(clientDatabase.ingredients).get(),
      hasLength(260),
    );
  });

  test('permanent sync failures pause automatic retries', () async {
    final serverDatabase = AppDatabase(NativeDatabase.memory());
    final clientDatabase = AppDatabase(NativeDatabase.memory());
    await serverDatabase.initialize();
    await clientDatabase.initialize();
    final serverIdentity = await PeerIdentity.create(
      deviceId: 'server-device',
      deviceName: 'Redmi Pad',
    );
    final clientIdentity = await PeerIdentity.create(
      deviceId: 'client-device',
      deviceName: 'Xiaomi 15 Pro',
    );
    var syncRequests = 0;
    final server = PeerHttpServer(
      identity: serverIdentity,
      groupId: 'store-1',
      pairingCode: PairingCode.issue(),
      expectedRemoteDeviceName: clientIdentity.deviceName,
      onMessage: (_, payload) async {
        if (payload is Map && payload['kind'] == 'peer-status') {
          return {
            'kind': 'peer-status-result',
            'requiresRejoin': false,
            'vector': const <String, int>{},
          };
        }
        if (payload is Map && payload['kind'] == 'sync-batch') {
          syncRequests++;
          throw const FormatException('测试数据错误');
        }
        return {'kind': 'echo', 'payload': payload};
      },
    );
    final client = PeerSyncRuntime(
      identity: clientIdentity,
      groupId: 'store-1',
      database: clientDatabase,
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
      syncInterval: const Duration(milliseconds: 30),
    );
    addTearDown(server.close);
    addTearDown(client.close);
    addTearDown(serverDatabase.close);
    addTearDown(clientDatabase.close);
    await server.start();
    await client.start();

    final peer = PeerDiscoveryPeer(
      advertisement: PeerDiscoveryAdvertisement(
        groupId: 'store-1',
        deviceId: serverIdentity.deviceId,
        deviceName: serverIdentity.deviceName,
        httpPort: server.uri.port,
        nonce: List<int>.filled(16, 5),
      ),
      address: InternetAddress.loopbackIPv4,
      lastSeenUtc: DateTime.now().toUtc(),
    );
    await client.pair(peer, server.pairingCode.value);
    for (var i = 0; i < 20 && syncRequests == 0; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(syncRequests, 1);

    await clientDatabase.createIngredientCategory('本地变更');
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(syncRequests, 1);
  });

  test('trusted devices reconnect from discovery without a PIN', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-trust-');
    addTearDown(() => directory.delete(recursive: true));
    final serverTrustFile = File('${directory.path}/server-trust.json');
    final clientTrustFile = File('${directory.path}/client-trust.json');
    final serverIdentity = await PeerIdentity.create(
      deviceId: 'server-device',
      deviceName: 'Pad',
    );
    final clientIdentity = await PeerIdentity.create(
      deviceId: 'client-device',
      deviceName: 'Xiaomi 15 Pro',
    );
    final server = PeerSyncRuntime(
      identity: serverIdentity,
      groupId: 'store-1',
      trustStore: PeerTrustStore(serverTrustFile),
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    final client = PeerSyncRuntime(
      identity: clientIdentity,
      groupId: 'store-1',
      trustStore: PeerTrustStore(clientTrustFile),
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    addTearDown(server.close);
    addTearDown(client.close);
    await server.start();
    await client.start();
    await client.pair(
      PeerDiscoveryPeer(
        advertisement: PeerDiscoveryAdvertisement(
          groupId: 'store-1',
          deviceId: serverIdentity.deviceId,
          deviceName: serverIdentity.deviceName,
          httpPort: server.localHttpPort,
          nonce: List<int>.filled(16, 1),
        ),
        address: InternetAddress.loopbackIPv4,
        lastSeenUtc: DateTime.now().toUtc(),
      ),
      server.pairingCode!.value,
    );
    await client.close();
    await server.close();

    final portProbe = await RawDatagramSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final discoveryPort = portProbe.port;
    portProbe.close();
    final restartedServer = PeerSyncRuntime(
      identity: serverIdentity,
      groupId: 'store-1',
      trustStore: PeerTrustStore(serverTrustFile),
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: 0,
      announceImmediately: false,
    );
    final restartedClient = PeerSyncRuntime(
      identity: clientIdentity,
      groupId: 'store-1',
      trustStore: PeerTrustStore(clientTrustFile),
      bindAddress: InternetAddress.loopbackIPv4,
      discoveryBindPort: discoveryPort,
      announceImmediately: false,
    );
    addTearDown(restartedServer.close);
    addTearDown(restartedClient.close);
    await restartedServer.start();
    await restartedClient.start();

    final sender = await RawDatagramSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(sender.close);
    sender.send(
      utf8.encode(
        jsonEncode(
          PeerDiscoveryAdvertisement(
            groupId: 'store-1',
            deviceId: serverIdentity.deviceId,
            deviceName: serverIdentity.deviceName,
            httpPort: restartedServer.localHttpPort,
            nonce: List<int>.filled(16, 2),
          ).toJson(),
        ),
      ),
      InternetAddress.loopbackIPv4,
      discoveryPort,
    );
    for (var i = 0; i < 50 && !restartedClient.isPaired('server-device'); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    expect(restartedClient.isPaired('server-device'), isTrue);
    expect(restartedServer.isServerPaired, isTrue);
  });

  test(
    'revoked device uses a new PIN and rejoins through quarantine',
    () async {
      final directory = await Directory.systemTemp.createTemp('xiang-rejoin-');
      final authorityDatabase = AppDatabase(NativeDatabase.memory());
      final deviceDatabase = AppDatabase(NativeDatabase.memory());
      final authorityTrust = PeerTrustStore(
        File('${directory.path}/authority-trust.json'),
      );
      final deviceTrust = PeerTrustStore(
        File('${directory.path}/device-trust.json'),
      );
      await authorityDatabase.initialize();
      await deviceDatabase.initialize();
      final authorityIdentity = await PeerIdentity.create(
        deviceId: 'authority-device',
        deviceName: 'Pad',
      );
      final deviceIdentity = await PeerIdentity.create(
        deviceId: 'removed-device',
        deviceName: 'Xiaomi 15 Pro',
      );
      final authority = PeerSyncRuntime(
        identity: authorityIdentity,
        groupId: 'store-1',
        database: authorityDatabase,
        trustStore: authorityTrust,
        bindAddress: InternetAddress.loopbackIPv4,
        discoveryBindPort: 0,
        announceImmediately: false,
      );
      final device = PeerSyncRuntime(
        identity: deviceIdentity,
        groupId: 'store-1',
        database: deviceDatabase,
        trustStore: deviceTrust,
        bindAddress: InternetAddress.loopbackIPv4,
        discoveryBindPort: 0,
        announceImmediately: false,
      );
      addTearDown(() => directory.delete(recursive: true));
      addTearDown(authorityDatabase.close);
      addTearDown(deviceDatabase.close);
      addTearDown(authority.close);
      addTearDown(device.close);
      await authority.start();
      await device.start();

      PeerDiscoveryPeer authorityPeer() => PeerDiscoveryPeer(
        advertisement: PeerDiscoveryAdvertisement(
          groupId: 'store-1',
          deviceId: authorityIdentity.deviceId,
          deviceName: authorityIdentity.deviceName,
          httpPort: authority.localHttpPort,
          nonce: List<int>.filled(16, 3),
        ),
        address: InternetAddress.loopbackIPv4,
        lastSeenUtc: DateTime.now().toUtc(),
      );

      await device.pair(authorityPeer(), authority.pairingCode!.value);
      for (var i = 0; i < 50 && !authority.canSync; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(authority.canSync, isTrue);
      final shared = await authorityDatabase.createIngredientCategory('共享木类');
      await device.syncAll();
      final oldTrust = (await deviceTrust.find(authorityIdentity.deviceId))!;

      await authority.removeDevice(deviceIdentity.deviceId);
      expect(await authorityTrust.find(deviceIdentity.deviceId), isNull);
      expect(
        (await authorityDatabase.peerDevice(
          deviceIdentity.deviceId,
        ))?.isRevoked,
        isTrue,
      );
      expect(
        (await deviceDatabase.peerDevice(deviceIdentity.deviceId))?.isRevoked,
        isTrue,
      );

      await deviceDatabase.updateIngredientCategory(shared.id, name: '离线修改');
      final created = await deviceDatabase.createIngredientCategory('离线新增');
      final groupLatest = await authorityDatabase.createIngredientCategory(
        '设备组最新资料',
      );

      await expectLater(
        PeerHttpClient.connect(
          identity: deviceIdentity,
          groupId: 'store-1',
          serverUri: Uri(
            scheme: 'http',
            host: InternetAddress.loopbackIPv4.address,
            port: authority.localHttpPort,
          ),
          pairingCode: oldTrust.token,
          trustedToken: oldTrust.token,
          expectedRemoteDeviceName: authorityIdentity.deviceName,
          expectedRemoteIdentityPublicKey: oldTrust.identityPublicKey,
        ),
        throwsA(isA<StateError>()),
      );

      await device.pair(authorityPeer(), authority.pairingCode!.value);
      final newTrust = (await deviceTrust.find(authorityIdentity.deviceId))!;
      expect(newTrust.token, isNot(oldTrust.token));
      expect(
        (await authorityDatabase.peerDevice(
          deviceIdentity.deviceId,
        ))?.isPendingRejoin,
        isTrue,
      );
      expect(
        await (authorityDatabase.select(authorityDatabase.ingredientCategories)
              ..where((row) => row.id.equals(created.id)))
            .getSingle()
            .then((row) => row.name),
        '离线新增',
      );
      expect(
        await authorityDatabase.quarantinedConflictCount('removed-device'),
        1,
      );
      expect(
        await (deviceDatabase.select(
          deviceDatabase.ingredientCategories,
        )..where((row) => row.id.equals(groupLatest.id))).getSingleOrNull(),
        isNull,
        reason: '保护性重新加入完成前不应下发设备组最新资料',
      );

      final conflict =
          (await authorityDatabase.watchPendingSyncConflicts().first).single;
      await authorityDatabase.resolveSyncConflict(
        conflict.id,
        chosenRevisionId: conflict.firstRevisionId,
      );
      await authority.completeDeviceRejoin(deviceIdentity.deviceId);
      await device.syncAll();

      expect(
        await (deviceDatabase.select(deviceDatabase.ingredientCategories)
              ..where((row) => row.id.equals(groupLatest.id)))
            .getSingle()
            .then((row) => row.name),
        '设备组最新资料',
      );
    },
  );
}
