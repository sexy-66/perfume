import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';

const _imageHash =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
  });

  tearDown(() => database.close());

  test(
    'initializes the three structural production types and one device',
    () async {
      expect(
        await database.select(database.productionTypes).get(),
        hasLength(3),
      );
      final device = await database.localDevice();
      expect(device.id, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(device.deviceSeq, 0);
      for (final table in ['ingredients', 'assets']) {
        final columns = await database
            .customSelect('PRAGMA table_info($table)')
            .get();
        expect(
          columns.map((row) => row.read<String>('name')),
          isNot(contains('purchase_url')),
        );
      }
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
    expect(await database.select(database.productionTypes).get(), hasLength(3));
  });

  test(
    'production types update, reorder, protect defaults and restore',
    () async {
      final custom = await database.createProductionType('香丸');
      await database.updateProductionType(
        custom.id,
        name: '香丸类',
        isInactive: true,
      );
      await database.moveProductionType(custom.id, -1);
      var items = await database.watchProductionTypes().first;
      expect(items[items.length - 2].id, custom.id);
      expect(
        items.singleWhere((item) => item.id == custom.id).isInactive,
        true,
      );
      await expectLater(
        database.deleteProductionType('type-zhuanxiang'),
        throwsStateError,
      );

      await database.deleteProductionType(custom.id);
      final trash = await database.watchTrash().first;
      final deleted = trash.singleWhere(
        (item) => item.type == TrashEntityType.productionType,
      );
      await database.restoreTrashEntry(deleted);
      await database.updateProductionType(
        custom.id,
        name: '香丸类',
        isInactive: false,
      );
      await database.createRecommendationPreset(
        name: '香丸配置',
        productionTypeId: custom.id,
      );
      await expectLater(
        database.deleteProductionType(custom.id),
        throwsStateError,
      );
      items = await database.watchProductionTypes().first;
      expect(items.any((item) => item.id == custom.id), true);
    },
  );

  test('user ordered M2 reference lists persist moves', () async {
    await database.createIngredientCategory('木类');
    final category = await database.createIngredientCategory('花类');
    await database.moveIngredientCategory(category.id, -1);
    expect(
      (await database.watchIngredientCategories().first).first.id,
      category.id,
    );

    await database.createPlaqueType(name: '圆牌');
    final plaque = await database.createPlaqueType(name: '方牌');
    await database.movePlaqueType(plaque.id, -1);
    expect((await database.watchPlaqueTypes().first).first.id, plaque.id);

    await database.createRecommendationPreset(
      name: '配置一',
      productionTypeId: 'type-zhuanxiang',
    );
    final preset = await database.createRecommendationPreset(
      name: '配置二',
      productionTypeId: 'type-zhuanxiang',
    );
    await database.moveRecommendationPreset(preset.id, -1);
    expect(
      (await database.watchRecommendationPresets().first).first.preset.id,
      preset.id,
    );

    await database.createAssetCategory('工具');
    final assetCategory = await database.createAssetCategory('模具');
    await database.moveAssetCategory(assetCategory.id, -1);
    expect(
      (await database.watchAssetCategories().first).first.id,
      assetCategory.id,
    );
    await database.createAssetStatus('可用');
    final status = await database.createAssetStatus('维修');
    await database.moveAssetStatus(status.id, -1);
    expect((await database.watchAssetStatuses().first).first.id, status.id);
  });

  test('ingredient category changes are logged and reversible', () async {
    final category = await database.createIngredientCategory('  木类  ');
    await database.updateIngredientCategory(
      category.id,
      name: '木本',
      isInactive: true,
    );
    await database.deleteIngredientCategory(category.id);

    expect(await database.watchIngredientCategories().first, isEmpty);
    var deleted = await (database.select(
      database.ingredientCategories,
    )..where((row) => row.id.equals(category.id))).getSingle();
    expect(
      (deleted.name, deleted.isInactive, deleted.isDeleted),
      ('木本', true, true),
    );

    await database.restoreTrashEntry(
      (await database.watchTrash().first).singleWhere(
        (item) => item.type == TrashEntityType.ingredientCategory,
      ),
    );
    deleted = await (database.select(
      database.ingredientCategories,
    )..where((row) => row.id.equals(category.id))).getSingle();
    expect(deleted.isDeleted, false);
    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      ['create', 'update', 'delete', 'restore'],
    );
    expect((await database.localDevice()).deviceSeq, 4);
  });

  test('rejects invalid M2 records at the database boundary', () async {
    expect(
      () => database
          .into(database.customers)
          .insert(
            CustomersCompanion.insert(
              id: 'customer',
              revisionId: 'revision',
              updatedByDevice: 'device',
              updatedAtUtc: DateTime.utc(2026),
              createdAtUtc: DateTime.utc(2026),
            ),
          ),
      throwsA(anything),
    );
    expect(
      () => database
          .into(database.assets)
          .insert(
            AssetsCompanion.insert(
              id: 'asset',
              revisionId: 'revision',
              updatedByDevice: 'device',
              updatedAtUtc: DateTime.utc(2026),
              categoryId: 'missing-category',
              name: '压香器',
              quantity: -1,
            ),
          ),
      throwsA(anything),
    );
  });

  test('ingredient library searches, filters and logs changes', () async {
    final wood = await database.createIngredientCategory('木类');
    final flower = await database.createIngredientCategory('花类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      alias: '莞香',
      categoryId: wood.id,
    );

    expect(
      (await database.watchIngredients(search: '莞').first).single.categoryName,
      '木类',
    );
    expect(
      await database.watchIngredients(categoryId: flower.id).first,
      isEmpty,
    );

    await database.updateIngredient(
      ingredient.id,
      name: '沉香木',
      imageHash: ingredient.imageHash,
      alias: ingredient.alias,
      notes: ingredient.notes,
      categoryId: flower.id,
      isInactive: true,
    );
    expect(await database.watchIngredients().first, isEmpty);
    expect(
      (await database.watchIngredients(includeInactive: true).first)
          .single
          .categoryName,
      '花类',
    );

    await database.deleteIngredient(ingredient.id);
    expect(
      await database.watchIngredients(includeInactive: true).first,
      isEmpty,
    );
    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      ['create', 'create', 'create', 'update', 'delete'],
    );
  });

  test(
    'ingredient image and notes changes are logged and soft deleted',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '  沉香  ',
        categoryId: category.id,
        imageHash: _imageHash,
        notes: '库存样品',
      );

      expect((ingredient.name, ingredient.imageHash), ('沉香', _imageHash));
      await database.updateIngredient(
        ingredient.id,
        name: ingredient.name,
        categoryId: ingredient.categoryId,
        imageHash: ingredient.imageHash,
        alias: ingredient.alias,
        notes: '陈化样品',
        isInactive: true,
      );
      final updated =
          (await database.watchIngredients(includeInactive: true).first)
              .single
              .ingredient;
      expect((updated.notes, updated.imageHash), ('陈化样品', _imageHash));

      await database.deleteIngredient(ingredient.id);
      expect(
        (await database.select(database.syncOperations).get()).map(
          (operation) => operation.operationKind,
        ),
        ['create', 'create', 'update', 'delete'],
      );
    },
  );

  test('plaque catalog searches, updates, filters and soft deletes', () async {
    final plaque = await database.createPlaqueType(
      name: '  如意牌  ',
      imageHash: _imageHash,
      specification: '  6 × 3 cm  ',
      notes: '  常用  ',
    );
    expect(
      (plaque.name, plaque.specification, plaque.notes),
      ('如意牌', '6 × 3 cm', '常用'),
    );
    expect(
      await database.watchPlaqueTypes(search: '6 × 3').first,
      hasLength(1),
    );

    await database.updatePlaqueType(
      plaque.id,
      name: '祥云牌',
      imageHash: plaque.imageHash,
      specification: plaque.specification,
      notes: plaque.notes,
      isInactive: true,
    );
    expect(await database.watchPlaqueTypes().first, isEmpty);
    expect(
      (await database.watchPlaqueTypes(includeInactive: true).first)
          .single
          .name,
      '祥云牌',
    );
    await database.deletePlaqueType(plaque.id);
    expect(
      await database.watchPlaqueTypes(includeInactive: true).first,
      isEmpty,
    );
    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      ['create', 'update', 'delete'],
    );
  });

  test('customers validate identity, search, update and soft delete', () async {
    await expectLater(database.createCustomer(), throwsArgumentError);
    final customer = await database.createCustomer(
      phone: '  +81 90-1234-5678  ',
      notes: '  海外顾客  ',
    );
    expect(
      (customer.name, customer.phone, customer.notes),
      ('', '+81 90-1234-5678', '海外顾客'),
    );
    expect(
      (await database.watchCustomers(search: '90-1234').first).single.id,
      customer.id,
    );

    await database.updateCustomer(
      customer.id,
      name: '  王女士  ',
      phone: customer.phone,
      notes: customer.notes,
    );
    expect(
      (await database.watchCustomers(search: '王').first).single.name,
      '王女士',
    );
    await database.deleteCustomer(customer.id);
    expect(await database.watchCustomers().first, isEmpty);
    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      ['create', 'update', 'delete'],
    );
  });

  test('assets validate options, count, filter and soft delete', () async {
    final category = await database.createAssetCategory('工具');
    final status = await database.createAssetStatus('可用');
    await expectLater(
      database.createAsset(name: '压香器', categoryId: category.id, quantity: -1),
      throwsArgumentError,
    );
    final asset = await database.createAsset(
      name: '压香器',
      categoryId: category.id,
      statusId: status.id,
      quantity: 2,
      location: '工作台',
    );
    expect(
      (await database.watchAssets(search: '工作台').first).single.statusName,
      '可用',
    );
    await expectLater(
      database.deleteAssetCategory(category.id),
      throwsStateError,
    );

    await database.countAsset(asset.id, 5);
    var counted = await (database.select(
      database.assets,
    )..where((row) => row.id.equals(asset.id))).getSingle();
    expect((counted.quantity, counted.lastCountedAtUtc != null), (5, true));
    await database.updateAsset(
      asset.id,
      name: counted.name,
      categoryId: counted.categoryId,
      statusId: counted.statusId,
      imageHash: counted.imageHash,
      quantity: counted.quantity,
      location: counted.location,
      notes: counted.notes,
      isInactive: true,
    );
    expect(await database.watchAssets().first, isEmpty);
    expect(
      await database.watchAssets(includeInactive: true).first,
      hasLength(1),
    );

    await database.deleteAsset(asset.id);
    await database.deleteAssetCategory(category.id);
    await database.deleteAssetStatus(status.id);
    expect(await database.watchAssets(includeInactive: true).first, isEmpty);
    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      [
        'create',
        'create',
        'create',
        'count',
        'update',
        'delete',
        'delete',
        'delete',
      ],
    );
  });

  test('recently deleted records restore in dependency order', () async {
    final category = await database.createIngredientCategory('木类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    await database.deleteIngredient(ingredient.id);
    await database.deleteIngredientCategory(category.id);

    var trash = await database.watchTrash().first;
    expect(trash.map((item) => item.name).toSet(), {'木类', '沉香'});
    final ingredientEntry = trash.singleWhere(
      (item) => item.type == TrashEntityType.ingredient,
    );
    await expectLater(
      database.restoreTrashEntry(ingredientEntry),
      throwsStateError,
    );

    await database.restoreTrashEntry(
      trash.singleWhere(
        (item) => item.type == TrashEntityType.ingredientCategory,
      ),
    );
    await database.restoreTrashEntry(ingredientEntry);
    trash = await database.watchTrash().first;
    expect(trash, isEmpty);
    final expired = await database.createPlaqueType(name: '过期删除项');
    await database.deletePlaqueType(expired.id);
    await (database.update(
      database.plaqueTypes,
    )..where((row) => row.id.equals(expired.id))).write(
      PlaqueTypesCompanion(
        deletedAtUtc: Value(
          DateTime.now().toUtc().subtract(const Duration(days: 31)),
        ),
      ),
    );
    expect(await database.watchTrash().first, isEmpty);
    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      [
        'create',
        'create',
        'delete',
        'delete',
        'restore',
        'restore',
        'create',
        'delete',
      ],
    );
  });

  test(
    'ratio ranges save, validate, clear and restore at both levels',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      const productionTypeId = 'type-zhuanxiang';

      for (final target in [
        (RatioRangeTarget.category, category.id),
        (RatioRangeTarget.ingredient, ingredient.id),
      ]) {
        await database.setRatioRange(
          target: target.$1,
          targetId: target.$2,
          productionTypeId: productionTypeId,
          minRatio: 1250,
          maxRatio: 2500,
        );
        final setting =
            (await database.watchRatioRanges(target.$1, target.$2).first)
                .firstWhere(
                  (item) => item.productionTypeId == productionTypeId,
                );
        expect((setting.minRatio, setting.maxRatio), (1250, 2500));
      }

      await database.clearRatioRange(
        RatioRangeTarget.ingredient,
        ingredient.id,
        productionTypeId,
      );
      expect(
        (await database
                .watchRatioRanges(RatioRangeTarget.ingredient, ingredient.id)
                .first)
            .first
            .minRatio,
        isNull,
      );
      await database.setRatioRange(
        target: RatioRangeTarget.ingredient,
        targetId: ingredient.id,
        productionTypeId: productionTypeId,
        minRatio: 1500,
        maxRatio: 2000,
      );
      expect(
        (await database
                .watchRatioRanges(RatioRangeTarget.ingredient, ingredient.id)
                .first)
            .first
            .minRatio,
        1500,
      );
      expect(
        () => database.setRatioRange(
          target: RatioRangeTarget.ingredient,
          targetId: ingredient.id,
          productionTypeId: productionTypeId,
          minRatio: 2001,
          maxRatio: 2000,
        ),
        throwsArgumentError,
      );
    },
  );

  test('recommendation presets can be filtered, copied and deleted', () async {
    final preset = await database.createRecommendationPreset(
      name: '  篆香基础  ',
      productionTypeId: 'type-zhuanxiang',
      notes: '  店内常用  ',
    );
    expect((preset.name, preset.notes), ('篆香基础', '店内常用'));
    expect(
      (await database.watchRecommendationPresets(search: '篆香').first)
          .single
          .productionTypeName,
      '篆香',
    );

    await database.updateRecommendationPreset(
      preset.id,
      name: preset.name,
      productionTypeId: preset.productionTypeId,
      notes: preset.notes,
      isInactive: true,
    );
    expect(await database.watchRecommendationPresets().first, isEmpty);
    final copy = await database.copyRecommendationPreset(preset.id);
    expect(copy.name, '篆香基础 副本');
    await database.deleteRecommendationPreset(copy.id);

    expect(
      (await database.select(database.syncOperations).get()).map(
        (operation) => operation.operationKind,
      ),
      ['create', 'update', 'create', 'delete'],
    );
  });

  test(
    'recommendation composition validates totals and copies all rows',
    () async {
      final wood = await database.createIngredientCategory('木类');
      final flower = await database.createIngredientCategory('花类');
      final agarwood = await database.createIngredient(
        name: '沉香',
        categoryId: wood.id,
      );
      final rose = await database.createIngredient(
        name: '玫瑰',
        categoryId: flower.id,
      );
      final preset = await database.createRecommendationPreset(
        name: '配比测试',
        productionTypeId: 'type-zhuanxiang',
      );
      final group = await database.createRecommendationGroup(
        presetId: preset.id,
        categoryId: wood.id,
        ratio: 6000,
      );

      await expectLater(
        database.createRecommendationGroup(
          presetId: preset.id,
          categoryId: flower.id,
          ratio: 4001,
        ),
        throwsStateError,
      );
      await expectLater(
        database.createRecommendationItem(
          groupId: group.id,
          ingredientId: rose.id,
          ratio: 1000,
        ),
        throwsStateError,
      );
      final item = await database.createRecommendationItem(
        groupId: group.id,
        ingredientId: agarwood.id,
        ratio: 5000,
      );
      await expectLater(
        database.createRecommendationItem(
          groupId: group.id,
          ingredientId: agarwood.id,
          ratio: 1001,
        ),
        throwsStateError,
      );
      await expectLater(
        database.updateRecommendationGroupRatio(group.id, 4999),
        throwsStateError,
      );

      await database.updateRecommendationItemRatio(item.id, 6000);
      final copy = await database.copyRecommendationPreset(preset.id);
      final copiedGroups = await database
          .watchRecommendationGroups(copy.id)
          .first;
      expect(copiedGroups, hasLength(1));
      expect(
        (copiedGroups.single.ratio, copiedGroups.single.itemTotal),
        (6000, 6000),
      );
      expect(
        await database.watchRecommendationItems(copiedGroups.single.id).first,
        hasLength(1),
      );

      await expectLater(
        database.deleteRecommendationGroup(group.id),
        throwsStateError,
      );
      await database.deleteRecommendationItem(item.id);
      await database.deleteRecommendationGroup(group.id);
      expect(
        await database.watchRecommendationGroups(preset.id).first,
        isEmpty,
      );
      final restoredGroup = await database.createRecommendationGroup(
        presetId: preset.id,
        categoryId: wood.id,
        ratio: 6000,
      );
      final restoredItem = await database.createRecommendationItem(
        groupId: restoredGroup.id,
        ingredientId: agarwood.id,
        ratio: 6000,
      );
      expect((restoredGroup.id, restoredItem.id), (group.id, item.id));
    },
  );

  test(
    'soft delete rejects active range and recommendation dependencies',
    () async {
      final rangedCategory = await database.createIngredientCategory('区间分类');
      await database.setRatioRange(
        target: RatioRangeTarget.category,
        targetId: rangedCategory.id,
        productionTypeId: 'type-zhuanxiang',
        minRatio: 100,
        maxRatio: 200,
      );
      await expectLater(
        database.deleteIngredientCategory(rangedCategory.id),
        throwsStateError,
      );

      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: rangedCategory.id,
      );
      await database.setRatioRange(
        target: RatioRangeTarget.ingredient,
        targetId: ingredient.id,
        productionTypeId: 'type-zhuanxiang',
        minRatio: 100,
        maxRatio: 200,
      );
      await expectLater(
        database.deleteIngredient(ingredient.id),
        throwsStateError,
      );

      final groupedCategory = await database.createIngredientCategory('配置分类');
      final preset = await database.createRecommendationPreset(
        name: '配置',
        productionTypeId: 'type-zhuanxiang',
      );
      await database.createRecommendationGroup(
        presetId: preset.id,
        categoryId: groupedCategory.id,
        ratio: 10000,
      );
      await expectLater(
        database.deleteIngredientCategory(groupedCategory.id),
        throwsStateError,
      );
    },
  );

  test('deleted presets do not leave hidden dependency blockers', () async {
    final category = await database.createIngredientCategory('木类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final preset = await database.createRecommendationPreset(
      name: '配置',
      productionTypeId: 'type-zhuanxiang',
    );
    final group = await database.createRecommendationGroup(
      presetId: preset.id,
      categoryId: category.id,
      ratio: 10000,
    );
    await database.createRecommendationItem(
      groupId: group.id,
      ingredientId: ingredient.id,
      ratio: 10000,
    );

    await database.deleteRecommendationPreset(preset.id);
    await database.deleteIngredient(ingredient.id);
    await database.deleteIngredientCategory(category.id);
    var trash = await database.watchTrash().first;
    final presetEntry = trash.singleWhere(
      (item) => item.type == TrashEntityType.recommendationPreset,
    );
    await expectLater(
      database.restoreTrashEntry(presetEntry),
      throwsStateError,
    );

    for (final type in [
      TrashEntityType.ingredientCategory,
      TrashEntityType.ingredient,
    ]) {
      trash = await database.watchTrash().first;
      await database.restoreTrashEntry(
        trash.singleWhere((item) => item.type == type),
      );
    }
    await database.restoreTrashEntry(presetEntry);
    expect(
      await database.watchRecommendationGroups(preset.id).first,
      hasLength(1),
    );
  });

  test('editing preserves unchanged inactive parent references', () async {
    final category = await database.createIngredientCategory('木类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    await database.updateIngredientCategory(category.id, isInactive: true);
    await database.updateIngredient(
      ingredient.id,
      name: '沉香木',
      imageHash: ingredient.imageHash,
      alias: null,
      notes: '保留父级',
      categoryId: category.id,
    );
    await expectLater(
      database.createIngredient(name: '新香料', categoryId: category.id),
      throwsStateError,
    );

    final assetCategory = await database.createAssetCategory('工具');
    final assetStatus = await database.createAssetStatus('可用');
    final asset = await database.createAsset(
      name: '压香器',
      categoryId: assetCategory.id,
      statusId: assetStatus.id,
      quantity: 1,
    );
    await database.updateAssetCategory(
      assetCategory.id,
      name: assetCategory.name,
      isInactive: true,
    );
    await database.updateAssetStatus(
      assetStatus.id,
      name: assetStatus.name,
      isInactive: true,
    );
    await database.updateAsset(
      asset.id,
      name: asset.name,
      categoryId: asset.categoryId,
      statusId: asset.statusId,
      imageHash: asset.imageHash,
      quantity: asset.quantity,
      location: '新位置',
      notes: asset.notes,
    );
    final updatedAsset = await (database.select(
      database.assets,
    )..where((row) => row.id.equals(asset.id))).getSingle();
    expect(
      (updatedAsset.categoryId, updatedAsset.statusId, updatedAsset.location),
      (assetCategory.id, assetStatus.id, '新位置'),
    );

    final type = await database.createProductionType('香丸');
    final typePreset = await database.createRecommendationPreset(
      name: '香丸配置',
      productionTypeId: type.id,
    );
    await database.updateProductionType(
      type.id,
      name: type.name,
      isInactive: true,
    );
    await database.updateRecommendationPreset(
      typePreset.id,
      name: '香丸配置二',
      productionTypeId: type.id,
      notes: null,
    );
    expect(
      (await database.getActiveProductionTypes(includeId: type.id)).last.id,
      type.id,
    );
  });

  test(
    'expired trash entries cannot be restored through a stale handle',
    () async {
      final plaque = await database.createPlaqueType(name: '过期香牌');
      await database.deletePlaqueType(plaque.id);
      final stale = (await database.watchTrash().first).singleWhere(
        (item) => item.id == plaque.id,
      );
      await (database.update(
        database.plaqueTypes,
      )..where((row) => row.id.equals(plaque.id))).write(
        PlaqueTypesCompanion(
          deletedAtUtc: Value(
            DateTime.now().toUtc().subtract(const Duration(days: 31)),
          ),
        ),
      );

      await expectLater(database.restoreTrashEntry(stale), throwsStateError);
      expect(
        (await (database.select(
          database.plaqueTypes,
        )..where((row) => row.id.equals(plaque.id))).getSingle()).isDeleted,
        true,
      );
    },
  );

  test(
    'ordered creates log sort state and invalid media hashes are rejected',
    () async {
      final category = await database.createIngredientCategory('木类');
      await expectLater(
        database.createIngredient(
          name: '沉香',
          categoryId: category.id,
          imageHash: '../outside',
        ),
        throwsArgumentError,
      );
      await database.createPlaqueType(name: '香牌');
      await database.createAssetCategory('工具');
      await database.createAssetStatus('可用');
      await database.createRecommendationPreset(
        name: '配置',
        productionTypeId: 'type-zhuanxiang',
      );
      await database.createProductionType('香丸');

      final orderedTypes = {
        'ingredient_categories',
        'plaque_types',
        'asset_categories',
        'asset_statuses',
        'recommendation_presets',
        'production_types',
      };
      final operations = await database.select(database.syncOperations).get();
      for (final operation in operations.where(
        (item) => orderedTypes.contains(item.entityType),
      )) {
        final payload =
            jsonDecode(operation.payloadJson) as Map<String, dynamic>;
        expect(payload['sortOrder'], isA<int>());
        expect(payload['isInactive'], false);
      }
    },
  );

  test('assets can filter records without a status', () async {
    final category = await database.createAssetCategory('工具');
    await database.createAsset(
      name: '无状态',
      categoryId: category.id,
      quantity: 1,
    );
    final status = await database.createAssetStatus('可用');
    await database.createAsset(
      name: '有状态',
      categoryId: category.id,
      statusId: status.id,
      quantity: 1,
    );
    expect(
      (await database.watchAssets(withoutStatus: true).first).single.asset.name,
      '无状态',
    );
  });
}
