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

@DriftDatabase(tables: [ProductionTypes, LocalDevices, SyncOperations])
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) =>
            throw StateError('缺少数据库迁移：$from → $to'),
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
