import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  test('v1 to v2 keeps existing data and creates M2 tables', () async {
    final executor = NativeDatabase.memory(
      setup: (raw) {
        raw.execute('''
          CREATE TABLE production_types (
            id TEXT NOT NULL PRIMARY KEY,
            revision_id TEXT NOT NULL,
            updated_by_device TEXT NOT NULL,
            updated_at_utc INTEGER NOT NULL,
            is_deleted INTEGER NOT NULL DEFAULT 0,
            deleted_at_utc INTEGER,
            name TEXT NOT NULL,
            sort_order INTEGER NOT NULL,
            is_inactive INTEGER NOT NULL DEFAULT 0
          )
        ''');
        raw.execute('''
          CREATE TABLE local_devices (
            id TEXT NOT NULL PRIMARY KEY,
            device_seq INTEGER NOT NULL DEFAULT 0,
            created_at_utc INTEGER NOT NULL
          )
        ''');
        raw.execute('''
          CREATE TABLE sync_operations (
            operation_id TEXT NOT NULL PRIMARY KEY,
            origin_device_id TEXT NOT NULL,
            device_seq INTEGER NOT NULL,
            entity_type TEXT NOT NULL,
            entity_id TEXT NOT NULL,
            base_revision_id TEXT,
            new_revision_id TEXT NOT NULL,
            operation_kind TEXT NOT NULL,
            payload_json TEXT NOT NULL,
            created_at_utc INTEGER NOT NULL,
            UNIQUE (origin_device_id, device_seq)
          )
        ''');
        raw.execute('''
          INSERT INTO production_types (
            id, revision_id, updated_by_device, updated_at_utc,
            name, sort_order
          ) VALUES ('legacy', 'revision', 'device', 0, '旧类型', 99)
        ''');
        raw.execute('PRAGMA user_version = 1');
      },
    );
    final database = AppDatabase(executor);
    addTearDown(database.close);

    await database.initialize();

    expect(
      (await database.select(database.productionTypes).get()).any(
        (row) => row.id == 'legacy' && row.name == '旧类型',
      ),
      true,
    );
    expect(await database.select(database.ingredientCategories).get(), isEmpty);
    expect(await database.select(database.assets).get(), isEmpty);
    expect(
      (await database.customSelect('PRAGMA integrity_check').getSingle())
          .read<String>('integrity_check'),
      'ok',
    );
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });
}
