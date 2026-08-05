import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class ProductionTypes extends Table {
  TextColumn get id => text()();
  TextColumn get revisionId => text()();
  TextColumn get updatedByDevice => text()();
  DateTimeColumn get updatedAtUtc => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAtUtc => dateTime().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

mixin SyncColumns on Table {
  TextColumn get id => text()();
  TextColumn get revisionId => text()();
  TextColumn get updatedByDevice => text()();
  DateTimeColumn get updatedAtUtc => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAtUtc => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class IngredientCategories extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class Ingredients extends Table with SyncColumns {
  TextColumn get categoryId => text().references(IngredientCategories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get alias => text().nullable()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class IngredientSkus extends Table with SyncColumns {
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  TextColumn get skuCode => text().nullable()();
  TextColumn get imageHash => text().nullable()();
  TextColumn get supplier => text().nullable()();
  TextColumn get origin => text().nullable()();
  TextColumn get purchaseUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

abstract class RatioRangeTable extends Table with SyncColumns {
  TextColumn get productionTypeId => text().references(ProductionTypes, #id)();
  IntColumn get minRatio => integer()();
  IntColumn get maxRatio => integer()();

  @override
  List<String> get customConstraints => [
    'CHECK (min_ratio BETWEEN 0 AND 10000)',
    'CHECK (max_ratio BETWEEN 0 AND 10000)',
    'CHECK (min_ratio <= max_ratio)',
  ];
}

class CategoryRatioRanges extends RatioRangeTable {
  TextColumn get categoryId => text().references(IngredientCategories, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {categoryId, productionTypeId},
  ];
}

class IngredientRatioRanges extends RatioRangeTable {
  TextColumn get ingredientId => text().references(Ingredients, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {ingredientId, productionTypeId},
  ];
}

class SkuRatioOverrides extends RatioRangeTable {
  TextColumn get skuId => text().references(IngredientSkus, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {skuId, productionTypeId},
  ];
}

class RecommendationPresets extends Table with SyncColumns {
  TextColumn get productionTypeId => text().references(ProductionTypes, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class RecommendationGroups extends Table with SyncColumns {
  TextColumn get presetId => text().references(RecommendationPresets, #id)();
  TextColumn get categoryId => text().references(IngredientCategories, #id)();
  IntColumn get ratio => integer().customConstraint(
    'NOT NULL CHECK (ratio BETWEEN 0 AND 10000)',
  )();

  @override
  List<Set<Column>> get uniqueKeys => [
    {presetId, categoryId},
  ];
}

class RecommendationItems extends Table with SyncColumns {
  TextColumn get groupId => text().references(RecommendationGroups, #id)();
  TextColumn get skuId => text().references(IngredientSkus, #id)();
  IntColumn get ratio => integer().customConstraint(
    'NOT NULL CHECK (ratio BETWEEN 0 AND 10000)',
  )();

  @override
  List<Set<Column>> get uniqueKeys => [
    {groupId, skuId},
  ];
}

class Customers extends Table with SyncColumns {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  List<String> get customConstraints => [
    "CHECK (length(trim(name)) > 0 OR length(trim(phone)) > 0)",
  ];
}

class PlaqueTypes extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get imageHash => text().nullable()();
  TextColumn get specification => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class AssetCategories extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class AssetStatuses extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class Assets extends Table with SyncColumns {
  TextColumn get categoryId => text().references(AssetCategories, #id)();
  TextColumn get statusId => text().nullable().references(AssetStatuses, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get imageHash => text().nullable()();
  IntColumn get quantity =>
      integer().customConstraint('NOT NULL CHECK (quantity >= 0)')();
  TextColumn get location => text().nullable()();
  TextColumn get purchaseUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastCountedAtUtc => dateTime().nullable()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class LocalDevices extends Table {
  TextColumn get id => text()();
  IntColumn get deviceSeq => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncOperations extends Table {
  TextColumn get operationId => text()();
  TextColumn get originDeviceId => text()();
  IntColumn get deviceSeq => integer()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get baseRevisionId => text().nullable()();
  TextColumn get newRevisionId => text()();
  TextColumn get operationKind => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {operationId};

  @override
  List<Set<Column>> get uniqueKeys => [
    {originDeviceId, deviceSeq},
  ];
}

class IngredientSummary {
  const IngredientSummary(this.ingredient, this.categoryName);

  final Ingredient ingredient;
  final String categoryName;
}

@DriftDatabase(
  tables: [
    ProductionTypes,
    IngredientCategories,
    Ingredients,
    IngredientSkus,
    CategoryRatioRanges,
    IngredientRatioRanges,
    SkuRatioOverrides,
    RecommendationPresets,
    RecommendationGroups,
    RecommendationItems,
    Customers,
    PlaqueTypes,
    AssetCategories,
    AssetStatuses,
    Assets,
    LocalDevices,
    SyncOperations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'xiangfangbu',
          native: DriftNativeOptions(
            setup: (db) {
              db.execute('PRAGMA foreign_keys = ON');
              db.execute('PRAGMA journal_mode = WAL');
            },
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from == 1 && to == 2) {
        for (final table in <TableInfo<Table, dynamic>>[
          ingredientCategories,
          ingredients,
          ingredientSkus,
          categoryRatioRanges,
          ingredientRatioRanges,
          skuRatioOverrides,
          recommendationPresets,
          recommendationGroups,
          recommendationItems,
          customers,
          plaqueTypes,
          assetCategories,
          assetStatuses,
          assets,
        ]) {
          await m.createTable(table);
        }
      } else {
        throw StateError('缺少数据库迁移：$from → $to');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> initialize() => transaction(() async {
    var device = await select(localDevices).getSingleOrNull();
    if (device == null) {
      final now = DateTime.now().toUtc();
      device = LocalDevice(id: _newId(), deviceSeq: 0, createdAtUtc: now);
      await into(localDevices).insert(device);
    }

    for (var i = 0; i < _defaultTypes.length; i++) {
      final type = _defaultTypes[i];
      await into(productionTypes).insert(
        ProductionTypesCompanion.insert(
          id: type.$1,
          revisionId: 'system-production-type-v1-${type.$1}',
          updatedByDevice: 'system',
          updatedAtUtc: DateTime.utc(2026, 1, 1),
          name: type.$2,
          sortOrder: i,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  Future<LocalDevice> localDevice() => select(localDevices).getSingle();

  Stream<List<ProductionType>> watchProductionTypes() =>
      (select(productionTypes)
            ..where((row) => row.isDeleted.equals(false))
            ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
          .watch();

  Future<ProductionType> createProductionType(String name) async {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(name, 'name', '制作类型名称不能为空');
    }

    return transaction(() async {
      final device = await localDevice();
      final latest =
          await (select(productionTypes)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final now = DateTime.now().toUtc();
      final entityId = _newId();
      final revisionId = _newId();
      final nextSeq = device.deviceSeq + 1;
      final entity = ProductionTypesCompanion.insert(
        id: entityId,
        revisionId: revisionId,
        updatedByDevice: device.id,
        updatedAtUtc: now,
        name: normalized,
        sortOrder: (latest?.sortOrder ?? -1) + 1,
      );
      await into(productionTypes).insert(entity);
      await (update(localDevices)..where((row) => row.id.equals(device.id)))
          .write(LocalDevicesCompanion(deviceSeq: Value(nextSeq)));
      await into(syncOperations).insert(
        SyncOperationsCompanion.insert(
          operationId: _newId(),
          originDeviceId: device.id,
          deviceSeq: nextSeq,
          entityType: 'production_types',
          entityId: entityId,
          newRevisionId: revisionId,
          operationKind: 'create',
          payloadJson: jsonEncode({'id': entityId, 'name': normalized}),
          createdAtUtc: now,
        ),
      );
      return (select(
        productionTypes,
      )..where((row) => row.id.equals(entityId))).getSingle();
    });
  }

  Stream<List<IngredientCategory>> watchIngredientCategories({
    bool includeInactive = true,
    bool includeDeleted = false,
  }) {
    final query = select(ingredientCategories)
      ..where((row) {
        Expression<bool> filter = const Constant(true);
        if (!includeInactive) filter = filter & row.isInactive.equals(false);
        if (!includeDeleted) filter = filter & row.isDeleted.equals(false);
        return filter;
      })
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch();
  }

  Future<List<IngredientCategory>> getActiveIngredientCategories() =>
      (select(ingredientCategories)
            ..where(
              (row) =>
                  row.isDeleted.equals(false) & row.isInactive.equals(false),
            )
            ..orderBy([
              (row) => OrderingTerm.asc(row.sortOrder),
              (row) => OrderingTerm.asc(row.name),
            ]))
          .get();

  Future<IngredientCategory> createIngredientCategory(String name) async {
    final normalized = _requiredName(name, '香料分类名称不能为空');
    return transaction(() async {
      final latest =
          await (select(ingredientCategories)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final id = _newId();
      final change = await _recordOperation(
        entityType: 'ingredient_categories',
        entityId: id,
        operationKind: 'create',
        payload: {'id': id, 'name': normalized},
      );
      await into(ingredientCategories).insert(
        IngredientCategoriesCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          name: normalized,
          sortOrder: (latest?.sortOrder ?? -1) + 1,
        ),
      );
      return (select(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateIngredientCategory(
    String id, {
    String? name,
    bool? isInactive,
  }) async {
    if (name == null && isInactive == null) return;
    final normalized = name == null ? null : _requiredName(name, '香料分类名称不能为空');
    await transaction(() async {
      final current = await (select(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的香料分类不能修改');
      final payload = {
        'id': id,
        'name': normalized ?? current.name,
        'isInactive': isInactive ?? current.isInactive,
      };
      final change = await _recordOperation(
        entityType: 'ingredient_categories',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: payload,
      );
      await (update(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).write(
        IngredientCategoriesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          name: normalized == null ? const Value.absent() : Value(normalized),
          isInactive: isInactive == null
              ? const Value.absent()
              : Value(isInactive),
        ),
      );
    });
  }

  Future<void> deleteIngredientCategory(String id) async {
    await transaction(() async {
      final current = await (select(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final inUse =
          await (select(ingredients)..where(
                (row) =>
                    row.categoryId.equals(id) & row.isDeleted.equals(false),
              ))
              .getSingleOrNull();
      if (inUse != null) throw StateError('请先重新分类或删除该分类下的香料');
      final change = await _recordOperation(
        entityType: 'ingredient_categories',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).write(
        IngredientCategoriesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Future<void> restoreIngredientCategory(String id) async {
    await transaction(() async {
      final current = await (select(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).getSingle();
      if (!current.isDeleted) return;
      final change = await _recordOperation(
        entityType: 'ingredient_categories',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'restore',
        payload: {'id': id},
      );
      await (update(
        ingredientCategories,
      )..where((row) => row.id.equals(id))).write(
        IngredientCategoriesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(false),
          deletedAtUtc: const Value(null),
        ),
      );
    });
  }

  Stream<List<IngredientSummary>> watchIngredients({
    String search = '',
    String? categoryId,
    bool includeInactive = false,
  }) {
    final normalized = search.trim();
    final query =
        select(ingredients).join([
            innerJoin(
              ingredientCategories,
              ingredientCategories.id.equalsExp(ingredients.categoryId),
            ),
            leftOuterJoin(
              ingredientSkus,
              ingredientSkus.ingredientId.equalsExp(ingredients.id) &
                  ingredientSkus.isDeleted.equals(false),
            ),
          ])
          ..where(
            ingredients.isDeleted.equals(false) &
                ingredientCategories.isDeleted.equals(false),
          )
          ..orderBy([
            OrderingTerm.asc(ingredientCategories.sortOrder),
            OrderingTerm.asc(ingredientCategories.name),
            OrderingTerm.asc(ingredients.name),
          ]);
    if (!includeInactive) query.where(ingredients.isInactive.equals(false));
    if (categoryId != null) {
      query.where(ingredients.categoryId.equals(categoryId));
    }
    if (normalized.isNotEmpty) {
      query.where(
        ingredients.name.contains(normalized) |
            ingredients.alias.contains(normalized) |
            ingredientCategories.name.contains(normalized) |
            ingredientSkus.skuCode.contains(normalized) |
            ingredientSkus.supplier.contains(normalized),
      );
    }
    return query.watch().map((rows) {
      final result = <String, IngredientSummary>{};
      for (final row in rows) {
        final ingredient = row.readTable(ingredients);
        result.putIfAbsent(
          ingredient.id,
          () => IngredientSummary(
            ingredient,
            row.readTable(ingredientCategories).name,
          ),
        );
      }
      return result.values.toList();
    });
  }

  Future<Ingredient> createIngredient({
    required String name,
    required String categoryId,
    String? alias,
  }) async {
    final normalized = _requiredName(name, '香料名称不能为空');
    final normalizedAlias = _optionalText(alias);
    return transaction(() async {
      await _activeCategory(categoryId);
      final id = _newId();
      final payload = {
        'id': id,
        'name': normalized,
        'alias': normalizedAlias,
        'categoryId': categoryId,
      };
      final change = await _recordOperation(
        entityType: 'ingredients',
        entityId: id,
        operationKind: 'create',
        payload: payload,
      );
      await into(ingredients).insert(
        IngredientsCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          categoryId: categoryId,
          name: normalized,
          alias: Value(normalizedAlias),
        ),
      );
      return (select(
        ingredients,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateIngredient(
    String id, {
    required String name,
    required String categoryId,
    String? alias,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '香料名称不能为空');
    final normalizedAlias = _optionalText(alias);
    await transaction(() async {
      final current = await (select(
        ingredients,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的香料不能修改');
      await _activeCategory(categoryId);
      final payload = {
        'id': id,
        'name': normalized,
        'alias': normalizedAlias,
        'categoryId': categoryId,
        'isInactive': isInactive ?? current.isInactive,
      };
      final change = await _recordOperation(
        entityType: 'ingredients',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: payload,
      );
      await (update(ingredients)..where((row) => row.id.equals(id))).write(
        IngredientsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          categoryId: Value(categoryId),
          name: Value(normalized),
          alias: Value(normalizedAlias),
          isInactive: Value(isInactive ?? current.isInactive),
        ),
      );
    });
  }

  Future<void> deleteIngredient(String id) async {
    await transaction(() async {
      final current = await (select(
        ingredients,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final sku =
          await (select(ingredientSkus)..where(
                (row) =>
                    row.ingredientId.equals(id) & row.isDeleted.equals(false),
              ))
              .getSingleOrNull();
      if (sku != null) throw StateError('请先删除该香料下的 SKU');
      final change = await _recordOperation(
        entityType: 'ingredients',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(ingredients)..where((row) => row.id.equals(id))).write(
        IngredientsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Future<IngredientCategory> _activeCategory(String id) async {
    final category = await (select(
      ingredientCategories,
    )..where((row) => row.id.equals(id))).getSingle();
    if (category.isDeleted || category.isInactive) {
      throw StateError('请选择可用的香料分类');
    }
    return category;
  }

  Future<({String deviceId, String revisionId, DateTime now})>
  _recordOperation({
    required String entityType,
    required String entityId,
    required String operationKind,
    required Map<String, Object?> payload,
    String? baseRevisionId,
  }) async {
    final device = await localDevice();
    final nextSeq = device.deviceSeq + 1;
    final revisionId = _newId();
    final now = DateTime.now().toUtc();
    await (update(localDevices)..where((row) => row.id.equals(device.id)))
        .write(LocalDevicesCompanion(deviceSeq: Value(nextSeq)));
    await into(syncOperations).insert(
      SyncOperationsCompanion.insert(
        operationId: _newId(),
        originDeviceId: device.id,
        deviceSeq: nextSeq,
        entityType: entityType,
        entityId: entityId,
        baseRevisionId: Value(baseRevisionId),
        newRevisionId: revisionId,
        operationKind: operationKind,
        payloadJson: jsonEncode(payload),
        createdAtUtc: now,
      ),
    );
    return (deviceId: device.id, revisionId: revisionId, now: now);
  }
}

const _defaultTypes = [
  ('type-zhuanxiang', '篆香'),
  ('type-xianxiang', '线香'),
  ('type-hexiangzhu', '合香珠'),
  ('type-xiangpai', '香牌'),
];

String _newId() {
  final random = Random.secure();
  return List<int>.generate(
    16,
    (_) => random.nextInt(256),
  ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

String _requiredName(String value, String message) {
  final normalized = value.trim();
  if (normalized.isEmpty) throw ArgumentError.value(value, 'name', message);
  return normalized;
}

String? _optionalText(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
