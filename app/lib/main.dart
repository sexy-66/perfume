import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'data/media_store.dart';
import 'services/peer_identity_store.dart';
import 'services/peer_sync_runtime.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache
    ..maximumSize = 200
    ..maximumSizeBytes = 64 << 20;
  final database = AppDatabase.defaults();
  final mediaStore = await MediaStore.defaults();
  await Future.wait([database.initialize(), mediaStore.initialize()]);
  runApp(
    XiangApp(
      database: database,
      mediaStore: mediaStore,
      syncRuntimeLoader: () => _createSyncRuntime(database, mediaStore),
    ),
  );
}

Future<PeerSyncRuntime> _createSyncRuntime(
  AppDatabase database,
  MediaStore mediaStore,
) async {
  final device = await database.localDevice();
  final identityStore = await PeerIdentityStore.defaults();
  final trustStore = await PeerTrustStore.defaults();
  if (await identityStore.resetIfDeviceChanged(device.id)) {
    await trustStore.reset();
  }
  final identitySettings = await identityStore.loadOrCreate(
    deviceId: device.id,
    deviceName: await _deviceName(),
  );
  return PeerSyncRuntime(
    identity: identitySettings.identity,
    groupId: identitySettings.groupId,
    database: database,
    mediaStore: mediaStore,
    trustStore: trustStore,
  );
}

Future<String> _deviceName() async {
  try {
    final name = await const MethodChannel(
      'xiangfangbu/device',
    ).invokeMethod<String>('name');
    if (name != null && name.trim().isNotEmpty) return name.trim();
  } catch (_) {}
  return PeerIdentityStore.defaultDeviceName;
}
