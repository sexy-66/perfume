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

    await database.restoreIngredientCategory(category.id);
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
}
