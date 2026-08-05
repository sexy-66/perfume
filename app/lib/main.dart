import 'package:flutter/widgets.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'data/media_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.defaults();
  final mediaStore = await MediaStore.defaults();
  await database.initialize();
  await mediaStore.initialize();
  runApp(XiangApp(database: database, mediaStore: mediaStore));
}
