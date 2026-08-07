import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../services/formula_calculator.dart';

part 'app_database.g.dart';
part 'm3_database.dart';

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
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastCountedAtUtc => dateTime().nullable()();
  BoolColumn get isInactive => boolean().withDefault(const Constant(false))();
}

class Formulas extends Table with SyncColumns {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get notes => text().nullable()();
  TextColumn get currentVersionId => text().nullable()();
  DateTimeColumn get lastUsedAtUtc => dateTime().nullable()();
}

class FormulaDrafts extends Table with SyncColumns {
  TextColumn get kind => text()();
  TextColumn get formulaId => text().nullable().references(Formulas, #id)();
  TextColumn get sourceVersionId => text().nullable()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get plaqueTypeId =>
      text().nullable().references(PlaqueTypes, #id)();
  TextColumn get formulaName => text().withDefault(const Constant(''))();
  TextColumn get productionTypeId => text().references(ProductionTypes, #id)();
  IntColumn get targetWeight => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get itemsJson => text()();
  TextColumn get actualWeightsJson => text()();
  TextColumn get confirmedWarningsJson =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  List<String> get customConstraints => ['CHECK (target_weight > 0)'];
}

class FormulaVersions extends Table with SyncColumns {
  TextColumn get formulaId => text().references(Formulas, #id)();
  IntColumn get versionNumber => integer()();
  TextColumn get sourceVersionId => text().nullable()();
  TextColumn get productionTypeId => text().references(ProductionTypes, #id)();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {formulaId, versionNumber},
  ];
}

class FormulaItems extends Table with SyncColumns {
  TextColumn get versionId => text().references(FormulaVersions, #id)();
  TextColumn get categoryName => text()();
  TextColumn get ingredientName => text()();
  TextColumn get skuCode => text().nullable()();
  TextColumn get skuId => text().nullable()();
  IntColumn get ratio => integer()();
  IntColumn get sortOrder => integer()();

  @override
  List<String> get customConstraints => ['CHECK (ratio BETWEEN 0 AND 10000)'];
}

class MixingSessions extends Table with SyncColumns {
  TextColumn get formulaId => text().nullable().references(Formulas, #id)();
  TextColumn get versionId =>
      text().nullable().references(FormulaVersions, #id)();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get plaqueTypeId =>
      text().nullable().references(PlaqueTypes, #id)();
  TextColumn get formulaName => text()();
  TextColumn get productionTypeName => text()();
  IntColumn get targetWeight => integer()();
  IntColumn get finalWeight => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get completedAtUtc => dateTime()();
}

class MixingItems extends Table with SyncColumns {
  TextColumn get sessionId => text().references(MixingSessions, #id)();
  TextColumn get categoryName => text()();
  TextColumn get ingredientName => text()();
  TextColumn get skuCode => text().nullable()();
  TextColumn get skuId => text().nullable()();
  IntColumn get plannedWeight => integer()();
  IntColumn get finalWeight => integer()();
  BoolColumn get isManual => boolean()();
  IntColumn get finalRatio => integer()();
  IntColumn get sortOrder => integer()();
}

class MixingRevisions extends Table with SyncColumns {
  TextColumn get sessionId => text().references(MixingSessions, #id)();
  TextColumn get previousDataJson => text()();
  DateTimeColumn get modifiedAtUtc => dateTime()();
  TextColumn get modifiedByDevice => text()();
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
  const IngredientSummary(
    this.ingredient,
    this.categoryName,
    this.firstSkuImageHash,
  );

  final Ingredient ingredient;
  final String categoryName;
  final String? firstSkuImageHash;
}

enum RatioRangeTarget { category, ingredient, sku }

class RatioRangeSetting {
  const RatioRangeSetting({
    required this.productionTypeId,
    required this.productionTypeName,
    required this.productionTypeInactive,
    this.rangeId,
    this.minRatio,
    this.maxRatio,
  });

  final String productionTypeId;
  final String productionTypeName;
  final bool productionTypeInactive;
  final String? rangeId;
  final int? minRatio;
  final int? maxRatio;
}

class RecommendationPresetSummary {
  const RecommendationPresetSummary(this.preset, this.productionTypeName);

  final RecommendationPreset preset;
  final String productionTypeName;
}

class RecommendationGroupSummary {
  const RecommendationGroupSummary({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.ratio,
    required this.itemTotal,
  });

  final String id;
  final String categoryId;
  final String categoryName;
  final int ratio;
  final int itemTotal;
}

class RecommendationItemSummary {
  const RecommendationItemSummary({
    required this.id,
    required this.skuId,
    required this.ingredientName,
    required this.skuCode,
    required this.ratio,
  });

  final String id;
  final String skuId;
  final String ingredientName;
  final String? skuCode;
  final int ratio;
}

class SkuChoice {
  const SkuChoice(this.id, this.label);

  final String id;
  final String label;
}

class AssetSummary {
  const AssetSummary(this.asset, this.categoryName, this.statusName);

  final Asset asset;
  final String categoryName;
  final String? statusName;
}

enum TrashEntityType {
  productionType('production_types', '制作类型'),
  ingredientCategory('ingredient_categories', '香料分类'),
  ingredient('ingredients', '香料'),
  ingredientSku('ingredient_skus', 'SKU'),
  recommendationPreset('recommendation_presets', '推荐配置'),
  formula('formulas', '香方'),
  customer('customers', '顾客'),
  plaqueType('plaque_types', '香牌'),
  assetCategory('asset_categories', '资产分类'),
  assetStatus('asset_statuses', '资产状态'),
  asset('assets', '资产');

  const TrashEntityType(this.tableName, this.label);

  final String tableName;
  final String label;
}

class TrashEntry {
  const TrashEntry({
    required this.type,
    required this.id,
    required this.name,
    required this.deletedAtUtc,
  });

  final TrashEntityType type;
  final String id;
  final String name;
  final DateTime deletedAtUtc;
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
    Formulas,
    FormulaDrafts,
    FormulaVersions,
    FormulaItems,
    MixingSessions,
    MixingItems,
    MixingRevisions,
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from == 1) {
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
      }
      if (from <= 2) {
        for (final table in <TableInfo<Table, dynamic>>[
          formulas,
          formulaDrafts,
          formulaVersions,
          formulaItems,
          mixingSessions,
          mixingItems,
          mixingRevisions,
        ]) {
          await m.createTable(table);
        }
      }
      if (from < 1 || to != 3) {
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
      final sortOrder = (latest?.sortOrder ?? -1) + 1;
      final entity = ProductionTypesCompanion.insert(
        id: entityId,
        revisionId: revisionId,
        updatedByDevice: device.id,
        updatedAtUtc: now,
        name: normalized,
        sortOrder: sortOrder,
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
          payloadJson: jsonEncode({
            'id': entityId,
            'name': normalized,
            'sortOrder': sortOrder,
            'isInactive': false,
          }),
          createdAtUtc: now,
        ),
      );
      return (select(
        productionTypes,
      )..where((row) => row.id.equals(entityId))).getSingle();
    });
  }

  Future<void> updateProductionType(
    String id, {
    required String name,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '制作类型名称不能为空');
    await transaction(() async {
      final current = await (select(
        productionTypes,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的制作类型不能修改');
      final change = await _recordOperation(
        entityType: 'production_types',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {
          'id': id,
          'name': normalized,
          'isInactive': isInactive ?? current.isInactive,
          'sortOrder': current.sortOrder,
        },
      );
      await (update(productionTypes)..where((row) => row.id.equals(id))).write(
        ProductionTypesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          name: Value(normalized),
          isInactive: Value(isInactive ?? current.isInactive),
        ),
      );
    });
  }

  Future<void> moveProductionType(String id, int offset) async {
    if (offset != -1 && offset != 1) {
      throw ArgumentError.value(offset, 'offset');
    }
    await transaction(() async {
      final items =
          await (select(productionTypes)
                ..where((row) => row.isDeleted.equals(false))
                ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
              .get();
      final index = items.indexWhere((item) => item.id == id);
      final targetIndex = index + offset;
      if (index < 0 || targetIndex < 0 || targetIndex >= items.length) return;
      final current = items[index];
      final target = items[targetIndex];
      await _setProductionTypeSort(current, target.sortOrder);
      await _setProductionTypeSort(target, current.sortOrder);
    });
  }

  Future<void> _setProductionTypeSort(
    ProductionType current,
    int sortOrder,
  ) async {
    final change = await _recordOperation(
      entityType: 'production_types',
      entityId: current.id,
      baseRevisionId: current.revisionId,
      operationKind: 'update',
      payload: {
        'id': current.id,
        'name': current.name,
        'isInactive': current.isInactive,
        'sortOrder': sortOrder,
      },
    );
    await (update(
      productionTypes,
    )..where((row) => row.id.equals(current.id))).write(
      ProductionTypesCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        sortOrder: Value(sortOrder),
      ),
    );
  }

  Future<void> moveIngredientCategory(String id, int offset) =>
      _moveSortedEntity(
        tableName: 'ingredient_categories',
        table: ingredientCategories,
        id: id,
        offset: offset,
      );

  Future<void> movePlaqueType(String id, int offset) => _moveSortedEntity(
    tableName: 'plaque_types',
    table: plaqueTypes,
    id: id,
    offset: offset,
  );

  Future<void> moveRecommendationPreset(String id, int offset) =>
      _moveSortedEntity(
        tableName: 'recommendation_presets',
        table: recommendationPresets,
        id: id,
        offset: offset,
      );

  Future<void> moveAssetCategory(String id, int offset) => _moveSortedEntity(
    tableName: 'asset_categories',
    table: assetCategories,
    id: id,
    offset: offset,
  );

  Future<void> moveAssetStatus(String id, int offset) => _moveSortedEntity(
    tableName: 'asset_statuses',
    table: assetStatuses,
    id: id,
    offset: offset,
  );

  Future<void> _moveSortedEntity({
    required String tableName,
    required ResultSetImplementation table,
    required String id,
    required int offset,
  }) async {
    if (offset != -1 && offset != 1) {
      throw ArgumentError.value(offset, 'offset');
    }
    await transaction(() async {
      final items = await customSelect(
        '''SELECT id, revision_id, sort_order FROM $tableName
            WHERE is_deleted = 0 ORDER BY sort_order, id''',
        readsFrom: {table},
      ).get();
      final index = items.indexWhere((row) => row.read<String>('id') == id);
      final targetIndex = index + offset;
      if (index < 0 || targetIndex < 0 || targetIndex >= items.length) return;
      final current = items[index];
      final target = items[targetIndex];
      for (final swap in [
        (current, target.read<int>('sort_order')),
        (target, current.read<int>('sort_order')),
      ]) {
        final entityId = swap.$1.read<String>('id');
        final change = await _recordOperation(
          entityType: tableName,
          entityId: entityId,
          baseRevisionId: swap.$1.read('revision_id'),
          operationKind: 'update',
          payload: {'id': entityId, 'sortOrder': swap.$2},
        );
        await customUpdate(
          '''UPDATE $tableName
                SET revision_id = ?, updated_by_device = ?, updated_at_utc = ?,
                    sort_order = ? WHERE id = ?''',
          variables: [
            Variable(change.revisionId),
            Variable(change.deviceId),
            Variable(change.now),
            Variable(swap.$2),
            Variable(entityId),
          ],
          updates: {table},
        );
      }
    });
  }

  Future<void> deleteProductionType(String id) async {
    await transaction(() async {
      final current = await (select(
        productionTypes,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      if (isBuiltInProductionType(id)) {
        throw StateError('内置制作类型不能删除');
      }
      final inUse = await customSelect(
        '''SELECT 1
             WHERE EXISTS (SELECT 1 FROM category_ratio_ranges WHERE production_type_id = ? AND is_deleted = 0)
                OR EXISTS (SELECT 1 FROM ingredient_ratio_ranges WHERE production_type_id = ? AND is_deleted = 0)
                OR EXISTS (SELECT 1 FROM sku_ratio_overrides WHERE production_type_id = ? AND is_deleted = 0)
                OR EXISTS (SELECT 1 FROM recommendation_presets WHERE production_type_id = ? AND is_deleted = 0)''',
        variables: List.generate(4, (_) => Variable(id)),
      ).getSingleOrNull();
      if (inUse != null) throw StateError('请先删除该制作类型下的推荐区间和推荐配置');
      final change = await _recordOperation(
        entityType: 'production_types',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(productionTypes)..where((row) => row.id.equals(id))).write(
        ProductionTypesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  bool isBuiltInProductionType(String id) =>
      _defaultTypes.any((item) => item.$1 == id);

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

  Future<List<IngredientCategory>> getActiveIngredientCategories({
    String? includeId,
  }) {
    final query = select(ingredientCategories)
      ..where(
        (row) =>
            row.isDeleted.equals(false) &
            (row.isInactive.equals(false) |
                (includeId == null
                    ? const Constant(false)
                    : row.id.equals(includeId))),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.get();
  }

  Future<IngredientCategory> createIngredientCategory(String name) async {
    final normalized = _requiredName(name, '香料分类名称不能为空');
    return transaction(() async {
      final latest =
          await (select(ingredientCategories)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final id = _newId();
      final sortOrder = (latest?.sortOrder ?? -1) + 1;
      final change = await _recordOperation(
        entityType: 'ingredient_categories',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'name': normalized,
          'sortOrder': sortOrder,
          'isInactive': false,
        },
      );
      await into(ingredientCategories).insert(
        IngredientCategoriesCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          name: normalized,
          sortOrder: sortOrder,
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
      final inUse = await customSelect(
        '''SELECT 1
             WHERE EXISTS (SELECT 1 FROM ingredients
                            WHERE category_id = ? AND is_deleted = 0)
                OR EXISTS (SELECT 1 FROM category_ratio_ranges
                            WHERE category_id = ? AND is_deleted = 0)
                OR EXISTS (
                  SELECT 1 FROM recommendation_groups rg
                  JOIN recommendation_presets rp ON rp.id = rg.preset_id
                   WHERE rg.category_id = ?
                     AND rg.is_deleted = 0 AND rp.is_deleted = 0
                )''',
        variables: List.generate(3, (_) => Variable(id)),
      ).getSingleOrNull();
      if (inUse != null) {
        throw StateError('请先移除该分类下的香料、推荐区间和推荐配置');
      }
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
            OrderingTerm.asc(ingredientSkus.skuCode),
            OrderingTerm.asc(ingredientSkus.supplier),
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
            row.readTableOrNull(ingredientSkus)?.imageHash,
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
    required String? alias,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '香料名称不能为空');
    final normalizedAlias = _optionalText(alias);
    await transaction(() async {
      final current = await (select(
        ingredients,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的香料不能修改');
      await _activeCategory(
        categoryId,
        allowInactive: categoryId == current.categoryId,
      );
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
      final range =
          await (select(ingredientRatioRanges)..where(
                (row) =>
                    row.ingredientId.equals(id) & row.isDeleted.equals(false),
              ))
              .getSingleOrNull();
      if (range != null) throw StateError('请先清除该香料的推荐区间');
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

  Stream<List<IngredientSkusData>> watchIngredientSkus(
    String ingredientId, {
    bool includeInactive = true,
  }) {
    final query = select(ingredientSkus)
      ..where((row) {
        var filter =
            row.ingredientId.equals(ingredientId) & row.isDeleted.equals(false);
        if (!includeInactive) filter = filter & row.isInactive.equals(false);
        return filter;
      })
      ..orderBy([
        (row) => OrderingTerm.asc(row.skuCode),
        (row) => OrderingTerm.asc(row.supplier),
      ]);
    return query.watch();
  }

  Future<IngredientSkusData> createIngredientSku({
    required String ingredientId,
    String? skuCode,
    String? imageHash,
    String? supplier,
    String? origin,
    String? notes,
  }) async {
    return transaction(() async {
      await _activeIngredient(ingredientId);
      final id = _newId();
      final normalizedSkuCode = _optionalText(skuCode);
      final normalizedImageHash = _optionalImageHash(imageHash);
      final normalizedSupplier = _optionalText(supplier);
      final normalizedOrigin = _optionalText(origin);
      final normalizedNotes = _optionalText(notes);
      final payload = {
        'id': id,
        'ingredientId': ingredientId,
        'skuCode': normalizedSkuCode,
        'imageHash': normalizedImageHash,
        'supplier': normalizedSupplier,
        'origin': normalizedOrigin,
        'notes': normalizedNotes,
      };
      final change = await _recordOperation(
        entityType: 'ingredient_skus',
        entityId: id,
        operationKind: 'create',
        payload: payload,
      );
      await into(ingredientSkus).insert(
        IngredientSkusCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          ingredientId: ingredientId,
          skuCode: Value(normalizedSkuCode),
          imageHash: Value(normalizedImageHash),
          supplier: Value(normalizedSupplier),
          origin: Value(normalizedOrigin),
          notes: Value(normalizedNotes),
        ),
      );
      return (select(
        ingredientSkus,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateIngredientSku(
    String id, {
    required String? skuCode,
    required String? imageHash,
    required String? supplier,
    required String? origin,
    required String? notes,
    bool? isInactive,
  }) async {
    await transaction(() async {
      final current = await (select(
        ingredientSkus,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的 SKU 不能修改');
      await _activeIngredient(current.ingredientId, allowInactive: true);
      final normalizedSkuCode = _optionalText(skuCode);
      final normalizedImageHash = _optionalImageHash(imageHash);
      final normalizedSupplier = _optionalText(supplier);
      final normalizedOrigin = _optionalText(origin);
      final normalizedNotes = _optionalText(notes);
      final inactive = isInactive ?? current.isInactive;
      final payload = {
        'id': id,
        'ingredientId': current.ingredientId,
        'skuCode': normalizedSkuCode,
        'imageHash': normalizedImageHash,
        'supplier': normalizedSupplier,
        'origin': normalizedOrigin,
        'notes': normalizedNotes,
        'isInactive': inactive,
      };
      final change = await _recordOperation(
        entityType: 'ingredient_skus',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: payload,
      );
      await (update(ingredientSkus)..where((row) => row.id.equals(id))).write(
        IngredientSkusCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          skuCode: Value(normalizedSkuCode),
          imageHash: Value(normalizedImageHash),
          supplier: Value(normalizedSupplier),
          origin: Value(normalizedOrigin),
          notes: Value(normalizedNotes),
          isInactive: Value(inactive),
        ),
      );
    });
  }

  Future<void> deleteIngredientSku(String id) async {
    await transaction(() async {
      final current = await (select(
        ingredientSkus,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final inUse = await customSelect(
        '''SELECT 1
             WHERE EXISTS (SELECT 1 FROM sku_ratio_overrides
                            WHERE sku_id = ? AND is_deleted = 0)
                OR EXISTS (
                  SELECT 1 FROM recommendation_items ri
                  JOIN recommendation_groups rg ON rg.id = ri.group_id
                  JOIN recommendation_presets rp ON rp.id = rg.preset_id
                   WHERE ri.sku_id = ? AND ri.is_deleted = 0
                     AND rg.is_deleted = 0 AND rp.is_deleted = 0
                )''',
        variables: [Variable(id), Variable(id)],
      ).getSingleOrNull();
      if (inUse != null) {
        throw StateError('请先清除该 SKU 的推荐区间和推荐配置');
      }
      final change = await _recordOperation(
        entityType: 'ingredient_skus',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(ingredientSkus)..where((row) => row.id.equals(id))).write(
        IngredientSkusCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Stream<List<PlaqueType>> watchPlaqueTypes({
    String search = '',
    bool includeInactive = false,
  }) {
    final normalized = search.trim();
    final query = select(plaqueTypes)
      ..where((row) {
        var filter = row.isDeleted.equals(false);
        if (!includeInactive) filter = filter & row.isInactive.equals(false);
        if (normalized.isNotEmpty) {
          filter =
              filter &
              (row.name.contains(normalized) |
                  row.specification.contains(normalized) |
                  row.notes.contains(normalized));
        }
        return filter;
      })
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch();
  }

  Future<PlaqueType> createPlaqueType({
    required String name,
    String? imageHash,
    String? specification,
    String? notes,
  }) async {
    final normalized = _requiredName(name, '香牌名称不能为空');
    return transaction(() async {
      final latest =
          await (select(plaqueTypes)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final id = _newId();
      final sortOrder = (latest?.sortOrder ?? -1) + 1;
      final payload = {
        'id': id,
        'name': normalized,
        'imageHash': _optionalImageHash(imageHash),
        'specification': _optionalText(specification),
        'notes': _optionalText(notes),
        'sortOrder': sortOrder,
        'isInactive': false,
      };
      final change = await _recordOperation(
        entityType: 'plaque_types',
        entityId: id,
        operationKind: 'create',
        payload: payload,
      );
      await into(plaqueTypes).insert(
        PlaqueTypesCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          name: normalized,
          imageHash: Value(payload['imageHash'] as String?),
          specification: Value(payload['specification'] as String?),
          notes: Value(payload['notes'] as String?),
          sortOrder: sortOrder,
        ),
      );
      return (select(
        plaqueTypes,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updatePlaqueType(
    String id, {
    required String name,
    required String? imageHash,
    required String? specification,
    required String? notes,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '香牌名称不能为空');
    await transaction(() async {
      final current = await (select(
        plaqueTypes,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的香牌不能修改');
      final payload = {
        'id': id,
        'name': normalized,
        'imageHash': _optionalImageHash(imageHash),
        'specification': _optionalText(specification),
        'notes': _optionalText(notes),
        'isInactive': isInactive ?? current.isInactive,
      };
      final change = await _recordOperation(
        entityType: 'plaque_types',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: payload,
      );
      await (update(plaqueTypes)..where((row) => row.id.equals(id))).write(
        PlaqueTypesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          name: Value(normalized),
          imageHash: Value(payload['imageHash'] as String?),
          specification: Value(payload['specification'] as String?),
          notes: Value(payload['notes'] as String?),
          isInactive: Value(payload['isInactive'] as bool),
        ),
      );
    });
  }

  Future<void> deletePlaqueType(String id) async {
    await transaction(() async {
      final current = await (select(
        plaqueTypes,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final change = await _recordOperation(
        entityType: 'plaque_types',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(plaqueTypes)..where((row) => row.id.equals(id))).write(
        PlaqueTypesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Stream<List<Customer>> watchCustomers({String search = ''}) {
    final normalized = search.trim();
    final query = select(customers)
      ..where((row) {
        var filter = row.isDeleted.equals(false);
        if (normalized.isNotEmpty) {
          filter =
              filter &
              (row.name.contains(normalized) | row.phone.contains(normalized));
        }
        return filter;
      })
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAtUtc)]);
    return query.watch();
  }

  Future<Customer> createCustomer({
    String? name,
    String? phone,
    String? notes,
  }) async {
    final identity = _customerIdentity(name, phone);
    final normalizedNotes = _optionalText(notes);
    return transaction(() async {
      final id = _newId();
      final change = await _recordOperation(
        entityType: 'customers',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'name': identity.$1,
          'phone': identity.$2,
          'notes': normalizedNotes,
        },
      );
      await into(customers).insert(
        CustomersCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          name: Value(identity.$1),
          phone: Value(identity.$2),
          notes: Value(normalizedNotes),
          createdAtUtc: change.now,
        ),
      );
      return (select(customers)..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateCustomer(
    String id, {
    required String? name,
    required String? phone,
    required String? notes,
  }) async {
    final identity = _customerIdentity(name, phone);
    final normalizedNotes = _optionalText(notes);
    await transaction(() async {
      final current = await (select(
        customers,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的顾客不能修改');
      final change = await _recordOperation(
        entityType: 'customers',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {
          'id': id,
          'name': identity.$1,
          'phone': identity.$2,
          'notes': normalizedNotes,
        },
      );
      await (update(customers)..where((row) => row.id.equals(id))).write(
        CustomersCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          name: Value(identity.$1),
          phone: Value(identity.$2),
          notes: Value(normalizedNotes),
        ),
      );
    });
  }

  Future<void> deleteCustomer(String id, {bool deleteSessions = false}) async {
    await transaction(() async {
      final current = await (select(
        customers,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final sessions =
          await (select(mixingSessions)..where(
                (row) =>
                    row.customerId.equals(id) & row.isDeleted.equals(false),
              ))
              .get();
      for (final session in sessions) {
        final sessionChange = await _recordOperation(
          entityType: 'mixing_sessions',
          entityId: session.id,
          baseRevisionId: session.revisionId,
          operationKind: deleteSessions ? 'delete' : 'update',
          payload: {'id': session.id, if (!deleteSessions) 'customerId': null},
        );
        await (update(
          mixingSessions,
        )..where((row) => row.id.equals(session.id))).write(
          MixingSessionsCompanion(
            revisionId: Value(sessionChange.revisionId),
            updatedByDevice: Value(sessionChange.deviceId),
            updatedAtUtc: Value(sessionChange.now),
            customerId: deleteSessions
                ? Value(session.customerId)
                : const Value(null),
            isDeleted: Value(deleteSessions),
            deletedAtUtc: Value(deleteSessions ? sessionChange.now : null),
          ),
        );
      }
      final change = await _recordOperation(
        entityType: 'customers',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(customers)..where((row) => row.id.equals(id))).write(
        CustomersCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Stream<List<AssetCategory>> watchAssetCategories({
    bool includeInactive = true,
  }) {
    final query = select(assetCategories)
      ..where((row) {
        var filter = row.isDeleted.equals(false);
        if (!includeInactive) filter = filter & row.isInactive.equals(false);
        return filter;
      })
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch();
  }

  Stream<List<AssetStatuse>> watchAssetStatuses({bool includeInactive = true}) {
    final query = select(assetStatuses)
      ..where((row) {
        var filter = row.isDeleted.equals(false);
        if (!includeInactive) filter = filter & row.isInactive.equals(false);
        return filter;
      })
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch();
  }

  Future<AssetCategory> createAssetCategory(String name) async {
    final normalized = _requiredName(name, '资产分类名称不能为空');
    return transaction(() async {
      final latest =
          await (select(assetCategories)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final id = _newId();
      final sortOrder = (latest?.sortOrder ?? -1) + 1;
      final change = await _recordOperation(
        entityType: 'asset_categories',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'name': normalized,
          'sortOrder': sortOrder,
          'isInactive': false,
        },
      );
      await into(assetCategories).insert(
        AssetCategoriesCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          name: normalized,
          sortOrder: sortOrder,
        ),
      );
      return (select(
        assetCategories,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<AssetStatuse> createAssetStatus(String name) async {
    final normalized = _requiredName(name, '资产状态名称不能为空');
    return transaction(() async {
      final latest =
          await (select(assetStatuses)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final id = _newId();
      final sortOrder = (latest?.sortOrder ?? -1) + 1;
      final change = await _recordOperation(
        entityType: 'asset_statuses',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'name': normalized,
          'sortOrder': sortOrder,
          'isInactive': false,
        },
      );
      await into(assetStatuses).insert(
        AssetStatusesCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          name: normalized,
          sortOrder: sortOrder,
        ),
      );
      return (select(
        assetStatuses,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateAssetCategory(
    String id, {
    required String name,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '资产分类名称不能为空');
    await transaction(() async {
      final current = await (select(
        assetCategories,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的资产分类不能修改');
      final change = await _recordOperation(
        entityType: 'asset_categories',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {
          'id': id,
          'name': normalized,
          'isInactive': isInactive ?? current.isInactive,
        },
      );
      await (update(assetCategories)..where((row) => row.id.equals(id))).write(
        AssetCategoriesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          name: Value(normalized),
          isInactive: Value(isInactive ?? current.isInactive),
        ),
      );
    });
  }

  Future<void> updateAssetStatus(
    String id, {
    required String name,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '资产状态名称不能为空');
    await transaction(() async {
      final current = await (select(
        assetStatuses,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的资产状态不能修改');
      final change = await _recordOperation(
        entityType: 'asset_statuses',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {
          'id': id,
          'name': normalized,
          'isInactive': isInactive ?? current.isInactive,
        },
      );
      await (update(assetStatuses)..where((row) => row.id.equals(id))).write(
        AssetStatusesCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          name: Value(normalized),
          isInactive: Value(isInactive ?? current.isInactive),
        ),
      );
    });
  }

  Future<void> deleteAssetCategory(String id) async {
    await transaction(() async {
      final current = await (select(
        assetCategories,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final inUse =
          await (select(assets)..where(
                (row) =>
                    row.categoryId.equals(id) & row.isDeleted.equals(false),
              ))
              .getSingleOrNull();
      if (inUse != null) throw StateError('请先重新分类或删除该分类下的资产');
      await _deleteAssetOption(
        entityType: 'asset_categories',
        id: id,
        revisionId: current.revisionId,
        write: (change) =>
            (update(assetCategories)..where((row) => row.id.equals(id))).write(
              AssetCategoriesCompanion(
                revisionId: Value(change.revisionId),
                updatedByDevice: Value(change.deviceId),
                updatedAtUtc: Value(change.now),
                isDeleted: const Value(true),
                deletedAtUtc: Value(change.now),
              ),
            ),
      );
    });
  }

  Future<void> deleteAssetStatus(String id) async {
    await transaction(() async {
      final current = await (select(
        assetStatuses,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final inUse =
          await (select(assets)..where(
                (row) => row.statusId.equals(id) & row.isDeleted.equals(false),
              ))
              .getSingleOrNull();
      if (inUse != null) throw StateError('请先清除该状态下资产的状态');
      await _deleteAssetOption(
        entityType: 'asset_statuses',
        id: id,
        revisionId: current.revisionId,
        write: (change) =>
            (update(assetStatuses)..where((row) => row.id.equals(id))).write(
              AssetStatusesCompanion(
                revisionId: Value(change.revisionId),
                updatedByDevice: Value(change.deviceId),
                updatedAtUtc: Value(change.now),
                isDeleted: const Value(true),
                deletedAtUtc: Value(change.now),
              ),
            ),
      );
    });
  }

  Future<void> _deleteAssetOption({
    required String entityType,
    required String id,
    required String revisionId,
    required Future<int> Function(
      ({String deviceId, String revisionId, DateTime now}) change,
    )
    write,
  }) async {
    final change = await _recordOperation(
      entityType: entityType,
      entityId: id,
      baseRevisionId: revisionId,
      operationKind: 'delete',
      payload: {'id': id},
    );
    await write(change);
  }

  Future<List<AssetCategory>> getActiveAssetCategories({String? includeId}) {
    final query = select(assetCategories)
      ..where(
        (row) =>
            row.isDeleted.equals(false) &
            (row.isInactive.equals(false) |
                (includeId == null
                    ? const Constant(false)
                    : row.id.equals(includeId))),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.get();
  }

  Future<List<AssetStatuse>> getActiveAssetStatuses({String? includeId}) {
    final query = select(assetStatuses)
      ..where(
        (row) =>
            row.isDeleted.equals(false) &
            (row.isInactive.equals(false) |
                (includeId == null
                    ? const Constant(false)
                    : row.id.equals(includeId))),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.get();
  }

  Stream<List<AssetSummary>> watchAssets({
    String search = '',
    String? categoryId,
    String? statusId,
    bool withoutStatus = false,
    bool includeInactive = false,
  }) {
    final normalized = search.trim();
    final query =
        select(assets).join([
            innerJoin(
              assetCategories,
              assetCategories.id.equalsExp(assets.categoryId),
            ),
            leftOuterJoin(
              assetStatuses,
              assetStatuses.id.equalsExp(assets.statusId),
            ),
          ])
          ..where(
            assets.isDeleted.equals(false) &
                assetCategories.isDeleted.equals(false),
          )
          ..orderBy([
            OrderingTerm.asc(assetCategories.sortOrder),
            OrderingTerm.asc(assetCategories.name),
            OrderingTerm.asc(assets.name),
          ]);
    if (!includeInactive) query.where(assets.isInactive.equals(false));
    if (categoryId != null) query.where(assets.categoryId.equals(categoryId));
    if (withoutStatus) {
      query.where(assets.statusId.isNull());
    } else if (statusId != null) {
      query.where(assets.statusId.equals(statusId));
    }
    if (normalized.isNotEmpty) {
      query.where(
        assets.name.contains(normalized) |
            assets.location.contains(normalized) |
            assetCategories.name.contains(normalized) |
            assetStatuses.name.contains(normalized),
      );
    }
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          AssetSummary(
            row.readTable(assets),
            row.readTable(assetCategories).name,
            row.readTableOrNull(assetStatuses)?.name,
          ),
      ],
    );
  }

  Future<Asset> createAsset({
    required String name,
    required String categoryId,
    required int quantity,
    String? statusId,
    String? imageHash,
    String? location,
    String? notes,
  }) async {
    final normalized = _requiredName(name, '资产名称不能为空');
    _validateQuantity(quantity);
    return transaction(() async {
      await _activeAssetCategory(categoryId);
      if (statusId != null) await _activeAssetStatus(statusId);
      final id = _newId();
      final change = await _recordOperation(
        entityType: 'assets',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'name': normalized,
          'categoryId': categoryId,
          'statusId': statusId,
          'quantity': quantity,
          'imageHash': _optionalImageHash(imageHash),
          'location': _optionalText(location),
          'notes': _optionalText(notes),
        },
      );
      await into(assets).insert(
        AssetsCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          categoryId: categoryId,
          statusId: Value(statusId),
          name: normalized,
          imageHash: Value(_optionalImageHash(imageHash)),
          quantity: quantity,
          location: Value(_optionalText(location)),
          notes: Value(_optionalText(notes)),
        ),
      );
      return (select(assets)..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateAsset(
    String id, {
    required String name,
    required String categoryId,
    required int quantity,
    required String? statusId,
    required String? imageHash,
    required String? location,
    required String? notes,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '资产名称不能为空');
    _validateQuantity(quantity);
    await transaction(() async {
      final current = await (select(
        assets,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的资产不能修改');
      await _activeAssetCategory(
        categoryId,
        allowInactive: categoryId == current.categoryId,
      );
      if (statusId != null) {
        await _activeAssetStatus(
          statusId,
          allowInactive: statusId == current.statusId,
        );
      }
      final change = await _recordOperation(
        entityType: 'assets',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {
          'id': id,
          'name': normalized,
          'categoryId': categoryId,
          'statusId': statusId,
          'quantity': quantity,
          'imageHash': _optionalImageHash(imageHash),
          'location': _optionalText(location),
          'notes': _optionalText(notes),
          'isInactive': isInactive ?? current.isInactive,
        },
      );
      await (update(assets)..where((row) => row.id.equals(id))).write(
        AssetsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          categoryId: Value(categoryId),
          statusId: Value(statusId),
          name: Value(normalized),
          imageHash: Value(_optionalImageHash(imageHash)),
          quantity: Value(quantity),
          location: Value(_optionalText(location)),
          notes: Value(_optionalText(notes)),
          isInactive: Value(isInactive ?? current.isInactive),
        ),
      );
    });
  }

  Future<void> countAsset(String id, int quantity) async {
    _validateQuantity(quantity);
    await transaction(() async {
      final current = await (select(
        assets,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的资产不能清点');
      final change = await _recordOperation(
        entityType: 'assets',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'count',
        payload: {'id': id, 'quantity': quantity},
      );
      await (update(assets)..where((row) => row.id.equals(id))).write(
        AssetsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          quantity: Value(quantity),
          lastCountedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Future<void> deleteAsset(String id) async {
    await transaction(() async {
      final current = await (select(
        assets,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final change = await _recordOperation(
        entityType: 'assets',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(assets)..where((row) => row.id.equals(id))).write(
        AssetsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Future<AssetCategory> _activeAssetCategory(
    String id, {
    bool allowInactive = false,
  }) async {
    final item = await (select(
      assetCategories,
    )..where((row) => row.id.equals(id))).getSingle();
    if (item.isDeleted || (!allowInactive && item.isInactive)) {
      throw StateError('请选择可用的资产分类');
    }
    return item;
  }

  Future<AssetStatuse> _activeAssetStatus(
    String id, {
    bool allowInactive = false,
  }) async {
    final item = await (select(
      assetStatuses,
    )..where((row) => row.id.equals(id))).getSingle();
    if (item.isDeleted || (!allowInactive && item.isInactive)) {
      throw StateError('请选择可用的资产状态');
    }
    return item;
  }

  void _validateQuantity(int quantity) {
    if (quantity < 0) {
      throw ArgumentError.value(quantity, 'quantity', '数量不能小于 0');
    }
  }

  Stream<List<TrashEntry>> watchTrash() {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 30));
    return customSelect(
      '''
      SELECT 'ingredient_categories' AS entity_type, id, name, deleted_at_utc
        FROM ingredient_categories WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'production_types', id, name, deleted_at_utc
        FROM production_types WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'ingredients', id, name, deleted_at_utc
        FROM ingredients WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'ingredient_skus', id, COALESCE(NULLIF(sku_code, ''), '未编号 SKU'), deleted_at_utc
        FROM ingredient_skus WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'recommendation_presets', id, name, deleted_at_utc
        FROM recommendation_presets WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'formulas', id, name, deleted_at_utc
        FROM formulas WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'customers', id, COALESCE(NULLIF(name, ''), phone), deleted_at_utc
        FROM customers WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'plaque_types', id, name, deleted_at_utc
        FROM plaque_types WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'asset_categories', id, name, deleted_at_utc
        FROM asset_categories WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'asset_statuses', id, name, deleted_at_utc
        FROM asset_statuses WHERE is_deleted = 1 AND deleted_at_utc >= ?
      UNION ALL
      SELECT 'assets', id, name, deleted_at_utc
        FROM assets WHERE is_deleted = 1 AND deleted_at_utc >= ?
      ORDER BY deleted_at_utc DESC
      ''',
      variables: List.generate(11, (_) => Variable(cutoff)),
      readsFrom: {
        productionTypes,
        ingredientCategories,
        ingredients,
        ingredientSkus,
        recommendationPresets,
        formulas,
        customers,
        plaqueTypes,
        assetCategories,
        assetStatuses,
        assets,
      },
    ).watch().map(
      (rows) => [
        for (final row in rows)
          TrashEntry(
            type: TrashEntityType.values.singleWhere(
              (type) => type.tableName == row.read<String>('entity_type'),
            ),
            id: row.read('id'),
            name: row.read('name'),
            deletedAtUtc: row.read('deleted_at_utc'),
          ),
      ],
    );
  }

  Future<void> restoreTrashEntry(TrashEntry entry) async {
    await transaction(() async {
      await _validateRestoreParent(entry);
      final current = await customSelect(
        '''SELECT revision_id, is_deleted, deleted_at_utc
             FROM ${entry.type.tableName} WHERE id = ?''',
        variables: [Variable(entry.id)],
      ).getSingle();
      if (!current.read<bool>('is_deleted')) return;
      final deletedAt = current.readNullable<DateTime>('deleted_at_utc');
      if (deletedAt == null ||
          deletedAt.isBefore(
            DateTime.now().toUtc().subtract(const Duration(days: 30)),
          )) {
        throw StateError('该资料已超过 30 天恢复期限');
      }
      final change = await _recordOperation(
        entityType: entry.type.tableName,
        entityId: entry.id,
        baseRevisionId: current.read('revision_id'),
        operationKind: 'restore',
        payload: {'id': entry.id},
      );
      final ResultSetImplementation table = switch (entry.type) {
        TrashEntityType.productionType => productionTypes,
        TrashEntityType.ingredientCategory => ingredientCategories,
        TrashEntityType.ingredient => ingredients,
        TrashEntityType.ingredientSku => ingredientSkus,
        TrashEntityType.recommendationPreset => recommendationPresets,
        TrashEntityType.formula => formulas,
        TrashEntityType.customer => customers,
        TrashEntityType.plaqueType => plaqueTypes,
        TrashEntityType.assetCategory => assetCategories,
        TrashEntityType.assetStatus => assetStatuses,
        TrashEntityType.asset => assets,
      };
      await customUpdate(
        '''UPDATE ${entry.type.tableName}
              SET revision_id = ?, updated_by_device = ?, updated_at_utc = ?,
                  is_deleted = 0, deleted_at_utc = NULL
            WHERE id = ?''',
        variables: [
          Variable(change.revisionId),
          Variable(change.deviceId),
          Variable(change.now),
          Variable(entry.id),
        ],
        updates: {table},
      );
    });
  }

  Future<void> _validateRestoreParent(TrashEntry entry) async {
    switch (entry.type) {
      case TrashEntityType.ingredient:
        final item = await (select(
          ingredients,
        )..where((row) => row.id.equals(entry.id))).getSingle();
        final parent = await (select(
          ingredientCategories,
        )..where((row) => row.id.equals(item.categoryId))).getSingle();
        if (parent.isDeleted) throw StateError('请先恢复所属香料分类');
      case TrashEntityType.ingredientSku:
        final item = await (select(
          ingredientSkus,
        )..where((row) => row.id.equals(entry.id))).getSingle();
        final parent = await (select(
          ingredients,
        )..where((row) => row.id.equals(item.ingredientId))).getSingle();
        if (parent.isDeleted) throw StateError('请先恢复所属香料');
      case TrashEntityType.recommendationPreset:
        final item = await (select(
          recommendationPresets,
        )..where((row) => row.id.equals(entry.id))).getSingle();
        final parent = await (select(
          productionTypes,
        )..where((row) => row.id.equals(item.productionTypeId))).getSingle();
        if (parent.isDeleted) throw StateError('请先恢复所属制作类型');
        final missingDependency = await customSelect(
          '''SELECT 1
               WHERE EXISTS (
                 SELECT 1 FROM recommendation_groups rg
                 JOIN ingredient_categories c ON c.id = rg.category_id
                  WHERE rg.preset_id = ?
                    AND rg.is_deleted = 0 AND c.is_deleted = 1
               ) OR EXISTS (
                 SELECT 1 FROM recommendation_items ri
                 JOIN recommendation_groups rg ON rg.id = ri.group_id
                 JOIN ingredient_skus s ON s.id = ri.sku_id
                  WHERE rg.preset_id = ?
                    AND rg.is_deleted = 0 AND ri.is_deleted = 0
                    AND s.is_deleted = 1
               )''',
          variables: [Variable(entry.id), Variable(entry.id)],
        ).getSingleOrNull();
        if (missingDependency != null) {
          throw StateError('请先恢复配置使用的香料分类和 SKU');
        }
      case TrashEntityType.asset:
        final item = await (select(
          assets,
        )..where((row) => row.id.equals(entry.id))).getSingle();
        final category = await (select(
          assetCategories,
        )..where((row) => row.id.equals(item.categoryId))).getSingle();
        if (category.isDeleted) throw StateError('请先恢复所属资产分类');
        if (item.statusId != null) {
          final status = await (select(
            assetStatuses,
          )..where((row) => row.id.equals(item.statusId!))).getSingle();
          if (status.isDeleted) throw StateError('请先恢复所属资产状态');
        }
      case TrashEntityType.ingredientCategory ||
          TrashEntityType.productionType ||
          TrashEntityType.formula ||
          TrashEntityType.customer ||
          TrashEntityType.plaqueType ||
          TrashEntityType.assetCategory ||
          TrashEntityType.assetStatus:
        return;
    }
  }

  Stream<List<RatioRangeSetting>> watchRatioRanges(
    RatioRangeTarget target,
    String targetId,
  ) {
    final (tableName, foreignKey) = switch (target) {
      RatioRangeTarget.category => ('category_ratio_ranges', 'category_id'),
      RatioRangeTarget.ingredient => (
        'ingredient_ratio_ranges',
        'ingredient_id',
      ),
      RatioRangeTarget.sku => ('sku_ratio_overrides', 'sku_id'),
    };
    final Set<ResultSetImplementation> readsFrom = switch (target) {
      RatioRangeTarget.category => {productionTypes, categoryRatioRanges},
      RatioRangeTarget.ingredient => {productionTypes, ingredientRatioRanges},
      RatioRangeTarget.sku => {productionTypes, skuRatioOverrides},
    };
    return customSelect(
      '''
      SELECT pt.id AS production_type_id,
             pt.name AS production_type_name,
             pt.is_inactive AS production_type_inactive,
             rr.id AS range_id,
             rr.min_ratio,
             rr.max_ratio
        FROM production_types pt
        LEFT JOIN $tableName rr
          ON rr.$foreignKey = ?
         AND rr.production_type_id = pt.id
         AND rr.is_deleted = 0
       WHERE pt.is_deleted = 0
       ORDER BY pt.sort_order, pt.name
      ''',
      variables: [Variable(targetId)],
      readsFrom: readsFrom,
    ).watch().map(
      (rows) => [
        for (final row in rows)
          RatioRangeSetting(
            productionTypeId: row.read('production_type_id'),
            productionTypeName: row.read('production_type_name'),
            productionTypeInactive: row.read<bool>('production_type_inactive'),
            rangeId: row.readNullable('range_id'),
            minRatio: row.readNullable('min_ratio'),
            maxRatio: row.readNullable('max_ratio'),
          ),
      ],
    );
  }

  Future<void> setRatioRange({
    required RatioRangeTarget target,
    required String targetId,
    required String productionTypeId,
    required int minRatio,
    required int maxRatio,
  }) async {
    if (minRatio < 0 || maxRatio > 10000 || minRatio > maxRatio) {
      throw ArgumentError('推荐区间必须在 0.00% 到 100.00% 之间，且最低值不能大于最高值');
    }
    await transaction(() async {
      await _activeProductionType(productionTypeId);
      switch (target) {
        case RatioRangeTarget.category:
          await _activeCategory(targetId);
        case RatioRangeTarget.ingredient:
          await _activeIngredient(targetId);
        case RatioRangeTarget.sku:
          final sku = await (select(
            ingredientSkus,
          )..where((row) => row.id.equals(targetId))).getSingle();
          if (sku.isDeleted || sku.isInactive) {
            throw StateError('请选择可用的 SKU');
          }
          await _activeIngredient(sku.ingredientId);
      }
      final current = await _ratioRangeRevision(
        target,
        targetId,
        productionTypeId,
      );
      final id = current?.$1 ?? _newId();
      final change = await _recordOperation(
        entityType: _ratioTableName(target),
        entityId: id,
        baseRevisionId: current?.$2,
        operationKind: current == null
            ? 'create'
            : current.$3
            ? 'restore'
            : 'update',
        payload: {
          'id': id,
          'targetId': targetId,
          'productionTypeId': productionTypeId,
          'minRatio': minRatio,
          'maxRatio': maxRatio,
        },
      );
      if (current == null) {
        switch (target) {
          case RatioRangeTarget.category:
            await into(categoryRatioRanges).insert(
              CategoryRatioRangesCompanion.insert(
                id: id,
                revisionId: change.revisionId,
                updatedByDevice: change.deviceId,
                updatedAtUtc: change.now,
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                categoryId: targetId,
              ),
            );
          case RatioRangeTarget.ingredient:
            await into(ingredientRatioRanges).insert(
              IngredientRatioRangesCompanion.insert(
                id: id,
                revisionId: change.revisionId,
                updatedByDevice: change.deviceId,
                updatedAtUtc: change.now,
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                ingredientId: targetId,
              ),
            );
          case RatioRangeTarget.sku:
            await into(skuRatioOverrides).insert(
              SkuRatioOverridesCompanion.insert(
                id: id,
                revisionId: change.revisionId,
                updatedByDevice: change.deviceId,
                updatedAtUtc: change.now,
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                skuId: targetId,
              ),
            );
        }
      } else {
        final values = (
          revisionId: Value(change.revisionId),
          deviceId: Value(change.deviceId),
          now: Value(change.now),
          min: Value(minRatio),
          max: Value(maxRatio),
        );
        switch (target) {
          case RatioRangeTarget.category:
            await (update(
              categoryRatioRanges,
            )..where((row) => row.id.equals(id))).write(
              CategoryRatioRangesCompanion(
                revisionId: values.revisionId,
                updatedByDevice: values.deviceId,
                updatedAtUtc: values.now,
                minRatio: values.min,
                maxRatio: values.max,
                isDeleted: const Value(false),
                deletedAtUtc: const Value(null),
              ),
            );
          case RatioRangeTarget.ingredient:
            await (update(
              ingredientRatioRanges,
            )..where((row) => row.id.equals(id))).write(
              IngredientRatioRangesCompanion(
                revisionId: values.revisionId,
                updatedByDevice: values.deviceId,
                updatedAtUtc: values.now,
                minRatio: values.min,
                maxRatio: values.max,
                isDeleted: const Value(false),
                deletedAtUtc: const Value(null),
              ),
            );
          case RatioRangeTarget.sku:
            await (update(
              skuRatioOverrides,
            )..where((row) => row.id.equals(id))).write(
              SkuRatioOverridesCompanion(
                revisionId: values.revisionId,
                updatedByDevice: values.deviceId,
                updatedAtUtc: values.now,
                minRatio: values.min,
                maxRatio: values.max,
                isDeleted: const Value(false),
                deletedAtUtc: const Value(null),
              ),
            );
        }
      }
    });
  }

  Future<void> clearRatioRange(
    RatioRangeTarget target,
    String targetId,
    String productionTypeId,
  ) async {
    await transaction(() async {
      final current = await _ratioRangeRevision(
        target,
        targetId,
        productionTypeId,
      );
      if (current == null || current.$3) return;
      final change = await _recordOperation(
        entityType: _ratioTableName(target),
        entityId: current.$1,
        baseRevisionId: current.$2,
        operationKind: 'delete',
        payload: {'id': current.$1},
      );
      switch (target) {
        case RatioRangeTarget.category:
          await (update(
            categoryRatioRanges,
          )..where((row) => row.id.equals(current.$1))).write(
            CategoryRatioRangesCompanion(
              revisionId: Value(change.revisionId),
              updatedByDevice: Value(change.deviceId),
              updatedAtUtc: Value(change.now),
              isDeleted: const Value(true),
              deletedAtUtc: Value(change.now),
            ),
          );
        case RatioRangeTarget.ingredient:
          await (update(
            ingredientRatioRanges,
          )..where((row) => row.id.equals(current.$1))).write(
            IngredientRatioRangesCompanion(
              revisionId: Value(change.revisionId),
              updatedByDevice: Value(change.deviceId),
              updatedAtUtc: Value(change.now),
              isDeleted: const Value(true),
              deletedAtUtc: Value(change.now),
            ),
          );
        case RatioRangeTarget.sku:
          await (update(
            skuRatioOverrides,
          )..where((row) => row.id.equals(current.$1))).write(
            SkuRatioOverridesCompanion(
              revisionId: Value(change.revisionId),
              updatedByDevice: Value(change.deviceId),
              updatedAtUtc: Value(change.now),
              isDeleted: const Value(true),
              deletedAtUtc: Value(change.now),
            ),
          );
      }
    });
  }

  Future<(String, String, bool)?> _ratioRangeRevision(
    RatioRangeTarget target,
    String targetId,
    String productionTypeId,
  ) async {
    final (tableName, foreignKey) = switch (target) {
      RatioRangeTarget.category => ('category_ratio_ranges', 'category_id'),
      RatioRangeTarget.ingredient => (
        'ingredient_ratio_ranges',
        'ingredient_id',
      ),
      RatioRangeTarget.sku => ('sku_ratio_overrides', 'sku_id'),
    };
    final row = await customSelect(
      '''SELECT id, revision_id, is_deleted FROM $tableName
          WHERE $foreignKey = ? AND production_type_id = ?
          LIMIT 1''',
      variables: [Variable(targetId), Variable(productionTypeId)],
    ).getSingleOrNull();
    return row == null
        ? null
        : (
            row.read<String>('id'),
            row.read<String>('revision_id'),
            row.read<bool>('is_deleted'),
          );
  }

  String _ratioTableName(RatioRangeTarget target) => switch (target) {
    RatioRangeTarget.category => 'category_ratio_ranges',
    RatioRangeTarget.ingredient => 'ingredient_ratio_ranges',
    RatioRangeTarget.sku => 'sku_ratio_overrides',
  };

  Future<List<ProductionType>> getActiveProductionTypes({String? includeId}) {
    final query = select(productionTypes)
      ..where(
        (row) =>
            row.isDeleted.equals(false) &
            (row.isInactive.equals(false) |
                (includeId == null
                    ? const Constant(false)
                    : row.id.equals(includeId))),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.get();
  }

  Stream<List<RecommendationPresetSummary>> watchRecommendationPresets({
    String search = '',
    String? productionTypeId,
    bool includeInactive = false,
  }) {
    final normalized = search.trim();
    final query =
        select(recommendationPresets).join([
            innerJoin(
              productionTypes,
              productionTypes.id.equalsExp(
                recommendationPresets.productionTypeId,
              ),
            ),
          ])
          ..where(
            recommendationPresets.isDeleted.equals(false) &
                productionTypes.isDeleted.equals(false),
          )
          ..orderBy([
            OrderingTerm.asc(recommendationPresets.sortOrder),
            OrderingTerm.asc(recommendationPresets.name),
          ]);
    if (!includeInactive) {
      query.where(recommendationPresets.isInactive.equals(false));
    }
    if (productionTypeId != null) {
      query.where(
        recommendationPresets.productionTypeId.equals(productionTypeId),
      );
    }
    if (normalized.isNotEmpty) {
      query.where(
        recommendationPresets.name.contains(normalized) |
            productionTypes.name.contains(normalized),
      );
    }
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          RecommendationPresetSummary(
            row.readTable(recommendationPresets),
            row.readTable(productionTypes).name,
          ),
      ],
    );
  }

  Future<RecommendationPreset> createRecommendationPreset({
    required String name,
    required String productionTypeId,
    String? notes,
  }) async {
    final normalized = _requiredName(name, '推荐配置名称不能为空');
    final normalizedNotes = _optionalText(notes);
    return transaction(() async {
      await _activeProductionType(productionTypeId);
      final latest =
          await (select(recommendationPresets)
                ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      final id = _newId();
      final sortOrder = (latest?.sortOrder ?? -1) + 1;
      final change = await _recordOperation(
        entityType: 'recommendation_presets',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'name': normalized,
          'productionTypeId': productionTypeId,
          'notes': normalizedNotes,
          'sortOrder': sortOrder,
          'isInactive': false,
        },
      );
      await into(recommendationPresets).insert(
        RecommendationPresetsCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          productionTypeId: productionTypeId,
          name: normalized,
          notes: Value(normalizedNotes),
          sortOrder: sortOrder,
        ),
      );
      return (select(
        recommendationPresets,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateRecommendationPreset(
    String id, {
    required String name,
    required String productionTypeId,
    required String? notes,
    bool? isInactive,
  }) async {
    final normalized = _requiredName(name, '推荐配置名称不能为空');
    final normalizedNotes = _optionalText(notes);
    await transaction(() async {
      final current = await (select(
        recommendationPresets,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的推荐配置不能修改');
      await _activeProductionType(
        productionTypeId,
        allowInactive: productionTypeId == current.productionTypeId,
      );
      final inactive = isInactive ?? current.isInactive;
      final change = await _recordOperation(
        entityType: 'recommendation_presets',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {
          'id': id,
          'name': normalized,
          'productionTypeId': productionTypeId,
          'notes': normalizedNotes,
          'isInactive': inactive,
        },
      );
      await (update(
        recommendationPresets,
      )..where((row) => row.id.equals(id))).write(
        RecommendationPresetsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          productionTypeId: Value(productionTypeId),
          name: Value(normalized),
          notes: Value(normalizedNotes),
          isInactive: Value(inactive),
        ),
      );
    });
  }

  Future<RecommendationPreset> copyRecommendationPreset(String id) async {
    return transaction(() async {
      final source = await (select(
        recommendationPresets,
      )..where((row) => row.id.equals(id))).getSingle();
      if (source.isDeleted) throw StateError('已删除的推荐配置不能复制');
      final copy = await createRecommendationPreset(
        name: '${source.name} 副本',
        productionTypeId: source.productionTypeId,
        notes: source.notes,
      );
      final groups =
          await (select(recommendationGroups)..where(
                (row) =>
                    row.presetId.equals(source.id) &
                    row.isDeleted.equals(false),
              ))
              .get();
      for (final group in groups) {
        final copiedGroup = await createRecommendationGroup(
          presetId: copy.id,
          categoryId: group.categoryId,
          ratio: group.ratio,
        );
        final items =
            await (select(recommendationItems)..where(
                  (row) =>
                      row.groupId.equals(group.id) &
                      row.isDeleted.equals(false),
                ))
                .get();
        for (final item in items) {
          await createRecommendationItem(
            groupId: copiedGroup.id,
            skuId: item.skuId,
            ratio: item.ratio,
          );
        }
      }
      return copy;
    });
  }

  Future<void> deleteRecommendationPreset(String id) async {
    await transaction(() async {
      final current = await (select(
        recommendationPresets,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final change = await _recordOperation(
        entityType: 'recommendation_presets',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(
        recommendationPresets,
      )..where((row) => row.id.equals(id))).write(
        RecommendationPresetsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Stream<List<RecommendationGroupSummary>> watchRecommendationGroups(
    String presetId,
  ) =>
      customSelect(
        '''
        SELECT rg.id,
               rg.category_id,
               ic.name AS category_name,
               rg.ratio,
               COALESCE(SUM(CASE WHEN ri.is_deleted = 0 THEN ri.ratio ELSE 0 END), 0) AS item_total
          FROM recommendation_groups rg
          JOIN ingredient_categories ic ON ic.id = rg.category_id
          LEFT JOIN recommendation_items ri ON ri.group_id = rg.id
         WHERE rg.preset_id = ? AND rg.is_deleted = 0
         GROUP BY rg.id, rg.category_id, ic.name, rg.ratio
         ORDER BY ic.sort_order, ic.name
        ''',
        variables: [Variable(presetId)],
        readsFrom: {
          recommendationGroups,
          recommendationItems,
          ingredientCategories,
        },
      ).watch().map(
        (rows) => [
          for (final row in rows)
            RecommendationGroupSummary(
              id: row.read('id'),
              categoryId: row.read('category_id'),
              categoryName: row.read('category_name'),
              ratio: row.read('ratio'),
              itemTotal: row.read('item_total'),
            ),
        ],
      );

  Stream<List<RecommendationItemSummary>> watchRecommendationItems(
    String groupId,
  ) =>
      customSelect(
        '''
        SELECT ri.id,
               ri.sku_id,
               i.name AS ingredient_name,
               s.sku_code,
               ri.ratio
          FROM recommendation_items ri
          JOIN ingredient_skus s ON s.id = ri.sku_id
          JOIN ingredients i ON i.id = s.ingredient_id
         WHERE ri.group_id = ? AND ri.is_deleted = 0
         ORDER BY i.name, s.sku_code
        ''',
        variables: [Variable(groupId)],
        readsFrom: {recommendationItems, ingredientSkus, ingredients},
      ).watch().map(
        (rows) => [
          for (final row in rows)
            RecommendationItemSummary(
              id: row.read('id'),
              skuId: row.read('sku_id'),
              ingredientName: row.read('ingredient_name'),
              skuCode: row.readNullable('sku_code'),
              ratio: row.read('ratio'),
            ),
        ],
      );

  Future<List<SkuChoice>> getActiveSkusForCategory(String categoryId) async {
    final rows = await customSelect(
      '''
      SELECT s.id, i.name AS ingredient_name, s.sku_code
        FROM ingredient_skus s
        JOIN ingredients i ON i.id = s.ingredient_id
       WHERE i.category_id = ?
         AND i.is_deleted = 0 AND i.is_inactive = 0
         AND s.is_deleted = 0 AND s.is_inactive = 0
       ORDER BY i.name, s.sku_code
      ''',
      variables: [Variable(categoryId)],
      readsFrom: {ingredientSkus, ingredients},
    ).get();
    return [
      for (final row in rows)
        SkuChoice(
          row.read('id'),
          [
            row.read<String>('ingredient_name'),
            row.readNullable<String>('sku_code'),
          ].whereType<String>().join(' · '),
        ),
    ];
  }

  Future<RecommendationGroup> createRecommendationGroup({
    required String presetId,
    required String categoryId,
    required int ratio,
  }) async {
    return transaction(() async {
      await _activePreset(presetId);
      await _activeCategory(categoryId);
      _validateFixedRatio(ratio);
      await _ensureGroupTotal(presetId, ratio);
      final existing =
          await (select(recommendationGroups)..where(
                (row) =>
                    row.presetId.equals(presetId) &
                    row.categoryId.equals(categoryId),
              ))
              .getSingleOrNull();
      if (existing != null && !existing.isDeleted) {
        throw StateError('该大类已在推荐配置中');
      }
      if (existing != null) {
        final change = await _recordOperation(
          entityType: 'recommendation_groups',
          entityId: existing.id,
          baseRevisionId: existing.revisionId,
          operationKind: 'restore',
          payload: {'id': existing.id, 'ratio': ratio},
        );
        await (update(
          recommendationGroups,
        )..where((row) => row.id.equals(existing.id))).write(
          RecommendationGroupsCompanion(
            revisionId: Value(change.revisionId),
            updatedByDevice: Value(change.deviceId),
            updatedAtUtc: Value(change.now),
            ratio: Value(ratio),
            isDeleted: const Value(false),
            deletedAtUtc: const Value(null),
          ),
        );
        return (select(
          recommendationGroups,
        )..where((row) => row.id.equals(existing.id))).getSingle();
      }
      final id = _newId();
      final change = await _recordOperation(
        entityType: 'recommendation_groups',
        entityId: id,
        operationKind: 'create',
        payload: {
          'id': id,
          'presetId': presetId,
          'categoryId': categoryId,
          'ratio': ratio,
        },
      );
      await into(recommendationGroups).insert(
        RecommendationGroupsCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          presetId: presetId,
          categoryId: categoryId,
          ratio: ratio,
        ),
      );
      return (select(
        recommendationGroups,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateRecommendationGroupRatio(String id, int ratio) async {
    await transaction(() async {
      final current = await (select(
        recommendationGroups,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的大类比例不能修改');
      _validateFixedRatio(ratio);
      await _ensureGroupTotal(current.presetId, ratio, excludingId: id);
      final itemTotal = await _recommendationItemTotal(id);
      if (itemTotal > ratio) throw StateError('大类比例不能低于当前 SKU 比例合计');
      final change = await _recordOperation(
        entityType: 'recommendation_groups',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {'id': id, 'ratio': ratio},
      );
      await (update(
        recommendationGroups,
      )..where((row) => row.id.equals(id))).write(
        RecommendationGroupsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          ratio: Value(ratio),
        ),
      );
    });
  }

  Future<void> deleteRecommendationGroup(String id) async {
    await transaction(() async {
      final current = await (select(
        recommendationGroups,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      if (await _recommendationItemTotal(id) > 0) {
        throw StateError('请先删除该大类下的 SKU');
      }
      await _softDeleteRecommendationGroup(current);
    });
  }

  Future<RecommendationItem> createRecommendationItem({
    required String groupId,
    required String skuId,
    required int ratio,
  }) async {
    return transaction(() async {
      final group = await _activeRecommendationGroup(groupId);
      await _validateSkuCategory(skuId, group.categoryId);
      _validateFixedRatio(ratio);
      await _ensureItemTotal(group, ratio);
      final existing =
          await (select(recommendationItems)..where(
                (row) => row.groupId.equals(groupId) & row.skuId.equals(skuId),
              ))
              .getSingleOrNull();
      if (existing != null && !existing.isDeleted) {
        throw StateError('该 SKU 已在大类中');
      }
      if (existing != null) {
        final change = await _recordOperation(
          entityType: 'recommendation_items',
          entityId: existing.id,
          baseRevisionId: existing.revisionId,
          operationKind: 'restore',
          payload: {'id': existing.id, 'ratio': ratio},
        );
        await (update(
          recommendationItems,
        )..where((row) => row.id.equals(existing.id))).write(
          RecommendationItemsCompanion(
            revisionId: Value(change.revisionId),
            updatedByDevice: Value(change.deviceId),
            updatedAtUtc: Value(change.now),
            ratio: Value(ratio),
            isDeleted: const Value(false),
            deletedAtUtc: const Value(null),
          ),
        );
        return (select(
          recommendationItems,
        )..where((row) => row.id.equals(existing.id))).getSingle();
      }
      final id = _newId();
      final change = await _recordOperation(
        entityType: 'recommendation_items',
        entityId: id,
        operationKind: 'create',
        payload: {'id': id, 'groupId': groupId, 'skuId': skuId, 'ratio': ratio},
      );
      await into(recommendationItems).insert(
        RecommendationItemsCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          groupId: groupId,
          skuId: skuId,
          ratio: ratio,
        ),
      );
      return (select(
        recommendationItems,
      )..where((row) => row.id.equals(id))).getSingle();
    });
  }

  Future<void> updateRecommendationItemRatio(String id, int ratio) async {
    await transaction(() async {
      final current = await (select(
        recommendationItems,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) throw StateError('已删除的 SKU 比例不能修改');
      final group = await _activeRecommendationGroup(current.groupId);
      _validateFixedRatio(ratio);
      await _ensureItemTotal(group, ratio, excludingId: id);
      final change = await _recordOperation(
        entityType: 'recommendation_items',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'update',
        payload: {'id': id, 'ratio': ratio},
      );
      await (update(
        recommendationItems,
      )..where((row) => row.id.equals(id))).write(
        RecommendationItemsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          ratio: Value(ratio),
        ),
      );
    });
  }

  Future<void> deleteRecommendationItem(String id) async {
    await transaction(() async {
      final current = await (select(
        recommendationItems,
      )..where((row) => row.id.equals(id))).getSingle();
      if (current.isDeleted) return;
      final change = await _recordOperation(
        entityType: 'recommendation_items',
        entityId: id,
        baseRevisionId: current.revisionId,
        operationKind: 'delete',
        payload: {'id': id},
      );
      await (update(
        recommendationItems,
      )..where((row) => row.id.equals(id))).write(
        RecommendationItemsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          isDeleted: const Value(true),
          deletedAtUtc: Value(change.now),
        ),
      );
    });
  }

  Future<ProductionType> _activeProductionType(
    String id, {
    bool allowInactive = false,
  }) async {
    final type = await (select(
      productionTypes,
    )..where((row) => row.id.equals(id))).getSingle();
    if (type.isDeleted || (!allowInactive && type.isInactive)) {
      throw StateError('请选择可用的制作类型');
    }
    return type;
  }

  Future<Ingredient> _activeIngredient(
    String id, {
    bool allowInactive = false,
  }) async {
    final result = await (select(ingredients).join([
      innerJoin(
        ingredientCategories,
        ingredientCategories.id.equalsExp(ingredients.categoryId),
      ),
    ])..where(ingredients.id.equals(id))).getSingle();
    final ingredient = result.readTable(ingredients);
    final category = result.readTable(ingredientCategories);
    if (ingredient.isDeleted ||
        category.isDeleted ||
        (!allowInactive && (ingredient.isInactive || category.isInactive))) {
      throw StateError('已停用或删除的香料不能新增 SKU');
    }
    return ingredient;
  }

  Future<IngredientCategory> _activeCategory(
    String id, {
    bool allowInactive = false,
  }) async {
    final category = await (select(
      ingredientCategories,
    )..where((row) => row.id.equals(id))).getSingle();
    if (category.isDeleted || (!allowInactive && category.isInactive)) {
      throw StateError('请选择可用的香料分类');
    }
    return category;
  }

  Future<RecommendationPreset> _activePreset(String id) async {
    final preset = await (select(
      recommendationPresets,
    )..where((row) => row.id.equals(id))).getSingle();
    if (preset.isDeleted || preset.isInactive) {
      throw StateError('已停用或删除的推荐配置不能修改');
    }
    return preset;
  }

  Future<RecommendationGroup> _activeRecommendationGroup(String id) async {
    final group = await (select(
      recommendationGroups,
    )..where((row) => row.id.equals(id))).getSingle();
    if (group.isDeleted) throw StateError('已删除的大类比例不能修改');
    await _activePreset(group.presetId);
    return group;
  }

  void _validateFixedRatio(int ratio) {
    if (ratio < 1 || ratio > 10000) {
      throw ArgumentError.value(ratio, 'ratio', '比例必须在 0.01% 到 100.00% 之间');
    }
  }

  Future<void> _ensureGroupTotal(
    String presetId,
    int ratio, {
    String? excludingId,
  }) async {
    final total = recommendationGroups.ratio.sum();
    final query = selectOnly(recommendationGroups)..addColumns([total]);
    query.where(
      recommendationGroups.presetId.equals(presetId) &
          recommendationGroups.isDeleted.equals(false),
    );
    if (excludingId != null) {
      query.where(recommendationGroups.id.equals(excludingId).not());
    }
    final current = await query.map((row) => row.read(total) ?? 0).getSingle();
    if (current + ratio > 10000) throw StateError('大类比例合计不能超过 100.00%');
  }

  Future<int> _recommendationItemTotal(String groupId) async {
    final total = recommendationItems.ratio.sum();
    final query = selectOnly(recommendationItems)..addColumns([total]);
    query.where(
      recommendationItems.groupId.equals(groupId) &
          recommendationItems.isDeleted.equals(false),
    );
    return query.map((row) => row.read(total) ?? 0).getSingle();
  }

  Future<void> _ensureItemTotal(
    RecommendationGroup group,
    int ratio, {
    String? excludingId,
  }) async {
    final total = recommendationItems.ratio.sum();
    final query = selectOnly(recommendationItems)..addColumns([total]);
    query.where(
      recommendationItems.groupId.equals(group.id) &
          recommendationItems.isDeleted.equals(false),
    );
    if (excludingId != null) {
      query.where(recommendationItems.id.equals(excludingId).not());
    }
    final current = await query.map((row) => row.read(total) ?? 0).getSingle();
    if (current + ratio > group.ratio) {
      throw StateError('SKU 比例合计不能超过所属大类比例');
    }
  }

  Future<void> _validateSkuCategory(String skuId, String categoryId) async {
    await _activeCategory(categoryId);
    final row = await (select(ingredientSkus).join([
      innerJoin(
        ingredients,
        ingredients.id.equalsExp(ingredientSkus.ingredientId),
      ),
    ])..where(ingredientSkus.id.equals(skuId))).getSingle();
    final sku = row.readTable(ingredientSkus);
    final ingredient = row.readTable(ingredients);
    if (sku.isDeleted ||
        sku.isInactive ||
        ingredient.isDeleted ||
        ingredient.isInactive ||
        ingredient.categoryId != categoryId) {
      throw StateError('请选择该大类下可用的 SKU');
    }
  }

  Future<void> _softDeleteRecommendationGroup(
    RecommendationGroup current,
  ) async {
    final change = await _recordOperation(
      entityType: 'recommendation_groups',
      entityId: current.id,
      baseRevisionId: current.revisionId,
      operationKind: 'delete',
      payload: {'id': current.id},
    );
    await (update(
      recommendationGroups,
    )..where((row) => row.id.equals(current.id))).write(
      RecommendationGroupsCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        isDeleted: const Value(true),
        deletedAtUtc: Value(change.now),
      ),
    );
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

String? _optionalImageHash(String? value) {
  final hash = _optionalText(value);
  if (hash != null && !RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
    throw ArgumentError.value(value, 'imageHash', '图片标识无效');
  }
  return hash;
}

(String, String) _customerIdentity(String? name, String? phone) {
  final normalizedName = name?.trim() ?? '';
  final normalizedPhone = phone?.trim() ?? '';
  if (normalizedName.isEmpty && normalizedPhone.isEmpty) {
    throw ArgumentError('姓名和电话不能同时为空');
  }
  return (normalizedName, normalizedPhone);
}
