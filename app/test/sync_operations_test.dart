import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  test(
    'replicates ingredient dependencies and ignores duplicate operations',
    () async {
      final source = AppDatabase(NativeDatabase.memory());
      final target = AppDatabase(NativeDatabase.memory());
      addTearDown(source.close);
      addTearDown(target.close);
      await source.initialize();
      await target.initialize();

      final category = await source.createIngredientCategory('木类');
      final ingredient = await source.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      final operations = await source.select(source.syncOperations).get();
      final batch = [
        for (final operation in operations)
          Map<String, dynamic>.from(syncOperationToJson(operation)),
      ];

      expect(await target.applyRemoteSyncOperations(batch), 2);
      expect(
        await (target.select(
          target.ingredients,
        )..where((row) => row.id.equals(ingredient.id))).getSingle(),
        isNotNull,
      );
      expect(await target.applyRemoteSyncOperations(batch), 0);
      expect(
        (await target.syncVector())[await source.localDevice().then(
          (d) => d.id,
        )],
        2,
      );

      await source.updateIngredient(
        ingredient.id,
        name: '沉香木',
        categoryId: ingredient.categoryId,
        imageHash: ingredient.imageHash,
        alias: ingredient.alias,
        notes: ingredient.notes,
      );
      final update = (await source.select(source.syncOperations).get()).last;
      await target.applyRemoteSyncOperations([
        Map<String, dynamic>.from(syncOperationToJson(update)),
      ]);
      final synced = await (target.select(
        target.ingredients,
      )..where((row) => row.id.equals(ingredient.id))).getSingle();
      expect(synced.name, '沉香木');
      expect(jsonDecode(update.payloadJson)['name'], '沉香木');
    },
  );

  test(
    'keeps both concurrent ingredient snapshots and syncs the resolution',
    () async {
      final a = AppDatabase(NativeDatabase.memory());
      final b = AppDatabase(NativeDatabase.memory());
      final c = AppDatabase(NativeDatabase.memory());
      addTearDown(a.close);
      addTearDown(b.close);
      addTearDown(c.close);
      await a.initialize();
      await b.initialize();
      await c.initialize();

      Future<void> exchange(AppDatabase source, AppDatabase target) async {
        await target.applyRemoteSyncOperations([
          for (final operation in await source.syncOperationsMissingFrom(
            await target.syncVector(),
          ))
            Map<String, dynamic>.from(syncOperationToJson(operation)),
        ]);
      }

      final category = await a.createIngredientCategory('木类');
      final ingredient = await a.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      await exchange(a, b);
      await exchange(a, c);

      await b.updateIngredient(
        ingredient.id,
        name: 'B-EDIT',
        categoryId: ingredient.categoryId,
        imageHash: ingredient.imageHash,
        alias: ingredient.alias,
        notes: ingredient.notes,
      );
      await c.updateIngredient(
        ingredient.id,
        name: 'C-EDIT',
        categoryId: ingredient.categoryId,
        imageHash: ingredient.imageHash,
        alias: ingredient.alias,
        notes: ingredient.notes,
      );
      await exchange(c, b);
      await exchange(b, a);

      final conflicts = await b.watchPendingSyncConflicts().first;
      expect(conflicts, hasLength(1));
      expect(await a.pendingSyncConflictCount(), 1);
      final conflict = conflicts.single;
      final snapshots = [
        jsonDecode(conflict.firstSnapshotJson) as Map<String, dynamic>,
        jsonDecode(conflict.secondSnapshotJson) as Map<String, dynamic>,
      ];
      expect(snapshots.map((item) => item['name']), {'B-EDIT', 'C-EDIT'});
      final chosen = snapshots.singleWhere((item) => item['name'] == 'C-EDIT');
      await b.resolveSyncConflict(
        conflict.id,
        chosenRevisionId: chosen['revisionId'] as String,
      );
      expect(await b.pendingSyncConflictCount(), 0);
      expect(
        await (b.select(b.ingredients)
              ..where((row) => row.id.equals(ingredient.id)))
            .getSingle()
            .then((value) => value.name),
        'C-EDIT',
      );

      await exchange(b, c);
      expect(await c.pendingSyncConflictCount(), 0);
      expect(
        await (c.select(c.ingredients)
              ..where((row) => row.id.equals(ingredient.id)))
            .getSingle()
            .then((value) => value.name),
        'C-EDIT',
      );
    },
  );

  test(
    'replicates recommendation, customer, plaque, asset and formula data',
    () async {
      final source = AppDatabase(NativeDatabase.memory());
      final target = AppDatabase(NativeDatabase.memory());
      addTearDown(source.close);
      addTearDown(target.close);
      await source.initialize();
      await target.initialize();

      final productionType = (await source.watchProductionTypes().first).first;
      final category = await source.createIngredientCategory('木类');
      final ingredient = await source.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      await source.setRatioRange(
        target: RatioRangeTarget.ingredient,
        targetId: ingredient.id,
        productionTypeId: productionType.id,
        minRatio: 100,
        maxRatio: 200,
      );
      final preset = await source.createRecommendationPreset(
        name: '线香配置',
        productionTypeId: productionType.id,
      );
      final group = await source.createRecommendationGroup(
        presetId: preset.id,
        categoryId: category.id,
        ratio: 200,
      );
      await source.createRecommendationItem(
        groupId: group.id,
        ingredientId: ingredient.id,
        ratio: 100,
      );
      final customer = await source.createCustomer(
        name: '张三',
        phone: '13800000000',
      );
      final plaque = await source.createPlaqueType(
        name: '圆牌',
        imageHash: null,
        specification: '50mm',
        notes: null,
      );
      final assetCategory = await source.createAssetCategory('原料');
      final assetStatus = await source.createAssetStatus('在库');
      final asset = await source.createAsset(
        name: '沉香库存',
        categoryId: assetCategory.id,
        statusId: assetStatus.id,
        imageHash: null,
        quantity: 3,
        location: 'A1',
        notes: null,
      );
      final draft = await source.createFormulaDraft(
        productionTypeId: productionType.id,
        targetWeight: 100,
        items: [
          FormulaDraftItemInput(
            ingredientId: ingredient.id,
            categoryName: category.name,
            ingredientName: ingredient.name,
            ratio: 10000,
            sortOrder: 0,
          ),
        ],
        formulaName: '测试香方',
        customerId: customer.id,
        plaqueTypeId: plaque.id,
      );
      final warnings = await source.getDraftRangeWarnings(draft.id);
      await source.confirmDraftWarnings(
        draft.id,
        warnings.map((warning) => warning.key),
      );
      final session = await source.completeDraft(draft.id);
      const formulaImage =
          'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
      await source.updateFormulaImage(session.formulaId!, formulaImage);

      for (var i = 0; i < 8; i++) {
        final operations = await source.syncOperationsMissingFrom(
          await target.syncVector(),
          limit: 128,
        );
        if (operations.isEmpty) break;
        await target.applyRemoteSyncOperations([
          for (final operation in operations)
            Map<String, dynamic>.from(syncOperationToJson(operation)),
        ]);
      }

      expect(
        await target.select(target.ingredientRatioRanges).get(),
        hasLength(1),
      );
      expect(
        await target.select(target.recommendationPresets).get(),
        hasLength(1),
      );
      expect(
        await target.select(target.recommendationGroups).get(),
        hasLength(1),
      );
      expect(
        await target.select(target.recommendationItems).get(),
        hasLength(1),
      );
      expect(await target.select(target.customers).get(), hasLength(1));
      expect(await target.select(target.plaqueTypes).get(), hasLength(1));
      expect(
        await target
            .select(target.assets)
            .getSingle()
            .then((value) => value.id),
        asset.id,
      );
      expect(
        await (target.select(target.formulaDrafts)
              ..where((row) => row.id.equals(draft.id)))
            .getSingle()
            .then((value) => value.formulaName),
        '测试香方',
      );
      expect(
        await target
            .select(target.formulas)
            .getSingle()
            .then((value) => value.imageHash),
        formulaImage,
      );
      expect(await target.select(target.formulaVersions).get(), hasLength(1));
      expect(await target.select(target.formulaItems).get(), hasLength(1));
      expect(
        await (target.select(target.mixingSessions)
              ..where((row) => row.id.equals(session.id)))
            .getSingle()
            .then((value) => value.formulaName),
        '测试香方',
      );
      expect(await target.select(target.mixingItems).get(), hasLength(1));
    },
  );

  test(
    'replicates device revocation across missing and divergent rows',
    () async {
      final authority = AppDatabase(NativeDatabase.memory());
      final removed = AppDatabase(NativeDatabase.memory());
      final replica = AppDatabase(NativeDatabase.memory());
      addTearDown(authority.close);
      addTearDown(removed.close);
      addTearDown(replica.close);
      await authority.initialize();
      await removed.initialize();
      await replica.initialize();

      final key = List<int>.generate(32, (index) => index);
      await authority.rememberPeerDevice(
        deviceId: 'device-b',
        deviceName: 'Xiaomi 15 Pro',
        identityPublicKey: key,
      );
      await replica.rememberPeerDevice(
        deviceId: 'device-b',
        deviceName: 'Xiaomi 15 Pro',
        identityPublicKey: key,
      );
      await authority.revokePeerDevice('device-b');
      final revocation =
          (await authority.select(authority.syncOperations).get()).lastWhere(
            (operation) =>
                operation.entityType == 'devices' &&
                operation.entityId == 'device-b' &&
                jsonDecode(operation.payloadJson)['isRevoked'] == true,
          );
      final payload = Map<String, dynamic>.from(
        syncOperationToJson(revocation),
      );

      await removed.applyRemoteSyncOperations([payload]);
      await replica.applyRemoteSyncOperations([payload]);

      expect((await removed.peerDevice('device-b'))?.isRevoked, isTrue);
      expect((await replica.peerDevice('device-b'))?.isRevoked, isTrue);
    },
  );

  test(
    'quarantines existing edits, merges new rows and completes rejoin',
    () async {
      final authority = AppDatabase(NativeDatabase.memory());
      final rejoining = AppDatabase(NativeDatabase.memory());
      addTearDown(authority.close);
      addTearDown(rejoining.close);
      await authority.initialize();
      await rejoining.initialize();

      final shared = await authority.createIngredientCategory('共享木类');
      await rejoining.applyRemoteSyncOperations([
        for (final operation in await authority.syncOperationsMissingFrom({}))
          Map<String, dynamic>.from(syncOperationToJson(operation)),
      ]);
      await authority.rememberPeerDevice(
        deviceId: 'device-b',
        deviceName: 'Xiaomi 15 Pro',
        identityPublicKey: List<int>.filled(32, 7),
        pendingRejoin: true,
      );

      await rejoining.updateIngredientCategory(shared.id, name: '离线修改');
      final created = await rejoining.createIngredientCategory('离线新增');
      final operations = await rejoining.syncOperationsMissingFrom(
        await authority.syncVector(),
        forRejoin: true,
      );
      final result = await authority
          .receiveQuarantinedSyncOperations('device-b', [
            for (final operation in operations)
              Map<String, dynamic>.from(syncOperationToJson(operation)),
          ]);

      expect(result, {'accepted': 1, 'conflicts': 1});
      expect(
        await (authority.select(authority.ingredientCategories)
              ..where((row) => row.id.equals(created.id)))
            .getSingle()
            .then((row) => row.name),
        '离线新增',
      );
      expect(
        await (authority.select(authority.ingredientCategories)
              ..where((row) => row.id.equals(shared.id)))
            .getSingle()
            .then((row) => row.name),
        '共享木类',
      );
      expect(await authority.quarantinedConflictCount('device-b'), 1);
      await expectLater(
        authority.completePeerRejoin('device-b'),
        throwsA(isA<StateError>()),
      );

      final conflict =
          (await authority.watchPendingSyncConflicts().first).single;
      await authority.resolveSyncConflict(
        conflict.id,
        chosenRevisionId: conflict.firstRevisionId,
      );
      await authority.completePeerRejoin('device-b');

      expect(await authority.quarantinedConflictCount('device-b'), 0);
      expect(await authority.isPeerPendingRejoin('device-b'), isFalse);
    },
  );
}
