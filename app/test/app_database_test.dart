import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
  });

  tearDown(() => database.close());

  test(
    'initializes the four structural production types and one device',
    () async {
      expect(
        await database.select(database.productionTypes).get(),
        hasLength(4),
      );
      final device = await database.localDevice();
      expect(device.id, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(device.deviceSeq, 0);
    },
  );

  test('writes a production type and sync operation atomically', () async {
    final created = await database.createProductionType('  香丸  ');
    final device = await database.localDevice();
    final operations = await database.select(database.syncOperations).get();
    expect(created.name, '香丸');
    expect(device.deviceSeq, 1);
    expect(operations, hasLength(1));
    expect(operations.single.deviceSeq, 1);
    expect(jsonDecode(operations.single.payloadJson)['name'], '香丸');
  });

  test('rejects blank production type names', () async {
    expect(() => database.createProductionType('  '), throwsArgumentError);
    expect(await database.select(database.productionTypes).get(), hasLength(4));
  });
}
