import 'package:flutter/widgets.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'data/media_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.defaults();
  await database.initialize();
  await (await MediaStore.defaults()).initialize();
  runApp(XiangApp(database: database));
}
