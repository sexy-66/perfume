import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  test(
    'v8 to v11 preserves formulas and adds per-type ratio metadata',
    () async {
      final executor = NativeDatabase.memory(
        setup: (raw) {
          raw.execute('''
          CREATE TABLE formulas (
            id TEXT NOT NULL PRIMARY KEY,
            revision_id TEXT NOT NULL,
            updated_by_device TEXT NOT NULL,
            updated_at_utc INTEGER NOT NULL,
            is_deleted INTEGER NOT NULL DEFAULT 0,
            deleted_at_utc INTEGER,
            name TEXT NOT NULL,
            image_hash TEXT,
            notes TEXT,
            current_version_id TEXT,
            last_used_at_utc INTEGER
          )
        ''');
          raw.execute('''
          CREATE TABLE formula_versions (
            id TEXT NOT NULL PRIMARY KEY,
            revision_id TEXT NOT NULL,
            updated_by_device TEXT NOT NULL,
            updated_at_utc INTEGER NOT NULL,
            is_deleted INTEGER NOT NULL DEFAULT 0,
            deleted_at_utc INTEGER,
            formula_id TEXT NOT NULL,
            version_number INTEGER NOT NULL,
            source_version_id TEXT,
            production_type_id TEXT NOT NULL,
            created_at_utc INTEGER NOT NULL
          )
        ''');
          raw.execute('''
          CREATE TABLE formula_drafts (
            id TEXT NOT NULL PRIMARY KEY,
            revision_id TEXT NOT NULL,
            updated_by_device TEXT NOT NULL,
            updated_at_utc INTEGER NOT NULL,
            is_deleted INTEGER NOT NULL DEFAULT 0,
            deleted_at_utc INTEGER,
            kind TEXT NOT NULL,
            formula_id TEXT,
            source_version_id TEXT,
            customer_id TEXT,
            plaque_type_id TEXT,
            formula_name TEXT NOT NULL DEFAULT '',
            production_type_id TEXT NOT NULL,
            target_weight INTEGER NOT NULL,
            notes TEXT,
            items_json TEXT NOT NULL,
            actual_weights_json TEXT NOT NULL,
            confirmed_warnings_json TEXT NOT NULL DEFAULT '[]',
            created_at_utc INTEGER NOT NULL
          )
        ''');
          raw.execute('''
          INSERT INTO formula_versions (
            id, revision_id, updated_by_device, updated_at_utc, formula_id,
            version_number, production_type_id, created_at_utc
          ) VALUES (
            'version-1', 'revision-3', 'device-1', 0, 'formula-1', 1,
            'type-zhuanxiang', 0
          )
        ''');
          raw.execute('''
          INSERT INTO formulas (
            id, revision_id, updated_by_device, updated_at_utc, name, notes
          ) VALUES ('formula-1', 'revision-1', 'device-1', 0, '旧香方', '旧备注')
        ''');
          raw.execute('''
          INSERT INTO formula_drafts (
            id, revision_id, updated_by_device, updated_at_utc, kind,
            formula_name, production_type_id, target_weight, items_json,
            actual_weights_json, created_at_utc
          ) VALUES (
            'draft-1', 'revision-2', 'device-1', 0, 'composing-new',
            '旧草稿', 'type-zhuanxiang', 1, '{}', '[]', 0
          )
        ''');
          raw.execute('PRAGMA user_version = 8');
        },
      );
      final database = AppDatabase(executor);
      addTearDown(database.close);

      final formula = await (database.select(
        database.formulas,
      )..where((row) => row.id.equals('formula-1'))).getSingle();
      final draft = await (database.select(
        database.formulaDrafts,
      )..where((row) => row.id.equals('draft-1'))).getSingle();
      final version = await database
          .select(database.formulaVersions)
          .getSingle();
      expect(
        (formula.name, formula.notes, formula.isRecommended),
        ('旧香方', '旧备注', false),
      );
      expect(
        (draft.formulaName, draft.imageHash, draft.isRecommended),
        ('旧草稿', null, false),
      );
      expect(
        (draft.productionTypeIdsJson, draft.productionTypeRatiosJson),
        ('["type-zhuanxiang"]', '{}'),
      );
      expect(draft.allItemsJson, '[]');
      expect(version.productionTypeIdsJson, '["type-zhuanxiang"]');
    },
  );

  test(
    'v1 to v8 resets incompatible business data and creates new schema',
    () async {
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

      final productionTypes = await database
          .select(database.productionTypes)
          .get();
      expect(productionTypes, hasLength(3));
      expect(productionTypes.any((row) => row.id == 'legacy'), false);
      expect(
        productionTypes
            .singleWhere((row) => row.id == combinedProductionTypeId)
            .name,
        '合香珠 / 香牌',
      );
      expect(
        await database.select(database.ingredientCategories).get(),
        isEmpty,
      );
      expect(await database.select(database.assets).get(), isEmpty);
      expect(await database.select(database.formulas).get(), isEmpty);
      expect(await database.select(database.mixingSessions).get(), isEmpty);
      expect(await database.select(database.syncConflicts).get(), isEmpty);
      expect(await database.select(database.peerDevices).get(), isEmpty);
      expect(await database.select(database.syncCursors).get(), isEmpty);
      expect(await database.select(database.purgedSyncEntities).get(), isEmpty);
      expect(
        await database.select(database.quarantinedSyncOperations).get(),
        isEmpty,
      );
      expect(
        (await database.customSelect('PRAGMA integrity_check').getSingle())
            .read<String>('integrity_check'),
        'ok',
      );
      expect(
        await database.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
      expect(
        (await database
            .customSelect(
              "SELECT last_sync_at_utc FROM devices WHERE id = 'missing'",
            )
            .get()),
        isEmpty,
      );
    },
  );
}
