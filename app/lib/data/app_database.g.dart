// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductionTypesTable extends ProductionTypes
    with TableInfo<$ProductionTypesTable, ProductionType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductionTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'production_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductionType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductionType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductionType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $ProductionTypesTable createAlias(String alias) {
    return $ProductionTypesTable(attachedDatabase, alias);
  }
}

class ProductionType extends DataClass implements Insertable<ProductionType> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String name;
  final int sortOrder;
  final bool isInactive;
  const ProductionType({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.name,
    required this.sortOrder,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  ProductionTypesCompanion toCompanion(bool nullToAbsent) {
    return ProductionTypesCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isInactive: Value(isInactive),
    );
  }

  factory ProductionType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductionType(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  ProductionType copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? name,
    int? sortOrder,
    bool? isInactive,
  }) => ProductionType(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isInactive: isInactive ?? this.isInactive,
  );
  ProductionType copyWithCompanion(ProductionTypesCompanion data) {
    return ProductionType(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductionType(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductionType &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isInactive == this.isInactive);
}

class ProductionTypesCompanion extends UpdateCompanion<ProductionType> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const ProductionTypesCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductionTypesCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String name,
    required int sortOrder,
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<ProductionType> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductionTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return ProductionTypesCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductionTypesCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientCategoriesTable extends IngredientCategories
    with TableInfo<$IngredientCategoriesTable, IngredientCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $IngredientCategoriesTable createAlias(String alias) {
    return $IngredientCategoriesTable(attachedDatabase, alias);
  }
}

class IngredientCategory extends DataClass
    implements Insertable<IngredientCategory> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String name;
  final int sortOrder;
  final bool isInactive;
  const IngredientCategory({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.name,
    required this.sortOrder,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  IngredientCategoriesCompanion toCompanion(bool nullToAbsent) {
    return IngredientCategoriesCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isInactive: Value(isInactive),
    );
  }

  factory IngredientCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientCategory(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  IngredientCategory copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? name,
    int? sortOrder,
    bool? isInactive,
  }) => IngredientCategory(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isInactive: isInactive ?? this.isInactive,
  );
  IngredientCategory copyWithCompanion(IngredientCategoriesCompanion data) {
    return IngredientCategory(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCategory(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientCategory &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isInactive == this.isInactive);
}

class IngredientCategoriesCompanion
    extends UpdateCompanion<IngredientCategory> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const IngredientCategoriesCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientCategoriesCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String name,
    required int sortOrder,
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<IngredientCategory> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return IngredientCategoriesCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredient_categories (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    categoryId,
    name,
    alias,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String categoryId;
  final String name;
  final String? alias;
  final bool isInactive;
  const Ingredient({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.categoryId,
    required this.name,
    this.alias,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      categoryId: Value(categoryId),
      name: Value(name),
      alias: alias == null && nullToAbsent
          ? const Value.absent()
          : Value(alias),
      isInactive: Value(isInactive),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      alias: serializer.fromJson<String?>(json['alias']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'alias': serializer.toJson<String?>(alias),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  Ingredient copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? categoryId,
    String? name,
    Value<String?> alias = const Value.absent(),
    bool? isInactive,
  }) => Ingredient(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    alias: alias.present ? alias.value : this.alias,
    isInactive: isInactive ?? this.isInactive,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      alias: data.alias.present ? data.alias.value : this.alias,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    categoryId,
    name,
    alias,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.alias == this.alias &&
          other.isInactive == this.isInactive);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> alias;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.alias = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String categoryId,
    required String name,
    this.alias = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       categoryId = Value(categoryId),
       name = Value(name);
  static Insertable<Ingredient> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? alias,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (alias != null) 'alias': alias,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String?>? alias,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientSkusTable extends IngredientSkus
    with TableInfo<$IngredientSkusTable, IngredientSkusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientSkusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _skuCodeMeta = const VerificationMeta(
    'skuCode',
  );
  @override
  late final GeneratedColumn<String> skuCode = GeneratedColumn<String>(
    'sku_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageHashMeta = const VerificationMeta(
    'imageHash',
  );
  @override
  late final GeneratedColumn<String> imageHash = GeneratedColumn<String>(
    'image_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierMeta = const VerificationMeta(
    'supplier',
  );
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
    'supplier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseUrlMeta = const VerificationMeta(
    'purchaseUrl',
  );
  @override
  late final GeneratedColumn<String> purchaseUrl = GeneratedColumn<String>(
    'purchase_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    ingredientId,
    skuCode,
    imageHash,
    supplier,
    origin,
    purchaseUrl,
    notes,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_skus';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientSkusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('sku_code')) {
      context.handle(
        _skuCodeMeta,
        skuCode.isAcceptableOrUnknown(data['sku_code']!, _skuCodeMeta),
      );
    }
    if (data.containsKey('image_hash')) {
      context.handle(
        _imageHashMeta,
        imageHash.isAcceptableOrUnknown(data['image_hash']!, _imageHashMeta),
      );
    }
    if (data.containsKey('supplier')) {
      context.handle(
        _supplierMeta,
        supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta),
      );
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('purchase_url')) {
      context.handle(
        _purchaseUrlMeta,
        purchaseUrl.isAcceptableOrUnknown(
          data['purchase_url']!,
          _purchaseUrlMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientSkusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientSkusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      skuCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku_code'],
      ),
      imageHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_hash'],
      ),
      supplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier'],
      ),
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      ),
      purchaseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $IngredientSkusTable createAlias(String alias) {
    return $IngredientSkusTable(attachedDatabase, alias);
  }
}

class IngredientSkusData extends DataClass
    implements Insertable<IngredientSkusData> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String ingredientId;
  final String? skuCode;
  final String? imageHash;
  final String? supplier;
  final String? origin;
  final String? purchaseUrl;
  final String? notes;
  final bool isInactive;
  const IngredientSkusData({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.ingredientId,
    this.skuCode,
    this.imageHash,
    this.supplier,
    this.origin,
    this.purchaseUrl,
    this.notes,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['ingredient_id'] = Variable<String>(ingredientId);
    if (!nullToAbsent || skuCode != null) {
      map['sku_code'] = Variable<String>(skuCode);
    }
    if (!nullToAbsent || imageHash != null) {
      map['image_hash'] = Variable<String>(imageHash);
    }
    if (!nullToAbsent || supplier != null) {
      map['supplier'] = Variable<String>(supplier);
    }
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || purchaseUrl != null) {
      map['purchase_url'] = Variable<String>(purchaseUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  IngredientSkusCompanion toCompanion(bool nullToAbsent) {
    return IngredientSkusCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      ingredientId: Value(ingredientId),
      skuCode: skuCode == null && nullToAbsent
          ? const Value.absent()
          : Value(skuCode),
      imageHash: imageHash == null && nullToAbsent
          ? const Value.absent()
          : Value(imageHash),
      supplier: supplier == null && nullToAbsent
          ? const Value.absent()
          : Value(supplier),
      origin: origin == null && nullToAbsent
          ? const Value.absent()
          : Value(origin),
      purchaseUrl: purchaseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isInactive: Value(isInactive),
    );
  }

  factory IngredientSkusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientSkusData(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      skuCode: serializer.fromJson<String?>(json['skuCode']),
      imageHash: serializer.fromJson<String?>(json['imageHash']),
      supplier: serializer.fromJson<String?>(json['supplier']),
      origin: serializer.fromJson<String?>(json['origin']),
      purchaseUrl: serializer.fromJson<String?>(json['purchaseUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'skuCode': serializer.toJson<String?>(skuCode),
      'imageHash': serializer.toJson<String?>(imageHash),
      'supplier': serializer.toJson<String?>(supplier),
      'origin': serializer.toJson<String?>(origin),
      'purchaseUrl': serializer.toJson<String?>(purchaseUrl),
      'notes': serializer.toJson<String?>(notes),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  IngredientSkusData copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? ingredientId,
    Value<String?> skuCode = const Value.absent(),
    Value<String?> imageHash = const Value.absent(),
    Value<String?> supplier = const Value.absent(),
    Value<String?> origin = const Value.absent(),
    Value<String?> purchaseUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isInactive,
  }) => IngredientSkusData(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    ingredientId: ingredientId ?? this.ingredientId,
    skuCode: skuCode.present ? skuCode.value : this.skuCode,
    imageHash: imageHash.present ? imageHash.value : this.imageHash,
    supplier: supplier.present ? supplier.value : this.supplier,
    origin: origin.present ? origin.value : this.origin,
    purchaseUrl: purchaseUrl.present ? purchaseUrl.value : this.purchaseUrl,
    notes: notes.present ? notes.value : this.notes,
    isInactive: isInactive ?? this.isInactive,
  );
  IngredientSkusData copyWithCompanion(IngredientSkusCompanion data) {
    return IngredientSkusData(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      skuCode: data.skuCode.present ? data.skuCode.value : this.skuCode,
      imageHash: data.imageHash.present ? data.imageHash.value : this.imageHash,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      origin: data.origin.present ? data.origin.value : this.origin,
      purchaseUrl: data.purchaseUrl.present
          ? data.purchaseUrl.value
          : this.purchaseUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientSkusData(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('skuCode: $skuCode, ')
          ..write('imageHash: $imageHash, ')
          ..write('supplier: $supplier, ')
          ..write('origin: $origin, ')
          ..write('purchaseUrl: $purchaseUrl, ')
          ..write('notes: $notes, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    ingredientId,
    skuCode,
    imageHash,
    supplier,
    origin,
    purchaseUrl,
    notes,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientSkusData &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.ingredientId == this.ingredientId &&
          other.skuCode == this.skuCode &&
          other.imageHash == this.imageHash &&
          other.supplier == this.supplier &&
          other.origin == this.origin &&
          other.purchaseUrl == this.purchaseUrl &&
          other.notes == this.notes &&
          other.isInactive == this.isInactive);
}

class IngredientSkusCompanion extends UpdateCompanion<IngredientSkusData> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> ingredientId;
  final Value<String?> skuCode;
  final Value<String?> imageHash;
  final Value<String?> supplier;
  final Value<String?> origin;
  final Value<String?> purchaseUrl;
  final Value<String?> notes;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const IngredientSkusCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.skuCode = const Value.absent(),
    this.imageHash = const Value.absent(),
    this.supplier = const Value.absent(),
    this.origin = const Value.absent(),
    this.purchaseUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientSkusCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String ingredientId,
    this.skuCode = const Value.absent(),
    this.imageHash = const Value.absent(),
    this.supplier = const Value.absent(),
    this.origin = const Value.absent(),
    this.purchaseUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       ingredientId = Value(ingredientId);
  static Insertable<IngredientSkusData> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? ingredientId,
    Expression<String>? skuCode,
    Expression<String>? imageHash,
    Expression<String>? supplier,
    Expression<String>? origin,
    Expression<String>? purchaseUrl,
    Expression<String>? notes,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (skuCode != null) 'sku_code': skuCode,
      if (imageHash != null) 'image_hash': imageHash,
      if (supplier != null) 'supplier': supplier,
      if (origin != null) 'origin': origin,
      if (purchaseUrl != null) 'purchase_url': purchaseUrl,
      if (notes != null) 'notes': notes,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientSkusCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? ingredientId,
    Value<String?>? skuCode,
    Value<String?>? imageHash,
    Value<String?>? supplier,
    Value<String?>? origin,
    Value<String?>? purchaseUrl,
    Value<String?>? notes,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return IngredientSkusCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      ingredientId: ingredientId ?? this.ingredientId,
      skuCode: skuCode ?? this.skuCode,
      imageHash: imageHash ?? this.imageHash,
      supplier: supplier ?? this.supplier,
      origin: origin ?? this.origin,
      purchaseUrl: purchaseUrl ?? this.purchaseUrl,
      notes: notes ?? this.notes,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (skuCode.present) {
      map['sku_code'] = Variable<String>(skuCode.value);
    }
    if (imageHash.present) {
      map['image_hash'] = Variable<String>(imageHash.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (purchaseUrl.present) {
      map['purchase_url'] = Variable<String>(purchaseUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientSkusCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('skuCode: $skuCode, ')
          ..write('imageHash: $imageHash, ')
          ..write('supplier: $supplier, ')
          ..write('origin: $origin, ')
          ..write('purchaseUrl: $purchaseUrl, ')
          ..write('notes: $notes, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryRatioRangesTable extends CategoryRatioRanges
    with TableInfo<$CategoryRatioRangesTable, CategoryRatioRange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryRatioRangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productionTypeIdMeta = const VerificationMeta(
    'productionTypeId',
  );
  @override
  late final GeneratedColumn<String> productionTypeId = GeneratedColumn<String>(
    'production_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES production_types (id)',
    ),
  );
  static const VerificationMeta _minRatioMeta = const VerificationMeta(
    'minRatio',
  );
  @override
  late final GeneratedColumn<int> minRatio = GeneratedColumn<int>(
    'min_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxRatioMeta = const VerificationMeta(
    'maxRatio',
  );
  @override
  late final GeneratedColumn<int> maxRatio = GeneratedColumn<int>(
    'max_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredient_categories (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    productionTypeId,
    minRatio,
    maxRatio,
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    categoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_ratio_ranges';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRatioRange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('production_type_id')) {
      context.handle(
        _productionTypeIdMeta,
        productionTypeId.isAcceptableOrUnknown(
          data['production_type_id']!,
          _productionTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productionTypeIdMeta);
    }
    if (data.containsKey('min_ratio')) {
      context.handle(
        _minRatioMeta,
        minRatio.isAcceptableOrUnknown(data['min_ratio']!, _minRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_minRatioMeta);
    }
    if (data.containsKey('max_ratio')) {
      context.handle(
        _maxRatioMeta,
        maxRatio.isAcceptableOrUnknown(data['max_ratio']!, _maxRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_maxRatioMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {categoryId, productionTypeId},
  ];
  @override
  CategoryRatioRange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRatioRange(
      productionTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}production_type_id'],
      )!,
      minRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_ratio'],
      )!,
      maxRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_ratio'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $CategoryRatioRangesTable createAlias(String alias) {
    return $CategoryRatioRangesTable(attachedDatabase, alias);
  }
}

class CategoryRatioRange extends DataClass
    implements Insertable<CategoryRatioRange> {
  final String productionTypeId;
  final int minRatio;
  final int maxRatio;
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String categoryId;
  const CategoryRatioRange({
    required this.productionTypeId,
    required this.minRatio,
    required this.maxRatio,
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['production_type_id'] = Variable<String>(productionTypeId);
    map['min_ratio'] = Variable<int>(minRatio);
    map['max_ratio'] = Variable<int>(maxRatio);
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  CategoryRatioRangesCompanion toCompanion(bool nullToAbsent) {
    return CategoryRatioRangesCompanion(
      productionTypeId: Value(productionTypeId),
      minRatio: Value(minRatio),
      maxRatio: Value(maxRatio),
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      categoryId: Value(categoryId),
    );
  }

  factory CategoryRatioRange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRatioRange(
      productionTypeId: serializer.fromJson<String>(json['productionTypeId']),
      minRatio: serializer.fromJson<int>(json['minRatio']),
      maxRatio: serializer.fromJson<int>(json['maxRatio']),
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productionTypeId': serializer.toJson<String>(productionTypeId),
      'minRatio': serializer.toJson<int>(minRatio),
      'maxRatio': serializer.toJson<int>(maxRatio),
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  CategoryRatioRange copyWith({
    String? productionTypeId,
    int? minRatio,
    int? maxRatio,
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? categoryId,
  }) => CategoryRatioRange(
    productionTypeId: productionTypeId ?? this.productionTypeId,
    minRatio: minRatio ?? this.minRatio,
    maxRatio: maxRatio ?? this.maxRatio,
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    categoryId: categoryId ?? this.categoryId,
  );
  CategoryRatioRange copyWithCompanion(CategoryRatioRangesCompanion data) {
    return CategoryRatioRange(
      productionTypeId: data.productionTypeId.present
          ? data.productionTypeId.value
          : this.productionTypeId,
      minRatio: data.minRatio.present ? data.minRatio.value : this.minRatio,
      maxRatio: data.maxRatio.present ? data.maxRatio.value : this.maxRatio,
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRatioRange(')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('minRatio: $minRatio, ')
          ..write('maxRatio: $maxRatio, ')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productionTypeId,
    minRatio,
    maxRatio,
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    categoryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRatioRange &&
          other.productionTypeId == this.productionTypeId &&
          other.minRatio == this.minRatio &&
          other.maxRatio == this.maxRatio &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.categoryId == this.categoryId);
}

class CategoryRatioRangesCompanion extends UpdateCompanion<CategoryRatioRange> {
  final Value<String> productionTypeId;
  final Value<int> minRatio;
  final Value<int> maxRatio;
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> categoryId;
  final Value<int> rowid;
  const CategoryRatioRangesCompanion({
    this.productionTypeId = const Value.absent(),
    this.minRatio = const Value.absent(),
    this.maxRatio = const Value.absent(),
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryRatioRangesCompanion.insert({
    required String productionTypeId,
    required int minRatio,
    required int maxRatio,
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String categoryId,
    this.rowid = const Value.absent(),
  }) : productionTypeId = Value(productionTypeId),
       minRatio = Value(minRatio),
       maxRatio = Value(maxRatio),
       id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       categoryId = Value(categoryId);
  static Insertable<CategoryRatioRange> custom({
    Expression<String>? productionTypeId,
    Expression<int>? minRatio,
    Expression<int>? maxRatio,
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productionTypeId != null) 'production_type_id': productionTypeId,
      if (minRatio != null) 'min_ratio': minRatio,
      if (maxRatio != null) 'max_ratio': maxRatio,
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryRatioRangesCompanion copyWith({
    Value<String>? productionTypeId,
    Value<int>? minRatio,
    Value<int>? maxRatio,
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? categoryId,
    Value<int>? rowid,
  }) {
    return CategoryRatioRangesCompanion(
      productionTypeId: productionTypeId ?? this.productionTypeId,
      minRatio: minRatio ?? this.minRatio,
      maxRatio: maxRatio ?? this.maxRatio,
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productionTypeId.present) {
      map['production_type_id'] = Variable<String>(productionTypeId.value);
    }
    if (minRatio.present) {
      map['min_ratio'] = Variable<int>(minRatio.value);
    }
    if (maxRatio.present) {
      map['max_ratio'] = Variable<int>(maxRatio.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRatioRangesCompanion(')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('minRatio: $minRatio, ')
          ..write('maxRatio: $maxRatio, ')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientRatioRangesTable extends IngredientRatioRanges
    with TableInfo<$IngredientRatioRangesTable, IngredientRatioRange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientRatioRangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productionTypeIdMeta = const VerificationMeta(
    'productionTypeId',
  );
  @override
  late final GeneratedColumn<String> productionTypeId = GeneratedColumn<String>(
    'production_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES production_types (id)',
    ),
  );
  static const VerificationMeta _minRatioMeta = const VerificationMeta(
    'minRatio',
  );
  @override
  late final GeneratedColumn<int> minRatio = GeneratedColumn<int>(
    'min_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxRatioMeta = const VerificationMeta(
    'maxRatio',
  );
  @override
  late final GeneratedColumn<int> maxRatio = GeneratedColumn<int>(
    'max_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    productionTypeId,
    minRatio,
    maxRatio,
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    ingredientId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_ratio_ranges';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientRatioRange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('production_type_id')) {
      context.handle(
        _productionTypeIdMeta,
        productionTypeId.isAcceptableOrUnknown(
          data['production_type_id']!,
          _productionTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productionTypeIdMeta);
    }
    if (data.containsKey('min_ratio')) {
      context.handle(
        _minRatioMeta,
        minRatio.isAcceptableOrUnknown(data['min_ratio']!, _minRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_minRatioMeta);
    }
    if (data.containsKey('max_ratio')) {
      context.handle(
        _maxRatioMeta,
        maxRatio.isAcceptableOrUnknown(data['max_ratio']!, _maxRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_maxRatioMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {ingredientId, productionTypeId},
  ];
  @override
  IngredientRatioRange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientRatioRange(
      productionTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}production_type_id'],
      )!,
      minRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_ratio'],
      )!,
      maxRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_ratio'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
    );
  }

  @override
  $IngredientRatioRangesTable createAlias(String alias) {
    return $IngredientRatioRangesTable(attachedDatabase, alias);
  }
}

class IngredientRatioRange extends DataClass
    implements Insertable<IngredientRatioRange> {
  final String productionTypeId;
  final int minRatio;
  final int maxRatio;
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String ingredientId;
  const IngredientRatioRange({
    required this.productionTypeId,
    required this.minRatio,
    required this.maxRatio,
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.ingredientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['production_type_id'] = Variable<String>(productionTypeId);
    map['min_ratio'] = Variable<int>(minRatio);
    map['max_ratio'] = Variable<int>(maxRatio);
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['ingredient_id'] = Variable<String>(ingredientId);
    return map;
  }

  IngredientRatioRangesCompanion toCompanion(bool nullToAbsent) {
    return IngredientRatioRangesCompanion(
      productionTypeId: Value(productionTypeId),
      minRatio: Value(minRatio),
      maxRatio: Value(maxRatio),
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      ingredientId: Value(ingredientId),
    );
  }

  factory IngredientRatioRange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientRatioRange(
      productionTypeId: serializer.fromJson<String>(json['productionTypeId']),
      minRatio: serializer.fromJson<int>(json['minRatio']),
      maxRatio: serializer.fromJson<int>(json['maxRatio']),
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productionTypeId': serializer.toJson<String>(productionTypeId),
      'minRatio': serializer.toJson<int>(minRatio),
      'maxRatio': serializer.toJson<int>(maxRatio),
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'ingredientId': serializer.toJson<String>(ingredientId),
    };
  }

  IngredientRatioRange copyWith({
    String? productionTypeId,
    int? minRatio,
    int? maxRatio,
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? ingredientId,
  }) => IngredientRatioRange(
    productionTypeId: productionTypeId ?? this.productionTypeId,
    minRatio: minRatio ?? this.minRatio,
    maxRatio: maxRatio ?? this.maxRatio,
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    ingredientId: ingredientId ?? this.ingredientId,
  );
  IngredientRatioRange copyWithCompanion(IngredientRatioRangesCompanion data) {
    return IngredientRatioRange(
      productionTypeId: data.productionTypeId.present
          ? data.productionTypeId.value
          : this.productionTypeId,
      minRatio: data.minRatio.present ? data.minRatio.value : this.minRatio,
      maxRatio: data.maxRatio.present ? data.maxRatio.value : this.maxRatio,
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientRatioRange(')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('minRatio: $minRatio, ')
          ..write('maxRatio: $maxRatio, ')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('ingredientId: $ingredientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productionTypeId,
    minRatio,
    maxRatio,
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    ingredientId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientRatioRange &&
          other.productionTypeId == this.productionTypeId &&
          other.minRatio == this.minRatio &&
          other.maxRatio == this.maxRatio &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.ingredientId == this.ingredientId);
}

class IngredientRatioRangesCompanion
    extends UpdateCompanion<IngredientRatioRange> {
  final Value<String> productionTypeId;
  final Value<int> minRatio;
  final Value<int> maxRatio;
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> ingredientId;
  final Value<int> rowid;
  const IngredientRatioRangesCompanion({
    this.productionTypeId = const Value.absent(),
    this.minRatio = const Value.absent(),
    this.maxRatio = const Value.absent(),
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientRatioRangesCompanion.insert({
    required String productionTypeId,
    required int minRatio,
    required int maxRatio,
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String ingredientId,
    this.rowid = const Value.absent(),
  }) : productionTypeId = Value(productionTypeId),
       minRatio = Value(minRatio),
       maxRatio = Value(maxRatio),
       id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       ingredientId = Value(ingredientId);
  static Insertable<IngredientRatioRange> custom({
    Expression<String>? productionTypeId,
    Expression<int>? minRatio,
    Expression<int>? maxRatio,
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? ingredientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productionTypeId != null) 'production_type_id': productionTypeId,
      if (minRatio != null) 'min_ratio': minRatio,
      if (maxRatio != null) 'max_ratio': maxRatio,
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientRatioRangesCompanion copyWith({
    Value<String>? productionTypeId,
    Value<int>? minRatio,
    Value<int>? maxRatio,
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? ingredientId,
    Value<int>? rowid,
  }) {
    return IngredientRatioRangesCompanion(
      productionTypeId: productionTypeId ?? this.productionTypeId,
      minRatio: minRatio ?? this.minRatio,
      maxRatio: maxRatio ?? this.maxRatio,
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      ingredientId: ingredientId ?? this.ingredientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productionTypeId.present) {
      map['production_type_id'] = Variable<String>(productionTypeId.value);
    }
    if (minRatio.present) {
      map['min_ratio'] = Variable<int>(minRatio.value);
    }
    if (maxRatio.present) {
      map['max_ratio'] = Variable<int>(maxRatio.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientRatioRangesCompanion(')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('minRatio: $minRatio, ')
          ..write('maxRatio: $maxRatio, ')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkuRatioOverridesTable extends SkuRatioOverrides
    with TableInfo<$SkuRatioOverridesTable, SkuRatioOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkuRatioOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productionTypeIdMeta = const VerificationMeta(
    'productionTypeId',
  );
  @override
  late final GeneratedColumn<String> productionTypeId = GeneratedColumn<String>(
    'production_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES production_types (id)',
    ),
  );
  static const VerificationMeta _minRatioMeta = const VerificationMeta(
    'minRatio',
  );
  @override
  late final GeneratedColumn<int> minRatio = GeneratedColumn<int>(
    'min_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxRatioMeta = const VerificationMeta(
    'maxRatio',
  );
  @override
  late final GeneratedColumn<int> maxRatio = GeneratedColumn<int>(
    'max_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skuIdMeta = const VerificationMeta('skuId');
  @override
  late final GeneratedColumn<String> skuId = GeneratedColumn<String>(
    'sku_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredient_skus (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    productionTypeId,
    minRatio,
    maxRatio,
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    skuId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sku_ratio_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<SkuRatioOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('production_type_id')) {
      context.handle(
        _productionTypeIdMeta,
        productionTypeId.isAcceptableOrUnknown(
          data['production_type_id']!,
          _productionTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productionTypeIdMeta);
    }
    if (data.containsKey('min_ratio')) {
      context.handle(
        _minRatioMeta,
        minRatio.isAcceptableOrUnknown(data['min_ratio']!, _minRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_minRatioMeta);
    }
    if (data.containsKey('max_ratio')) {
      context.handle(
        _maxRatioMeta,
        maxRatio.isAcceptableOrUnknown(data['max_ratio']!, _maxRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_maxRatioMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('sku_id')) {
      context.handle(
        _skuIdMeta,
        skuId.isAcceptableOrUnknown(data['sku_id']!, _skuIdMeta),
      );
    } else if (isInserting) {
      context.missing(_skuIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {skuId, productionTypeId},
  ];
  @override
  SkuRatioOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkuRatioOverride(
      productionTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}production_type_id'],
      )!,
      minRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_ratio'],
      )!,
      maxRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_ratio'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      skuId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku_id'],
      )!,
    );
  }

  @override
  $SkuRatioOverridesTable createAlias(String alias) {
    return $SkuRatioOverridesTable(attachedDatabase, alias);
  }
}

class SkuRatioOverride extends DataClass
    implements Insertable<SkuRatioOverride> {
  final String productionTypeId;
  final int minRatio;
  final int maxRatio;
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String skuId;
  const SkuRatioOverride({
    required this.productionTypeId,
    required this.minRatio,
    required this.maxRatio,
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.skuId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['production_type_id'] = Variable<String>(productionTypeId);
    map['min_ratio'] = Variable<int>(minRatio);
    map['max_ratio'] = Variable<int>(maxRatio);
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['sku_id'] = Variable<String>(skuId);
    return map;
  }

  SkuRatioOverridesCompanion toCompanion(bool nullToAbsent) {
    return SkuRatioOverridesCompanion(
      productionTypeId: Value(productionTypeId),
      minRatio: Value(minRatio),
      maxRatio: Value(maxRatio),
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      skuId: Value(skuId),
    );
  }

  factory SkuRatioOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkuRatioOverride(
      productionTypeId: serializer.fromJson<String>(json['productionTypeId']),
      minRatio: serializer.fromJson<int>(json['minRatio']),
      maxRatio: serializer.fromJson<int>(json['maxRatio']),
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      skuId: serializer.fromJson<String>(json['skuId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productionTypeId': serializer.toJson<String>(productionTypeId),
      'minRatio': serializer.toJson<int>(minRatio),
      'maxRatio': serializer.toJson<int>(maxRatio),
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'skuId': serializer.toJson<String>(skuId),
    };
  }

  SkuRatioOverride copyWith({
    String? productionTypeId,
    int? minRatio,
    int? maxRatio,
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? skuId,
  }) => SkuRatioOverride(
    productionTypeId: productionTypeId ?? this.productionTypeId,
    minRatio: minRatio ?? this.minRatio,
    maxRatio: maxRatio ?? this.maxRatio,
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    skuId: skuId ?? this.skuId,
  );
  SkuRatioOverride copyWithCompanion(SkuRatioOverridesCompanion data) {
    return SkuRatioOverride(
      productionTypeId: data.productionTypeId.present
          ? data.productionTypeId.value
          : this.productionTypeId,
      minRatio: data.minRatio.present ? data.minRatio.value : this.minRatio,
      maxRatio: data.maxRatio.present ? data.maxRatio.value : this.maxRatio,
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      skuId: data.skuId.present ? data.skuId.value : this.skuId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkuRatioOverride(')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('minRatio: $minRatio, ')
          ..write('maxRatio: $maxRatio, ')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('skuId: $skuId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productionTypeId,
    minRatio,
    maxRatio,
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    skuId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkuRatioOverride &&
          other.productionTypeId == this.productionTypeId &&
          other.minRatio == this.minRatio &&
          other.maxRatio == this.maxRatio &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.skuId == this.skuId);
}

class SkuRatioOverridesCompanion extends UpdateCompanion<SkuRatioOverride> {
  final Value<String> productionTypeId;
  final Value<int> minRatio;
  final Value<int> maxRatio;
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> skuId;
  final Value<int> rowid;
  const SkuRatioOverridesCompanion({
    this.productionTypeId = const Value.absent(),
    this.minRatio = const Value.absent(),
    this.maxRatio = const Value.absent(),
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.skuId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkuRatioOverridesCompanion.insert({
    required String productionTypeId,
    required int minRatio,
    required int maxRatio,
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String skuId,
    this.rowid = const Value.absent(),
  }) : productionTypeId = Value(productionTypeId),
       minRatio = Value(minRatio),
       maxRatio = Value(maxRatio),
       id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       skuId = Value(skuId);
  static Insertable<SkuRatioOverride> custom({
    Expression<String>? productionTypeId,
    Expression<int>? minRatio,
    Expression<int>? maxRatio,
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? skuId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productionTypeId != null) 'production_type_id': productionTypeId,
      if (minRatio != null) 'min_ratio': minRatio,
      if (maxRatio != null) 'max_ratio': maxRatio,
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (skuId != null) 'sku_id': skuId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkuRatioOverridesCompanion copyWith({
    Value<String>? productionTypeId,
    Value<int>? minRatio,
    Value<int>? maxRatio,
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? skuId,
    Value<int>? rowid,
  }) {
    return SkuRatioOverridesCompanion(
      productionTypeId: productionTypeId ?? this.productionTypeId,
      minRatio: minRatio ?? this.minRatio,
      maxRatio: maxRatio ?? this.maxRatio,
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      skuId: skuId ?? this.skuId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productionTypeId.present) {
      map['production_type_id'] = Variable<String>(productionTypeId.value);
    }
    if (minRatio.present) {
      map['min_ratio'] = Variable<int>(minRatio.value);
    }
    if (maxRatio.present) {
      map['max_ratio'] = Variable<int>(maxRatio.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (skuId.present) {
      map['sku_id'] = Variable<String>(skuId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkuRatioOverridesCompanion(')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('minRatio: $minRatio, ')
          ..write('maxRatio: $maxRatio, ')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('skuId: $skuId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecommendationPresetsTable extends RecommendationPresets
    with TableInfo<$RecommendationPresetsTable, RecommendationPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecommendationPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productionTypeIdMeta = const VerificationMeta(
    'productionTypeId',
  );
  @override
  late final GeneratedColumn<String> productionTypeId = GeneratedColumn<String>(
    'production_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES production_types (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    productionTypeId,
    name,
    notes,
    sortOrder,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recommendation_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecommendationPreset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('production_type_id')) {
      context.handle(
        _productionTypeIdMeta,
        productionTypeId.isAcceptableOrUnknown(
          data['production_type_id']!,
          _productionTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productionTypeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecommendationPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecommendationPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      productionTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}production_type_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $RecommendationPresetsTable createAlias(String alias) {
    return $RecommendationPresetsTable(attachedDatabase, alias);
  }
}

class RecommendationPreset extends DataClass
    implements Insertable<RecommendationPreset> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String productionTypeId;
  final String name;
  final String? notes;
  final int sortOrder;
  final bool isInactive;
  const RecommendationPreset({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.productionTypeId,
    required this.name,
    this.notes,
    required this.sortOrder,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['production_type_id'] = Variable<String>(productionTypeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  RecommendationPresetsCompanion toCompanion(bool nullToAbsent) {
    return RecommendationPresetsCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      productionTypeId: Value(productionTypeId),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      isInactive: Value(isInactive),
    );
  }

  factory RecommendationPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecommendationPreset(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      productionTypeId: serializer.fromJson<String>(json['productionTypeId']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'productionTypeId': serializer.toJson<String>(productionTypeId),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  RecommendationPreset copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? productionTypeId,
    String? name,
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    bool? isInactive,
  }) => RecommendationPreset(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    productionTypeId: productionTypeId ?? this.productionTypeId,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    isInactive: isInactive ?? this.isInactive,
  );
  RecommendationPreset copyWithCompanion(RecommendationPresetsCompanion data) {
    return RecommendationPreset(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      productionTypeId: data.productionTypeId.present
          ? data.productionTypeId.value
          : this.productionTypeId,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationPreset(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    productionTypeId,
    name,
    notes,
    sortOrder,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecommendationPreset &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.productionTypeId == this.productionTypeId &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.isInactive == this.isInactive);
}

class RecommendationPresetsCompanion
    extends UpdateCompanion<RecommendationPreset> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> productionTypeId;
  final Value<String> name;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const RecommendationPresetsCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.productionTypeId = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecommendationPresetsCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String productionTypeId,
    required String name,
    this.notes = const Value.absent(),
    required int sortOrder,
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       productionTypeId = Value(productionTypeId),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<RecommendationPreset> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? productionTypeId,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (productionTypeId != null) 'production_type_id': productionTypeId,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecommendationPresetsCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? productionTypeId,
    Value<String>? name,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return RecommendationPresetsCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      productionTypeId: productionTypeId ?? this.productionTypeId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (productionTypeId.present) {
      map['production_type_id'] = Variable<String>(productionTypeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationPresetsCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('productionTypeId: $productionTypeId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecommendationGroupsTable extends RecommendationGroups
    with TableInfo<$RecommendationGroupsTable, RecommendationGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecommendationGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presetIdMeta = const VerificationMeta(
    'presetId',
  );
  @override
  late final GeneratedColumn<String> presetId = GeneratedColumn<String>(
    'preset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recommendation_presets (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredient_categories (id)',
    ),
  );
  static const VerificationMeta _ratioMeta = const VerificationMeta('ratio');
  @override
  late final GeneratedColumn<int> ratio = GeneratedColumn<int>(
    'ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (ratio BETWEEN 0 AND 10000)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    presetId,
    categoryId,
    ratio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recommendation_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecommendationGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('preset_id')) {
      context.handle(
        _presetIdMeta,
        presetId.isAcceptableOrUnknown(data['preset_id']!, _presetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_presetIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('ratio')) {
      context.handle(
        _ratioMeta,
        ratio.isAcceptableOrUnknown(data['ratio']!, _ratioMeta),
      );
    } else if (isInserting) {
      context.missing(_ratioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {presetId, categoryId},
  ];
  @override
  RecommendationGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecommendationGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      presetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preset_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      ratio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ratio'],
      )!,
    );
  }

  @override
  $RecommendationGroupsTable createAlias(String alias) {
    return $RecommendationGroupsTable(attachedDatabase, alias);
  }
}

class RecommendationGroup extends DataClass
    implements Insertable<RecommendationGroup> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String presetId;
  final String categoryId;
  final int ratio;
  const RecommendationGroup({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.presetId,
    required this.categoryId,
    required this.ratio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['preset_id'] = Variable<String>(presetId);
    map['category_id'] = Variable<String>(categoryId);
    map['ratio'] = Variable<int>(ratio);
    return map;
  }

  RecommendationGroupsCompanion toCompanion(bool nullToAbsent) {
    return RecommendationGroupsCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      presetId: Value(presetId),
      categoryId: Value(categoryId),
      ratio: Value(ratio),
    );
  }

  factory RecommendationGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecommendationGroup(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      presetId: serializer.fromJson<String>(json['presetId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      ratio: serializer.fromJson<int>(json['ratio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'presetId': serializer.toJson<String>(presetId),
      'categoryId': serializer.toJson<String>(categoryId),
      'ratio': serializer.toJson<int>(ratio),
    };
  }

  RecommendationGroup copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? presetId,
    String? categoryId,
    int? ratio,
  }) => RecommendationGroup(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    presetId: presetId ?? this.presetId,
    categoryId: categoryId ?? this.categoryId,
    ratio: ratio ?? this.ratio,
  );
  RecommendationGroup copyWithCompanion(RecommendationGroupsCompanion data) {
    return RecommendationGroup(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      presetId: data.presetId.present ? data.presetId.value : this.presetId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      ratio: data.ratio.present ? data.ratio.value : this.ratio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationGroup(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('presetId: $presetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('ratio: $ratio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    presetId,
    categoryId,
    ratio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecommendationGroup &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.presetId == this.presetId &&
          other.categoryId == this.categoryId &&
          other.ratio == this.ratio);
}

class RecommendationGroupsCompanion
    extends UpdateCompanion<RecommendationGroup> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> presetId;
  final Value<String> categoryId;
  final Value<int> ratio;
  final Value<int> rowid;
  const RecommendationGroupsCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.presetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.ratio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecommendationGroupsCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String presetId,
    required String categoryId,
    required int ratio,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       presetId = Value(presetId),
       categoryId = Value(categoryId),
       ratio = Value(ratio);
  static Insertable<RecommendationGroup> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? presetId,
    Expression<String>? categoryId,
    Expression<int>? ratio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (presetId != null) 'preset_id': presetId,
      if (categoryId != null) 'category_id': categoryId,
      if (ratio != null) 'ratio': ratio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecommendationGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? presetId,
    Value<String>? categoryId,
    Value<int>? ratio,
    Value<int>? rowid,
  }) {
    return RecommendationGroupsCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      presetId: presetId ?? this.presetId,
      categoryId: categoryId ?? this.categoryId,
      ratio: ratio ?? this.ratio,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (presetId.present) {
      map['preset_id'] = Variable<String>(presetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (ratio.present) {
      map['ratio'] = Variable<int>(ratio.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationGroupsCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('presetId: $presetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('ratio: $ratio, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecommendationItemsTable extends RecommendationItems
    with TableInfo<$RecommendationItemsTable, RecommendationItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecommendationItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recommendation_groups (id)',
    ),
  );
  static const VerificationMeta _skuIdMeta = const VerificationMeta('skuId');
  @override
  late final GeneratedColumn<String> skuId = GeneratedColumn<String>(
    'sku_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredient_skus (id)',
    ),
  );
  static const VerificationMeta _ratioMeta = const VerificationMeta('ratio');
  @override
  late final GeneratedColumn<int> ratio = GeneratedColumn<int>(
    'ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (ratio BETWEEN 0 AND 10000)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    groupId,
    skuId,
    ratio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recommendation_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecommendationItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('sku_id')) {
      context.handle(
        _skuIdMeta,
        skuId.isAcceptableOrUnknown(data['sku_id']!, _skuIdMeta),
      );
    } else if (isInserting) {
      context.missing(_skuIdMeta);
    }
    if (data.containsKey('ratio')) {
      context.handle(
        _ratioMeta,
        ratio.isAcceptableOrUnknown(data['ratio']!, _ratioMeta),
      );
    } else if (isInserting) {
      context.missing(_ratioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, skuId},
  ];
  @override
  RecommendationItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecommendationItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      skuId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku_id'],
      )!,
      ratio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ratio'],
      )!,
    );
  }

  @override
  $RecommendationItemsTable createAlias(String alias) {
    return $RecommendationItemsTable(attachedDatabase, alias);
  }
}

class RecommendationItem extends DataClass
    implements Insertable<RecommendationItem> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String groupId;
  final String skuId;
  final int ratio;
  const RecommendationItem({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.groupId,
    required this.skuId,
    required this.ratio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['group_id'] = Variable<String>(groupId);
    map['sku_id'] = Variable<String>(skuId);
    map['ratio'] = Variable<int>(ratio);
    return map;
  }

  RecommendationItemsCompanion toCompanion(bool nullToAbsent) {
    return RecommendationItemsCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      groupId: Value(groupId),
      skuId: Value(skuId),
      ratio: Value(ratio),
    );
  }

  factory RecommendationItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecommendationItem(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      groupId: serializer.fromJson<String>(json['groupId']),
      skuId: serializer.fromJson<String>(json['skuId']),
      ratio: serializer.fromJson<int>(json['ratio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'groupId': serializer.toJson<String>(groupId),
      'skuId': serializer.toJson<String>(skuId),
      'ratio': serializer.toJson<int>(ratio),
    };
  }

  RecommendationItem copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? groupId,
    String? skuId,
    int? ratio,
  }) => RecommendationItem(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    groupId: groupId ?? this.groupId,
    skuId: skuId ?? this.skuId,
    ratio: ratio ?? this.ratio,
  );
  RecommendationItem copyWithCompanion(RecommendationItemsCompanion data) {
    return RecommendationItem(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      skuId: data.skuId.present ? data.skuId.value : this.skuId,
      ratio: data.ratio.present ? data.ratio.value : this.ratio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationItem(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('groupId: $groupId, ')
          ..write('skuId: $skuId, ')
          ..write('ratio: $ratio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    groupId,
    skuId,
    ratio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecommendationItem &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.groupId == this.groupId &&
          other.skuId == this.skuId &&
          other.ratio == this.ratio);
}

class RecommendationItemsCompanion extends UpdateCompanion<RecommendationItem> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> groupId;
  final Value<String> skuId;
  final Value<int> ratio;
  final Value<int> rowid;
  const RecommendationItemsCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.groupId = const Value.absent(),
    this.skuId = const Value.absent(),
    this.ratio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecommendationItemsCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String groupId,
    required String skuId,
    required int ratio,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       groupId = Value(groupId),
       skuId = Value(skuId),
       ratio = Value(ratio);
  static Insertable<RecommendationItem> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? groupId,
    Expression<String>? skuId,
    Expression<int>? ratio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (groupId != null) 'group_id': groupId,
      if (skuId != null) 'sku_id': skuId,
      if (ratio != null) 'ratio': ratio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecommendationItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? groupId,
    Value<String>? skuId,
    Value<int>? ratio,
    Value<int>? rowid,
  }) {
    return RecommendationItemsCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      groupId: groupId ?? this.groupId,
      skuId: skuId ?? this.skuId,
      ratio: ratio ?? this.ratio,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (skuId.present) {
      map['sku_id'] = Variable<String>(skuId.value);
    }
    if (ratio.present) {
      map['ratio'] = Variable<int>(ratio.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationItemsCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('groupId: $groupId, ')
          ..write('skuId: $skuId, ')
          ..write('ratio: $ratio, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    phone,
    notes,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String name;
  final String phone;
  final String? notes;
  final DateTime createdAtUtc;
  const Customer({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.name,
    required this.phone,
    this.notes,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      name: Value(name),
      phone: Value(phone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'notes': serializer.toJson<String?>(notes),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  Customer copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? name,
    String? phone,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAtUtc,
  }) => Customer(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    notes: notes.present ? notes.value : this.notes,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    phone,
    notes,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.notes == this.notes &&
          other.createdAtUtc == this.createdAtUtc);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> notes;
  final Value<DateTime> createdAtUtc;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<DateTime>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? name,
    Value<String>? phone,
    Value<String?>? notes,
    Value<DateTime>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaqueTypesTable extends PlaqueTypes
    with TableInfo<$PlaqueTypesTable, PlaqueType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaqueTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageHashMeta = const VerificationMeta(
    'imageHash',
  );
  @override
  late final GeneratedColumn<String> imageHash = GeneratedColumn<String>(
    'image_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specificationMeta = const VerificationMeta(
    'specification',
  );
  @override
  late final GeneratedColumn<String> specification = GeneratedColumn<String>(
    'specification',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    imageHash,
    specification,
    notes,
    sortOrder,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plaque_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaqueType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_hash')) {
      context.handle(
        _imageHashMeta,
        imageHash.isAcceptableOrUnknown(data['image_hash']!, _imageHashMeta),
      );
    }
    if (data.containsKey('specification')) {
      context.handle(
        _specificationMeta,
        specification.isAcceptableOrUnknown(
          data['specification']!,
          _specificationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaqueType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaqueType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_hash'],
      ),
      specification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specification'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $PlaqueTypesTable createAlias(String alias) {
    return $PlaqueTypesTable(attachedDatabase, alias);
  }
}

class PlaqueType extends DataClass implements Insertable<PlaqueType> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String name;
  final String? imageHash;
  final String? specification;
  final String? notes;
  final int sortOrder;
  final bool isInactive;
  const PlaqueType({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.name,
    this.imageHash,
    this.specification,
    this.notes,
    required this.sortOrder,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageHash != null) {
      map['image_hash'] = Variable<String>(imageHash);
    }
    if (!nullToAbsent || specification != null) {
      map['specification'] = Variable<String>(specification);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  PlaqueTypesCompanion toCompanion(bool nullToAbsent) {
    return PlaqueTypesCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      name: Value(name),
      imageHash: imageHash == null && nullToAbsent
          ? const Value.absent()
          : Value(imageHash),
      specification: specification == null && nullToAbsent
          ? const Value.absent()
          : Value(specification),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      isInactive: Value(isInactive),
    );
  }

  factory PlaqueType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaqueType(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      name: serializer.fromJson<String>(json['name']),
      imageHash: serializer.fromJson<String?>(json['imageHash']),
      specification: serializer.fromJson<String?>(json['specification']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'name': serializer.toJson<String>(name),
      'imageHash': serializer.toJson<String?>(imageHash),
      'specification': serializer.toJson<String?>(specification),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  PlaqueType copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? name,
    Value<String?> imageHash = const Value.absent(),
    Value<String?> specification = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    bool? isInactive,
  }) => PlaqueType(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    name: name ?? this.name,
    imageHash: imageHash.present ? imageHash.value : this.imageHash,
    specification: specification.present
        ? specification.value
        : this.specification,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    isInactive: isInactive ?? this.isInactive,
  );
  PlaqueType copyWithCompanion(PlaqueTypesCompanion data) {
    return PlaqueType(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      name: data.name.present ? data.name.value : this.name,
      imageHash: data.imageHash.present ? data.imageHash.value : this.imageHash,
      specification: data.specification.present
          ? data.specification.value
          : this.specification,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaqueType(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('imageHash: $imageHash, ')
          ..write('specification: $specification, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    imageHash,
    specification,
    notes,
    sortOrder,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaqueType &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.name == this.name &&
          other.imageHash == this.imageHash &&
          other.specification == this.specification &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.isInactive == this.isInactive);
}

class PlaqueTypesCompanion extends UpdateCompanion<PlaqueType> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> name;
  final Value<String?> imageHash;
  final Value<String?> specification;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const PlaqueTypesCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.imageHash = const Value.absent(),
    this.specification = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaqueTypesCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String name,
    this.imageHash = const Value.absent(),
    this.specification = const Value.absent(),
    this.notes = const Value.absent(),
    required int sortOrder,
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<PlaqueType> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? name,
    Expression<String>? imageHash,
    Expression<String>? specification,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (name != null) 'name': name,
      if (imageHash != null) 'image_hash': imageHash,
      if (specification != null) 'specification': specification,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaqueTypesCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? name,
    Value<String?>? imageHash,
    Value<String?>? specification,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return PlaqueTypesCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      name: name ?? this.name,
      imageHash: imageHash ?? this.imageHash,
      specification: specification ?? this.specification,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageHash.present) {
      map['image_hash'] = Variable<String>(imageHash.value);
    }
    if (specification.present) {
      map['specification'] = Variable<String>(specification.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaqueTypesCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('imageHash: $imageHash, ')
          ..write('specification: $specification, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetCategoriesTable extends AssetCategories
    with TableInfo<$AssetCategoriesTable, AssetCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $AssetCategoriesTable createAlias(String alias) {
    return $AssetCategoriesTable(attachedDatabase, alias);
  }
}

class AssetCategory extends DataClass implements Insertable<AssetCategory> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String name;
  final int sortOrder;
  final bool isInactive;
  const AssetCategory({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.name,
    required this.sortOrder,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  AssetCategoriesCompanion toCompanion(bool nullToAbsent) {
    return AssetCategoriesCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isInactive: Value(isInactive),
    );
  }

  factory AssetCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetCategory(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  AssetCategory copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? name,
    int? sortOrder,
    bool? isInactive,
  }) => AssetCategory(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isInactive: isInactive ?? this.isInactive,
  );
  AssetCategory copyWithCompanion(AssetCategoriesCompanion data) {
    return AssetCategory(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetCategory(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetCategory &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isInactive == this.isInactive);
}

class AssetCategoriesCompanion extends UpdateCompanion<AssetCategory> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const AssetCategoriesCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetCategoriesCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String name,
    required int sortOrder,
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<AssetCategory> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return AssetCategoriesCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetStatusesTable extends AssetStatuses
    with TableInfo<$AssetStatusesTable, AssetStatuse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetStatuse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetStatuse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetStatuse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $AssetStatusesTable createAlias(String alias) {
    return $AssetStatusesTable(attachedDatabase, alias);
  }
}

class AssetStatuse extends DataClass implements Insertable<AssetStatuse> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String name;
  final int sortOrder;
  final bool isInactive;
  const AssetStatuse({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.name,
    required this.sortOrder,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  AssetStatusesCompanion toCompanion(bool nullToAbsent) {
    return AssetStatusesCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isInactive: Value(isInactive),
    );
  }

  factory AssetStatuse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetStatuse(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  AssetStatuse copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? name,
    int? sortOrder,
    bool? isInactive,
  }) => AssetStatuse(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isInactive: isInactive ?? this.isInactive,
  );
  AssetStatuse copyWithCompanion(AssetStatusesCompanion data) {
    return AssetStatuse(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetStatuse(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    name,
    sortOrder,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetStatuse &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isInactive == this.isInactive);
}

class AssetStatusesCompanion extends UpdateCompanion<AssetStatuse> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const AssetStatusesCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetStatusesCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String name,
    required int sortOrder,
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<AssetStatuse> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetStatusesCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return AssetStatusesCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetStatusesCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByDeviceMeta = const VerificationMeta(
    'updatedByDevice',
  );
  @override
  late final GeneratedColumn<String> updatedByDevice = GeneratedColumn<String>(
    'updated_by_device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtUtc = GeneratedColumn<DateTime>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES asset_categories (id)',
    ),
  );
  static const VerificationMeta _statusIdMeta = const VerificationMeta(
    'statusId',
  );
  @override
  late final GeneratedColumn<String> statusId = GeneratedColumn<String>(
    'status_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES asset_statuses (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageHashMeta = const VerificationMeta(
    'imageHash',
  );
  @override
  late final GeneratedColumn<String> imageHash = GeneratedColumn<String>(
    'image_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (quantity >= 0)',
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseUrlMeta = const VerificationMeta(
    'purchaseUrl',
  );
  @override
  late final GeneratedColumn<String> purchaseUrl = GeneratedColumn<String>(
    'purchase_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastCountedAtUtcMeta = const VerificationMeta(
    'lastCountedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> lastCountedAtUtc =
      GeneratedColumn<DateTime>(
        'last_counted_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isInactiveMeta = const VerificationMeta(
    'isInactive',
  );
  @override
  late final GeneratedColumn<bool> isInactive = GeneratedColumn<bool>(
    'is_inactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    categoryId,
    statusId,
    name,
    imageHash,
    quantity,
    location,
    purchaseUrl,
    notes,
    lastCountedAtUtc,
    isInactive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Asset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('updated_by_device')) {
      context.handle(
        _updatedByDeviceMeta,
        updatedByDevice.isAcceptableOrUnknown(
          data['updated_by_device']!,
          _updatedByDeviceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedByDeviceMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('status_id')) {
      context.handle(
        _statusIdMeta,
        statusId.isAcceptableOrUnknown(data['status_id']!, _statusIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_hash')) {
      context.handle(
        _imageHashMeta,
        imageHash.isAcceptableOrUnknown(data['image_hash']!, _imageHashMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('purchase_url')) {
      context.handle(
        _purchaseUrlMeta,
        purchaseUrl.isAcceptableOrUnknown(
          data['purchase_url']!,
          _purchaseUrlMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('last_counted_at_utc')) {
      context.handle(
        _lastCountedAtUtcMeta,
        lastCountedAtUtc.isAcceptableOrUnknown(
          data['last_counted_at_utc']!,
          _lastCountedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('is_inactive')) {
      context.handle(
        _isInactiveMeta,
        isInactive.isAcceptableOrUnknown(data['is_inactive']!, _isInactiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      updatedByDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_device'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      statusId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_hash'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      purchaseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      lastCountedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_counted_at_utc'],
      ),
      isInactive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inactive'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final String revisionId;
  final String updatedByDevice;
  final DateTime updatedAtUtc;
  final bool isDeleted;
  final DateTime? deletedAtUtc;
  final String categoryId;
  final String? statusId;
  final String name;
  final String? imageHash;
  final int quantity;
  final String? location;
  final String? purchaseUrl;
  final String? notes;
  final DateTime? lastCountedAtUtc;
  final bool isInactive;
  const Asset({
    required this.id,
    required this.revisionId,
    required this.updatedByDevice,
    required this.updatedAtUtc,
    required this.isDeleted,
    this.deletedAtUtc,
    required this.categoryId,
    this.statusId,
    required this.name,
    this.imageHash,
    required this.quantity,
    this.location,
    this.purchaseUrl,
    this.notes,
    this.lastCountedAtUtc,
    required this.isInactive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['updated_by_device'] = Variable<String>(updatedByDevice);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc);
    }
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || statusId != null) {
      map['status_id'] = Variable<String>(statusId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageHash != null) {
      map['image_hash'] = Variable<String>(imageHash);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || purchaseUrl != null) {
      map['purchase_url'] = Variable<String>(purchaseUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || lastCountedAtUtc != null) {
      map['last_counted_at_utc'] = Variable<DateTime>(lastCountedAtUtc);
    }
    map['is_inactive'] = Variable<bool>(isInactive);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      updatedByDevice: Value(updatedByDevice),
      updatedAtUtc: Value(updatedAtUtc),
      isDeleted: Value(isDeleted),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      categoryId: Value(categoryId),
      statusId: statusId == null && nullToAbsent
          ? const Value.absent()
          : Value(statusId),
      name: Value(name),
      imageHash: imageHash == null && nullToAbsent
          ? const Value.absent()
          : Value(imageHash),
      quantity: Value(quantity),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      purchaseUrl: purchaseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      lastCountedAtUtc: lastCountedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCountedAtUtc),
      isInactive: Value(isInactive),
    );
  }

  factory Asset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      updatedByDevice: serializer.fromJson<String>(json['updatedByDevice']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAtUtc: serializer.fromJson<DateTime?>(json['deletedAtUtc']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      statusId: serializer.fromJson<String?>(json['statusId']),
      name: serializer.fromJson<String>(json['name']),
      imageHash: serializer.fromJson<String?>(json['imageHash']),
      quantity: serializer.fromJson<int>(json['quantity']),
      location: serializer.fromJson<String?>(json['location']),
      purchaseUrl: serializer.fromJson<String?>(json['purchaseUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      lastCountedAtUtc: serializer.fromJson<DateTime?>(
        json['lastCountedAtUtc'],
      ),
      isInactive: serializer.fromJson<bool>(json['isInactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'updatedByDevice': serializer.toJson<String>(updatedByDevice),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAtUtc': serializer.toJson<DateTime?>(deletedAtUtc),
      'categoryId': serializer.toJson<String>(categoryId),
      'statusId': serializer.toJson<String?>(statusId),
      'name': serializer.toJson<String>(name),
      'imageHash': serializer.toJson<String?>(imageHash),
      'quantity': serializer.toJson<int>(quantity),
      'location': serializer.toJson<String?>(location),
      'purchaseUrl': serializer.toJson<String?>(purchaseUrl),
      'notes': serializer.toJson<String?>(notes),
      'lastCountedAtUtc': serializer.toJson<DateTime?>(lastCountedAtUtc),
      'isInactive': serializer.toJson<bool>(isInactive),
    };
  }

  Asset copyWith({
    String? id,
    String? revisionId,
    String? updatedByDevice,
    DateTime? updatedAtUtc,
    bool? isDeleted,
    Value<DateTime?> deletedAtUtc = const Value.absent(),
    String? categoryId,
    Value<String?> statusId = const Value.absent(),
    String? name,
    Value<String?> imageHash = const Value.absent(),
    int? quantity,
    Value<String?> location = const Value.absent(),
    Value<String?> purchaseUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> lastCountedAtUtc = const Value.absent(),
    bool? isInactive,
  }) => Asset(
    id: id ?? this.id,
    revisionId: revisionId ?? this.revisionId,
    updatedByDevice: updatedByDevice ?? this.updatedByDevice,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    categoryId: categoryId ?? this.categoryId,
    statusId: statusId.present ? statusId.value : this.statusId,
    name: name ?? this.name,
    imageHash: imageHash.present ? imageHash.value : this.imageHash,
    quantity: quantity ?? this.quantity,
    location: location.present ? location.value : this.location,
    purchaseUrl: purchaseUrl.present ? purchaseUrl.value : this.purchaseUrl,
    notes: notes.present ? notes.value : this.notes,
    lastCountedAtUtc: lastCountedAtUtc.present
        ? lastCountedAtUtc.value
        : this.lastCountedAtUtc,
    isInactive: isInactive ?? this.isInactive,
  );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      updatedByDevice: data.updatedByDevice.present
          ? data.updatedByDevice.value
          : this.updatedByDevice,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      statusId: data.statusId.present ? data.statusId.value : this.statusId,
      name: data.name.present ? data.name.value : this.name,
      imageHash: data.imageHash.present ? data.imageHash.value : this.imageHash,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      location: data.location.present ? data.location.value : this.location,
      purchaseUrl: data.purchaseUrl.present
          ? data.purchaseUrl.value
          : this.purchaseUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      lastCountedAtUtc: data.lastCountedAtUtc.present
          ? data.lastCountedAtUtc.value
          : this.lastCountedAtUtc,
      isInactive: data.isInactive.present
          ? data.isInactive.value
          : this.isInactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('categoryId: $categoryId, ')
          ..write('statusId: $statusId, ')
          ..write('name: $name, ')
          ..write('imageHash: $imageHash, ')
          ..write('quantity: $quantity, ')
          ..write('location: $location, ')
          ..write('purchaseUrl: $purchaseUrl, ')
          ..write('notes: $notes, ')
          ..write('lastCountedAtUtc: $lastCountedAtUtc, ')
          ..write('isInactive: $isInactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revisionId,
    updatedByDevice,
    updatedAtUtc,
    isDeleted,
    deletedAtUtc,
    categoryId,
    statusId,
    name,
    imageHash,
    quantity,
    location,
    purchaseUrl,
    notes,
    lastCountedAtUtc,
    isInactive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.updatedByDevice == this.updatedByDevice &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.isDeleted == this.isDeleted &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.categoryId == this.categoryId &&
          other.statusId == this.statusId &&
          other.name == this.name &&
          other.imageHash == this.imageHash &&
          other.quantity == this.quantity &&
          other.location == this.location &&
          other.purchaseUrl == this.purchaseUrl &&
          other.notes == this.notes &&
          other.lastCountedAtUtc == this.lastCountedAtUtc &&
          other.isInactive == this.isInactive);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<String> updatedByDevice;
  final Value<DateTime> updatedAtUtc;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAtUtc;
  final Value<String> categoryId;
  final Value<String?> statusId;
  final Value<String> name;
  final Value<String?> imageHash;
  final Value<int> quantity;
  final Value<String?> location;
  final Value<String?> purchaseUrl;
  final Value<String?> notes;
  final Value<DateTime?> lastCountedAtUtc;
  final Value<bool> isInactive;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.updatedByDevice = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.statusId = const Value.absent(),
    this.name = const Value.absent(),
    this.imageHash = const Value.absent(),
    this.quantity = const Value.absent(),
    this.location = const Value.absent(),
    this.purchaseUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastCountedAtUtc = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String revisionId,
    required String updatedByDevice,
    required DateTime updatedAtUtc,
    this.isDeleted = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    required String categoryId,
    this.statusId = const Value.absent(),
    required String name,
    this.imageHash = const Value.absent(),
    required int quantity,
    this.location = const Value.absent(),
    this.purchaseUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastCountedAtUtc = const Value.absent(),
    this.isInactive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       updatedByDevice = Value(updatedByDevice),
       updatedAtUtc = Value(updatedAtUtc),
       categoryId = Value(categoryId),
       name = Value(name),
       quantity = Value(quantity);
  static Insertable<Asset> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<String>? updatedByDevice,
    Expression<DateTime>? updatedAtUtc,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAtUtc,
    Expression<String>? categoryId,
    Expression<String>? statusId,
    Expression<String>? name,
    Expression<String>? imageHash,
    Expression<int>? quantity,
    Expression<String>? location,
    Expression<String>? purchaseUrl,
    Expression<String>? notes,
    Expression<DateTime>? lastCountedAtUtc,
    Expression<bool>? isInactive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (updatedByDevice != null) 'updated_by_device': updatedByDevice,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (categoryId != null) 'category_id': categoryId,
      if (statusId != null) 'status_id': statusId,
      if (name != null) 'name': name,
      if (imageHash != null) 'image_hash': imageHash,
      if (quantity != null) 'quantity': quantity,
      if (location != null) 'location': location,
      if (purchaseUrl != null) 'purchase_url': purchaseUrl,
      if (notes != null) 'notes': notes,
      if (lastCountedAtUtc != null) 'last_counted_at_utc': lastCountedAtUtc,
      if (isInactive != null) 'is_inactive': isInactive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<String>? updatedByDevice,
    Value<DateTime>? updatedAtUtc,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAtUtc,
    Value<String>? categoryId,
    Value<String?>? statusId,
    Value<String>? name,
    Value<String?>? imageHash,
    Value<int>? quantity,
    Value<String?>? location,
    Value<String?>? purchaseUrl,
    Value<String?>? notes,
    Value<DateTime?>? lastCountedAtUtc,
    Value<bool>? isInactive,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      updatedByDevice: updatedByDevice ?? this.updatedByDevice,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      categoryId: categoryId ?? this.categoryId,
      statusId: statusId ?? this.statusId,
      name: name ?? this.name,
      imageHash: imageHash ?? this.imageHash,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      purchaseUrl: purchaseUrl ?? this.purchaseUrl,
      notes: notes ?? this.notes,
      lastCountedAtUtc: lastCountedAtUtc ?? this.lastCountedAtUtc,
      isInactive: isInactive ?? this.isInactive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (updatedByDevice.present) {
      map['updated_by_device'] = Variable<String>(updatedByDevice.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<DateTime>(deletedAtUtc.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (statusId.present) {
      map['status_id'] = Variable<String>(statusId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageHash.present) {
      map['image_hash'] = Variable<String>(imageHash.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (purchaseUrl.present) {
      map['purchase_url'] = Variable<String>(purchaseUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (lastCountedAtUtc.present) {
      map['last_counted_at_utc'] = Variable<DateTime>(lastCountedAtUtc.value);
    }
    if (isInactive.present) {
      map['is_inactive'] = Variable<bool>(isInactive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('updatedByDevice: $updatedByDevice, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('categoryId: $categoryId, ')
          ..write('statusId: $statusId, ')
          ..write('name: $name, ')
          ..write('imageHash: $imageHash, ')
          ..write('quantity: $quantity, ')
          ..write('location: $location, ')
          ..write('purchaseUrl: $purchaseUrl, ')
          ..write('notes: $notes, ')
          ..write('lastCountedAtUtc: $lastCountedAtUtc, ')
          ..write('isInactive: $isInactive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDevicesTable extends LocalDevices
    with TableInfo<$LocalDevicesTable, LocalDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceSeqMeta = const VerificationMeta(
    'deviceSeq',
  );
  @override
  late final GeneratedColumn<int> deviceSeq = GeneratedColumn<int>(
    'device_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, deviceSeq, createdAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_seq')) {
      context.handle(
        _deviceSeqMeta,
        deviceSeq.isAcceptableOrUnknown(data['device_seq']!, _deviceSeqMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDevice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_seq'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $LocalDevicesTable createAlias(String alias) {
    return $LocalDevicesTable(attachedDatabase, alias);
  }
}

class LocalDevice extends DataClass implements Insertable<LocalDevice> {
  final String id;
  final int deviceSeq;
  final DateTime createdAtUtc;
  const LocalDevice({
    required this.id,
    required this.deviceSeq,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_seq'] = Variable<int>(deviceSeq);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  LocalDevicesCompanion toCompanion(bool nullToAbsent) {
    return LocalDevicesCompanion(
      id: Value(id),
      deviceSeq: Value(deviceSeq),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory LocalDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDevice(
      id: serializer.fromJson<String>(json['id']),
      deviceSeq: serializer.fromJson<int>(json['deviceSeq']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceSeq': serializer.toJson<int>(deviceSeq),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  LocalDevice copyWith({String? id, int? deviceSeq, DateTime? createdAtUtc}) =>
      LocalDevice(
        id: id ?? this.id,
        deviceSeq: deviceSeq ?? this.deviceSeq,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      );
  LocalDevice copyWithCompanion(LocalDevicesCompanion data) {
    return LocalDevice(
      id: data.id.present ? data.id.value : this.id,
      deviceSeq: data.deviceSeq.present ? data.deviceSeq.value : this.deviceSeq,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDevice(')
          ..write('id: $id, ')
          ..write('deviceSeq: $deviceSeq, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceSeq, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDevice &&
          other.id == this.id &&
          other.deviceSeq == this.deviceSeq &&
          other.createdAtUtc == this.createdAtUtc);
}

class LocalDevicesCompanion extends UpdateCompanion<LocalDevice> {
  final Value<String> id;
  final Value<int> deviceSeq;
  final Value<DateTime> createdAtUtc;
  final Value<int> rowid;
  const LocalDevicesCompanion({
    this.id = const Value.absent(),
    this.deviceSeq = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDevicesCompanion.insert({
    required String id,
    this.deviceSeq = const Value.absent(),
    required DateTime createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<LocalDevice> custom({
    Expression<String>? id,
    Expression<int>? deviceSeq,
    Expression<DateTime>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceSeq != null) 'device_seq': deviceSeq,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDevicesCompanion copyWith({
    Value<String>? id,
    Value<int>? deviceSeq,
    Value<DateTime>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return LocalDevicesCompanion(
      id: id ?? this.id,
      deviceSeq: deviceSeq ?? this.deviceSeq,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceSeq.present) {
      map['device_seq'] = Variable<int>(deviceSeq.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDevicesCompanion(')
          ..write('id: $id, ')
          ..write('deviceSeq: $deviceSeq, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceSeqMeta = const VerificationMeta(
    'deviceSeq',
  );
  @override
  late final GeneratedColumn<int> deviceSeq = GeneratedColumn<int>(
    'device_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseRevisionIdMeta = const VerificationMeta(
    'baseRevisionId',
  );
  @override
  late final GeneratedColumn<String> baseRevisionId = GeneratedColumn<String>(
    'base_revision_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newRevisionIdMeta = const VerificationMeta(
    'newRevisionId',
  );
  @override
  late final GeneratedColumn<String> newRevisionId = GeneratedColumn<String>(
    'new_revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationKindMeta = const VerificationMeta(
    'operationKind',
  );
  @override
  late final GeneratedColumn<String> operationKind = GeneratedColumn<String>(
    'operation_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    originDeviceId,
    deviceSeq,
    entityType,
    entityId,
    baseRevisionId,
    newRevisionId,
    operationKind,
    payloadJson,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('device_seq')) {
      context.handle(
        _deviceSeqMeta,
        deviceSeq.isAcceptableOrUnknown(data['device_seq']!, _deviceSeqMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceSeqMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('base_revision_id')) {
      context.handle(
        _baseRevisionIdMeta,
        baseRevisionId.isAcceptableOrUnknown(
          data['base_revision_id']!,
          _baseRevisionIdMeta,
        ),
      );
    }
    if (data.containsKey('new_revision_id')) {
      context.handle(
        _newRevisionIdMeta,
        newRevisionId.isAcceptableOrUnknown(
          data['new_revision_id']!,
          _newRevisionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newRevisionIdMeta);
    }
    if (data.containsKey('operation_kind')) {
      context.handle(
        _operationKindMeta,
        operationKind.isAcceptableOrUnknown(
          data['operation_kind']!,
          _operationKindMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationKindMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {originDeviceId, deviceSeq},
  ];
  @override
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      deviceSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_seq'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      baseRevisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_revision_id'],
      ),
      newRevisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_revision_id'],
      )!,
      operationKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_kind'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final String operationId;
  final String originDeviceId;
  final int deviceSeq;
  final String entityType;
  final String entityId;
  final String? baseRevisionId;
  final String newRevisionId;
  final String operationKind;
  final String payloadJson;
  final DateTime createdAtUtc;
  const SyncOperation({
    required this.operationId,
    required this.originDeviceId,
    required this.deviceSeq,
    required this.entityType,
    required this.entityId,
    this.baseRevisionId,
    required this.newRevisionId,
    required this.operationKind,
    required this.payloadJson,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['device_seq'] = Variable<int>(deviceSeq);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || baseRevisionId != null) {
      map['base_revision_id'] = Variable<String>(baseRevisionId);
    }
    map['new_revision_id'] = Variable<String>(newRevisionId);
    map['operation_kind'] = Variable<String>(operationKind);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      operationId: Value(operationId),
      originDeviceId: Value(originDeviceId),
      deviceSeq: Value(deviceSeq),
      entityType: Value(entityType),
      entityId: Value(entityId),
      baseRevisionId: baseRevisionId == null && nullToAbsent
          ? const Value.absent()
          : Value(baseRevisionId),
      newRevisionId: Value(newRevisionId),
      operationKind: Value(operationKind),
      payloadJson: Value(payloadJson),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory SyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      operationId: serializer.fromJson<String>(json['operationId']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      deviceSeq: serializer.fromJson<int>(json['deviceSeq']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      baseRevisionId: serializer.fromJson<String?>(json['baseRevisionId']),
      newRevisionId: serializer.fromJson<String>(json['newRevisionId']),
      operationKind: serializer.fromJson<String>(json['operationKind']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'deviceSeq': serializer.toJson<int>(deviceSeq),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'baseRevisionId': serializer.toJson<String?>(baseRevisionId),
      'newRevisionId': serializer.toJson<String>(newRevisionId),
      'operationKind': serializer.toJson<String>(operationKind),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  SyncOperation copyWith({
    String? operationId,
    String? originDeviceId,
    int? deviceSeq,
    String? entityType,
    String? entityId,
    Value<String?> baseRevisionId = const Value.absent(),
    String? newRevisionId,
    String? operationKind,
    String? payloadJson,
    DateTime? createdAtUtc,
  }) => SyncOperation(
    operationId: operationId ?? this.operationId,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    deviceSeq: deviceSeq ?? this.deviceSeq,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    baseRevisionId: baseRevisionId.present
        ? baseRevisionId.value
        : this.baseRevisionId,
    newRevisionId: newRevisionId ?? this.newRevisionId,
    operationKind: operationKind ?? this.operationKind,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      deviceSeq: data.deviceSeq.present ? data.deviceSeq.value : this.deviceSeq,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      baseRevisionId: data.baseRevisionId.present
          ? data.baseRevisionId.value
          : this.baseRevisionId,
      newRevisionId: data.newRevisionId.present
          ? data.newRevisionId.value
          : this.newRevisionId,
      operationKind: data.operationKind.present
          ? data.operationKind.value
          : this.operationKind,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('operationId: $operationId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('deviceSeq: $deviceSeq, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('baseRevisionId: $baseRevisionId, ')
          ..write('newRevisionId: $newRevisionId, ')
          ..write('operationKind: $operationKind, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    originDeviceId,
    deviceSeq,
    entityType,
    entityId,
    baseRevisionId,
    newRevisionId,
    operationKind,
    payloadJson,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.operationId == this.operationId &&
          other.originDeviceId == this.originDeviceId &&
          other.deviceSeq == this.deviceSeq &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.baseRevisionId == this.baseRevisionId &&
          other.newRevisionId == this.newRevisionId &&
          other.operationKind == this.operationKind &&
          other.payloadJson == this.payloadJson &&
          other.createdAtUtc == this.createdAtUtc);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<String> operationId;
  final Value<String> originDeviceId;
  final Value<int> deviceSeq;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> baseRevisionId;
  final Value<String> newRevisionId;
  final Value<String> operationKind;
  final Value<String> payloadJson;
  final Value<DateTime> createdAtUtc;
  final Value<int> rowid;
  const SyncOperationsCompanion({
    this.operationId = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.deviceSeq = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.baseRevisionId = const Value.absent(),
    this.newRevisionId = const Value.absent(),
    this.operationKind = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    required String operationId,
    required String originDeviceId,
    required int deviceSeq,
    required String entityType,
    required String entityId,
    this.baseRevisionId = const Value.absent(),
    required String newRevisionId,
    required String operationKind,
    required String payloadJson,
    required DateTime createdAtUtc,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       originDeviceId = Value(originDeviceId),
       deviceSeq = Value(deviceSeq),
       entityType = Value(entityType),
       entityId = Value(entityId),
       newRevisionId = Value(newRevisionId),
       operationKind = Value(operationKind),
       payloadJson = Value(payloadJson),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<SyncOperation> custom({
    Expression<String>? operationId,
    Expression<String>? originDeviceId,
    Expression<int>? deviceSeq,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? baseRevisionId,
    Expression<String>? newRevisionId,
    Expression<String>? operationKind,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (deviceSeq != null) 'device_seq': deviceSeq,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (baseRevisionId != null) 'base_revision_id': baseRevisionId,
      if (newRevisionId != null) 'new_revision_id': newRevisionId,
      if (operationKind != null) 'operation_kind': operationKind,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOperationsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? originDeviceId,
    Value<int>? deviceSeq,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String?>? baseRevisionId,
    Value<String>? newRevisionId,
    Value<String>? operationKind,
    Value<String>? payloadJson,
    Value<DateTime>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return SyncOperationsCompanion(
      operationId: operationId ?? this.operationId,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      deviceSeq: deviceSeq ?? this.deviceSeq,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      baseRevisionId: baseRevisionId ?? this.baseRevisionId,
      newRevisionId: newRevisionId ?? this.newRevisionId,
      operationKind: operationKind ?? this.operationKind,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (deviceSeq.present) {
      map['device_seq'] = Variable<int>(deviceSeq.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (baseRevisionId.present) {
      map['base_revision_id'] = Variable<String>(baseRevisionId.value);
    }
    if (newRevisionId.present) {
      map['new_revision_id'] = Variable<String>(newRevisionId.value);
    }
    if (operationKind.present) {
      map['operation_kind'] = Variable<String>(operationKind.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('deviceSeq: $deviceSeq, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('baseRevisionId: $baseRevisionId, ')
          ..write('newRevisionId: $newRevisionId, ')
          ..write('operationKind: $operationKind, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductionTypesTable productionTypes = $ProductionTypesTable(
    this,
  );
  late final $IngredientCategoriesTable ingredientCategories =
      $IngredientCategoriesTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $IngredientSkusTable ingredientSkus = $IngredientSkusTable(this);
  late final $CategoryRatioRangesTable categoryRatioRanges =
      $CategoryRatioRangesTable(this);
  late final $IngredientRatioRangesTable ingredientRatioRanges =
      $IngredientRatioRangesTable(this);
  late final $SkuRatioOverridesTable skuRatioOverrides =
      $SkuRatioOverridesTable(this);
  late final $RecommendationPresetsTable recommendationPresets =
      $RecommendationPresetsTable(this);
  late final $RecommendationGroupsTable recommendationGroups =
      $RecommendationGroupsTable(this);
  late final $RecommendationItemsTable recommendationItems =
      $RecommendationItemsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $PlaqueTypesTable plaqueTypes = $PlaqueTypesTable(this);
  late final $AssetCategoriesTable assetCategories = $AssetCategoriesTable(
    this,
  );
  late final $AssetStatusesTable assetStatuses = $AssetStatusesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $LocalDevicesTable localDevices = $LocalDevicesTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productionTypes,
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
    localDevices,
    syncOperations,
  ];
}

typedef $$ProductionTypesTableCreateCompanionBuilder =
    ProductionTypesCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String name,
      required int sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$ProductionTypesTableUpdateCompanionBuilder =
    ProductionTypesCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$ProductionTypesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductionTypesTable, ProductionType> {
  $$ProductionTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CategoryRatioRangesTable,
    List<CategoryRatioRange>
  >
  _categoryRatioRangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryRatioRanges,
        aliasName:
            'production_types__id__category_ratio_ranges__production_type_id',
      );

  $$CategoryRatioRangesTableProcessedTableManager get categoryRatioRangesRefs {
    final manager =
        $$CategoryRatioRangesTableTableManager(
          $_db,
          $_db.categoryRatioRanges,
        ).filter(
          (f) => f.productionTypeId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _categoryRatioRangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IngredientRatioRangesTable,
    List<IngredientRatioRange>
  >
  _ingredientRatioRangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingredientRatioRanges,
        aliasName:
            'production_types__id__ingredient_ratio_ranges__production_type_id',
      );

  $$IngredientRatioRangesTableProcessedTableManager
  get ingredientRatioRangesRefs {
    final manager =
        $$IngredientRatioRangesTableTableManager(
          $_db,
          $_db.ingredientRatioRanges,
        ).filter(
          (f) => f.productionTypeId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _ingredientRatioRangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SkuRatioOverridesTable, List<SkuRatioOverride>>
  _skuRatioOverridesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.skuRatioOverrides,
        aliasName:
            'production_types__id__sku_ratio_overrides__production_type_id',
      );

  $$SkuRatioOverridesTableProcessedTableManager get skuRatioOverridesRefs {
    final manager =
        $$SkuRatioOverridesTableTableManager(
          $_db,
          $_db.skuRatioOverrides,
        ).filter(
          (f) => f.productionTypeId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _skuRatioOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecommendationPresetsTable,
    List<RecommendationPreset>
  >
  _recommendationPresetsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recommendationPresets,
        aliasName:
            'production_types__id__recommendation_presets__production_type_id',
      );

  $$RecommendationPresetsTableProcessedTableManager
  get recommendationPresetsRefs {
    final manager =
        $$RecommendationPresetsTableTableManager(
          $_db,
          $_db.recommendationPresets,
        ).filter(
          (f) => f.productionTypeId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _recommendationPresetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductionTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductionTypesTable> {
  $$ProductionTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryRatioRangesRefs(
    Expression<bool> Function($$CategoryRatioRangesTableFilterComposer f) f,
  ) {
    final $$CategoryRatioRangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryRatioRanges,
      getReferencedColumn: (t) => t.productionTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRatioRangesTableFilterComposer(
            $db: $db,
            $table: $db.categoryRatioRanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ingredientRatioRangesRefs(
    Expression<bool> Function($$IngredientRatioRangesTableFilterComposer f) f,
  ) {
    final $$IngredientRatioRangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientRatioRanges,
          getReferencedColumn: (t) => t.productionTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientRatioRangesTableFilterComposer(
                $db: $db,
                $table: $db.ingredientRatioRanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> skuRatioOverridesRefs(
    Expression<bool> Function($$SkuRatioOverridesTableFilterComposer f) f,
  ) {
    final $$SkuRatioOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.skuRatioOverrides,
      getReferencedColumn: (t) => t.productionTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SkuRatioOverridesTableFilterComposer(
            $db: $db,
            $table: $db.skuRatioOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recommendationPresetsRefs(
    Expression<bool> Function($$RecommendationPresetsTableFilterComposer f) f,
  ) {
    final $$RecommendationPresetsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recommendationPresets,
          getReferencedColumn: (t) => t.productionTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationPresetsTableFilterComposer(
                $db: $db,
                $table: $db.recommendationPresets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductionTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductionTypesTable> {
  $$ProductionTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductionTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductionTypesTable> {
  $$ProductionTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  Expression<T> categoryRatioRangesRefs<T extends Object>(
    Expression<T> Function($$CategoryRatioRangesTableAnnotationComposer a) f,
  ) {
    final $$CategoryRatioRangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.categoryRatioRanges,
          getReferencedColumn: (t) => t.productionTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryRatioRangesTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryRatioRanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ingredientRatioRangesRefs<T extends Object>(
    Expression<T> Function($$IngredientRatioRangesTableAnnotationComposer a) f,
  ) {
    final $$IngredientRatioRangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientRatioRanges,
          getReferencedColumn: (t) => t.productionTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientRatioRangesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientRatioRanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> skuRatioOverridesRefs<T extends Object>(
    Expression<T> Function($$SkuRatioOverridesTableAnnotationComposer a) f,
  ) {
    final $$SkuRatioOverridesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.skuRatioOverrides,
          getReferencedColumn: (t) => t.productionTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SkuRatioOverridesTableAnnotationComposer(
                $db: $db,
                $table: $db.skuRatioOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recommendationPresetsRefs<T extends Object>(
    Expression<T> Function($$RecommendationPresetsTableAnnotationComposer a) f,
  ) {
    final $$RecommendationPresetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recommendationPresets,
          getReferencedColumn: (t) => t.productionTypeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationPresetsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationPresets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductionTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductionTypesTable,
          ProductionType,
          $$ProductionTypesTableFilterComposer,
          $$ProductionTypesTableOrderingComposer,
          $$ProductionTypesTableAnnotationComposer,
          $$ProductionTypesTableCreateCompanionBuilder,
          $$ProductionTypesTableUpdateCompanionBuilder,
          (ProductionType, $$ProductionTypesTableReferences),
          ProductionType,
          PrefetchHooks Function({
            bool categoryRatioRangesRefs,
            bool ingredientRatioRangesRefs,
            bool skuRatioOverridesRefs,
            bool recommendationPresetsRefs,
          })
        > {
  $$ProductionTypesTableTableManager(
    _$AppDatabase db,
    $ProductionTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductionTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductionTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductionTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductionTypesCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String name,
                required int sortOrder,
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductionTypesCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductionTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryRatioRangesRefs = false,
                ingredientRatioRangesRefs = false,
                skuRatioOverridesRefs = false,
                recommendationPresetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryRatioRangesRefs) db.categoryRatioRanges,
                    if (ingredientRatioRangesRefs) db.ingredientRatioRanges,
                    if (skuRatioOverridesRefs) db.skuRatioOverrides,
                    if (recommendationPresetsRefs) db.recommendationPresets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryRatioRangesRefs)
                        await $_getPrefetchedData<
                          ProductionType,
                          $ProductionTypesTable,
                          CategoryRatioRange
                        >(
                          currentTable: table,
                          referencedTable: $$ProductionTypesTableReferences
                              ._categoryRatioRangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductionTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryRatioRangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productionTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingredientRatioRangesRefs)
                        await $_getPrefetchedData<
                          ProductionType,
                          $ProductionTypesTable,
                          IngredientRatioRange
                        >(
                          currentTable: table,
                          referencedTable: $$ProductionTypesTableReferences
                              ._ingredientRatioRangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductionTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientRatioRangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productionTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (skuRatioOverridesRefs)
                        await $_getPrefetchedData<
                          ProductionType,
                          $ProductionTypesTable,
                          SkuRatioOverride
                        >(
                          currentTable: table,
                          referencedTable: $$ProductionTypesTableReferences
                              ._skuRatioOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductionTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).skuRatioOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productionTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recommendationPresetsRefs)
                        await $_getPrefetchedData<
                          ProductionType,
                          $ProductionTypesTable,
                          RecommendationPreset
                        >(
                          currentTable: table,
                          referencedTable: $$ProductionTypesTableReferences
                              ._recommendationPresetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductionTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).recommendationPresetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productionTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductionTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductionTypesTable,
      ProductionType,
      $$ProductionTypesTableFilterComposer,
      $$ProductionTypesTableOrderingComposer,
      $$ProductionTypesTableAnnotationComposer,
      $$ProductionTypesTableCreateCompanionBuilder,
      $$ProductionTypesTableUpdateCompanionBuilder,
      (ProductionType, $$ProductionTypesTableReferences),
      ProductionType,
      PrefetchHooks Function({
        bool categoryRatioRangesRefs,
        bool ingredientRatioRangesRefs,
        bool skuRatioOverridesRefs,
        bool recommendationPresetsRefs,
      })
    >;
typedef $$IngredientCategoriesTableCreateCompanionBuilder =
    IngredientCategoriesCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String name,
      required int sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$IngredientCategoriesTableUpdateCompanionBuilder =
    IngredientCategoriesCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$IngredientCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngredientCategoriesTable,
          IngredientCategory
        > {
  $$IngredientCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$IngredientsTable, List<Ingredient>>
  _ingredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredients,
    aliasName: 'ingredient_categories__id__ingredients__category_id',
  );

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CategoryRatioRangesTable,
    List<CategoryRatioRange>
  >
  _categoryRatioRangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryRatioRanges,
        aliasName:
            'ingredient_categories__id__category_ratio_ranges__category_id',
      );

  $$CategoryRatioRangesTableProcessedTableManager get categoryRatioRangesRefs {
    final manager = $$CategoryRatioRangesTableTableManager(
      $_db,
      $_db.categoryRatioRanges,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _categoryRatioRangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecommendationGroupsTable,
    List<RecommendationGroup>
  >
  _recommendationGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recommendationGroups,
        aliasName:
            'ingredient_categories__id__recommendation_groups__category_id',
      );

  $$RecommendationGroupsTableProcessedTableManager
  get recommendationGroupsRefs {
    final manager = $$RecommendationGroupsTableTableManager(
      $_db,
      $_db.recommendationGroups,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recommendationGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientCategoriesTable> {
  $$IngredientCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingredientsRefs(
    Expression<bool> Function($$IngredientsTableFilterComposer f) f,
  ) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> categoryRatioRangesRefs(
    Expression<bool> Function($$CategoryRatioRangesTableFilterComposer f) f,
  ) {
    final $$CategoryRatioRangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryRatioRanges,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRatioRangesTableFilterComposer(
            $db: $db,
            $table: $db.categoryRatioRanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recommendationGroupsRefs(
    Expression<bool> Function($$RecommendationGroupsTableFilterComposer f) f,
  ) {
    final $$RecommendationGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recommendationGroups,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecommendationGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recommendationGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientCategoriesTable> {
  $$IngredientCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientCategoriesTable> {
  $$IngredientCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  Expression<T> ingredientsRefs<T extends Object>(
    Expression<T> Function($$IngredientsTableAnnotationComposer a) f,
  ) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> categoryRatioRangesRefs<T extends Object>(
    Expression<T> Function($$CategoryRatioRangesTableAnnotationComposer a) f,
  ) {
    final $$CategoryRatioRangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.categoryRatioRanges,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryRatioRangesTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryRatioRanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recommendationGroupsRefs<T extends Object>(
    Expression<T> Function($$RecommendationGroupsTableAnnotationComposer a) f,
  ) {
    final $$RecommendationGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recommendationGroups,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IngredientCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientCategoriesTable,
          IngredientCategory,
          $$IngredientCategoriesTableFilterComposer,
          $$IngredientCategoriesTableOrderingComposer,
          $$IngredientCategoriesTableAnnotationComposer,
          $$IngredientCategoriesTableCreateCompanionBuilder,
          $$IngredientCategoriesTableUpdateCompanionBuilder,
          (IngredientCategory, $$IngredientCategoriesTableReferences),
          IngredientCategory,
          PrefetchHooks Function({
            bool ingredientsRefs,
            bool categoryRatioRangesRefs,
            bool recommendationGroupsRefs,
          })
        > {
  $$IngredientCategoriesTableTableManager(
    _$AppDatabase db,
    $IngredientCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientCategoriesCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String name,
                required int sortOrder,
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientCategoriesCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ingredientsRefs = false,
                categoryRatioRangesRefs = false,
                recommendationGroupsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingredientsRefs) db.ingredients,
                    if (categoryRatioRangesRefs) db.categoryRatioRanges,
                    if (recommendationGroupsRefs) db.recommendationGroups,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientsRefs)
                        await $_getPrefetchedData<
                          IngredientCategory,
                          $IngredientCategoriesTable,
                          Ingredient
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientCategoriesTableReferences
                              ._ingredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (categoryRatioRangesRefs)
                        await $_getPrefetchedData<
                          IngredientCategory,
                          $IngredientCategoriesTable,
                          CategoryRatioRange
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientCategoriesTableReferences
                              ._categoryRatioRangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryRatioRangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recommendationGroupsRefs)
                        await $_getPrefetchedData<
                          IngredientCategory,
                          $IngredientCategoriesTable,
                          RecommendationGroup
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientCategoriesTableReferences
                              ._recommendationGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recommendationGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientCategoriesTable,
      IngredientCategory,
      $$IngredientCategoriesTableFilterComposer,
      $$IngredientCategoriesTableOrderingComposer,
      $$IngredientCategoriesTableAnnotationComposer,
      $$IngredientCategoriesTableCreateCompanionBuilder,
      $$IngredientCategoriesTableUpdateCompanionBuilder,
      (IngredientCategory, $$IngredientCategoriesTableReferences),
      IngredientCategory,
      PrefetchHooks Function({
        bool ingredientsRefs,
        bool categoryRatioRangesRefs,
        bool recommendationGroupsRefs,
      })
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String categoryId,
      required String name,
      Value<String?> alias,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> categoryId,
      Value<String> name,
      Value<String?> alias,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IngredientCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .ingredientCategories
      .createAlias('ingredients__category_id__ingredient_categories__id');

  $$IngredientCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$IngredientCategoriesTableTableManager(
      $_db,
      $_db.ingredientCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IngredientSkusTable, List<IngredientSkusData>>
  _ingredientSkusRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredientSkus,
    aliasName: 'ingredients__id__ingredient_skus__ingredient_id',
  );

  $$IngredientSkusTableProcessedTableManager get ingredientSkusRefs {
    final manager = $$IngredientSkusTableTableManager(
      $_db,
      $_db.ingredientSkus,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientSkusRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IngredientRatioRangesTable,
    List<IngredientRatioRange>
  >
  _ingredientRatioRangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingredientRatioRanges,
        aliasName: 'ingredients__id__ingredient_ratio_ranges__ingredient_id',
      );

  $$IngredientRatioRangesTableProcessedTableManager
  get ingredientRatioRangesRefs {
    final manager = $$IngredientRatioRangesTableTableManager(
      $_db,
      $_db.ingredientRatioRanges,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingredientRatioRangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientCategoriesTableFilterComposer get categoryId {
    final $$IngredientCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ingredientCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ingredientSkusRefs(
    Expression<bool> Function($$IngredientSkusTableFilterComposer f) f,
  ) {
    final $$IngredientSkusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableFilterComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ingredientRatioRangesRefs(
    Expression<bool> Function($$IngredientRatioRangesTableFilterComposer f) f,
  ) {
    final $$IngredientRatioRangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientRatioRanges,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientRatioRangesTableFilterComposer(
                $db: $db,
                $table: $db.ingredientRatioRanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientCategoriesTableOrderingComposer get categoryId {
    final $$IngredientCategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  $$IngredientCategoriesTableAnnotationComposer get categoryId {
    final $$IngredientCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> ingredientSkusRefs<T extends Object>(
    Expression<T> Function($$IngredientSkusTableAnnotationComposer a) f,
  ) {
    final $$IngredientSkusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ingredientRatioRangesRefs<T extends Object>(
    Expression<T> Function($$IngredientRatioRangesTableAnnotationComposer a) f,
  ) {
    final $$IngredientRatioRangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientRatioRanges,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientRatioRangesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientRatioRanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({
            bool categoryId,
            bool ingredientSkusRefs,
            bool ingredientRatioRangesRefs,
          })
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                categoryId: categoryId,
                name: name,
                alias: alias,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String categoryId,
                required String name,
                Value<String?> alias = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                categoryId: categoryId,
                name: name,
                alias: alias,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                ingredientSkusRefs = false,
                ingredientRatioRangesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingredientSkusRefs) db.ingredientSkus,
                    if (ingredientRatioRangesRefs) db.ingredientRatioRanges,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$IngredientsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$IngredientsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientSkusRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientSkusData
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._ingredientSkusRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientSkusRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingredientRatioRangesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientRatioRange
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._ingredientRatioRangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientRatioRangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({
        bool categoryId,
        bool ingredientSkusRefs,
        bool ingredientRatioRangesRefs,
      })
    >;
typedef $$IngredientSkusTableCreateCompanionBuilder =
    IngredientSkusCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String ingredientId,
      Value<String?> skuCode,
      Value<String?> imageHash,
      Value<String?> supplier,
      Value<String?> origin,
      Value<String?> purchaseUrl,
      Value<String?> notes,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$IngredientSkusTableUpdateCompanionBuilder =
    IngredientSkusCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> ingredientId,
      Value<String?> skuCode,
      Value<String?> imageHash,
      Value<String?> supplier,
      Value<String?> origin,
      Value<String?> purchaseUrl,
      Value<String?> notes,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$IngredientSkusTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngredientSkusTable,
          IngredientSkusData
        > {
  $$IngredientSkusTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) => db
      .ingredients
      .createAlias('ingredient_skus__ingredient_id__ingredients__id');

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SkuRatioOverridesTable, List<SkuRatioOverride>>
  _skuRatioOverridesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.skuRatioOverrides,
        aliasName: 'ingredient_skus__id__sku_ratio_overrides__sku_id',
      );

  $$SkuRatioOverridesTableProcessedTableManager get skuRatioOverridesRefs {
    final manager = $$SkuRatioOverridesTableTableManager(
      $_db,
      $_db.skuRatioOverrides,
    ).filter((f) => f.skuId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _skuRatioOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecommendationItemsTable,
    List<RecommendationItem>
  >
  _recommendationItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recommendationItems,
        aliasName: 'ingredient_skus__id__recommendation_items__sku_id',
      );

  $$RecommendationItemsTableProcessedTableManager get recommendationItemsRefs {
    final manager = $$RecommendationItemsTableTableManager(
      $_db,
      $_db.recommendationItems,
    ).filter((f) => f.skuId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recommendationItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientSkusTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientSkusTable> {
  $$IngredientSkusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skuCode => $composableBuilder(
    column: $table.skuCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageHash => $composableBuilder(
    column: $table.imageHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseUrl => $composableBuilder(
    column: $table.purchaseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> skuRatioOverridesRefs(
    Expression<bool> Function($$SkuRatioOverridesTableFilterComposer f) f,
  ) {
    final $$SkuRatioOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.skuRatioOverrides,
      getReferencedColumn: (t) => t.skuId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SkuRatioOverridesTableFilterComposer(
            $db: $db,
            $table: $db.skuRatioOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recommendationItemsRefs(
    Expression<bool> Function($$RecommendationItemsTableFilterComposer f) f,
  ) {
    final $$RecommendationItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recommendationItems,
      getReferencedColumn: (t) => t.skuId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecommendationItemsTableFilterComposer(
            $db: $db,
            $table: $db.recommendationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientSkusTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientSkusTable> {
  $$IngredientSkusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skuCode => $composableBuilder(
    column: $table.skuCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageHash => $composableBuilder(
    column: $table.imageHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseUrl => $composableBuilder(
    column: $table.purchaseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientSkusTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientSkusTable> {
  $$IngredientSkusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skuCode =>
      $composableBuilder(column: $table.skuCode, builder: (column) => column);

  GeneratedColumn<String> get imageHash =>
      $composableBuilder(column: $table.imageHash, builder: (column) => column);

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get purchaseUrl => $composableBuilder(
    column: $table.purchaseUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> skuRatioOverridesRefs<T extends Object>(
    Expression<T> Function($$SkuRatioOverridesTableAnnotationComposer a) f,
  ) {
    final $$SkuRatioOverridesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.skuRatioOverrides,
          getReferencedColumn: (t) => t.skuId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SkuRatioOverridesTableAnnotationComposer(
                $db: $db,
                $table: $db.skuRatioOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recommendationItemsRefs<T extends Object>(
    Expression<T> Function($$RecommendationItemsTableAnnotationComposer a) f,
  ) {
    final $$RecommendationItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recommendationItems,
          getReferencedColumn: (t) => t.skuId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IngredientSkusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientSkusTable,
          IngredientSkusData,
          $$IngredientSkusTableFilterComposer,
          $$IngredientSkusTableOrderingComposer,
          $$IngredientSkusTableAnnotationComposer,
          $$IngredientSkusTableCreateCompanionBuilder,
          $$IngredientSkusTableUpdateCompanionBuilder,
          (IngredientSkusData, $$IngredientSkusTableReferences),
          IngredientSkusData,
          PrefetchHooks Function({
            bool ingredientId,
            bool skuRatioOverridesRefs,
            bool recommendationItemsRefs,
          })
        > {
  $$IngredientSkusTableTableManager(
    _$AppDatabase db,
    $IngredientSkusTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientSkusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientSkusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientSkusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<String?> skuCode = const Value.absent(),
                Value<String?> imageHash = const Value.absent(),
                Value<String?> supplier = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> purchaseUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientSkusCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                ingredientId: ingredientId,
                skuCode: skuCode,
                imageHash: imageHash,
                supplier: supplier,
                origin: origin,
                purchaseUrl: purchaseUrl,
                notes: notes,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String ingredientId,
                Value<String?> skuCode = const Value.absent(),
                Value<String?> imageHash = const Value.absent(),
                Value<String?> supplier = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> purchaseUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientSkusCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                ingredientId: ingredientId,
                skuCode: skuCode,
                imageHash: imageHash,
                supplier: supplier,
                origin: origin,
                purchaseUrl: purchaseUrl,
                notes: notes,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientSkusTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ingredientId = false,
                skuRatioOverridesRefs = false,
                recommendationItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (skuRatioOverridesRefs) db.skuRatioOverrides,
                    if (recommendationItemsRefs) db.recommendationItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ingredientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ingredientId,
                                    referencedTable:
                                        $$IngredientSkusTableReferences
                                            ._ingredientIdTable(db),
                                    referencedColumn:
                                        $$IngredientSkusTableReferences
                                            ._ingredientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (skuRatioOverridesRefs)
                        await $_getPrefetchedData<
                          IngredientSkusData,
                          $IngredientSkusTable,
                          SkuRatioOverride
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientSkusTableReferences
                              ._skuRatioOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientSkusTableReferences(
                                db,
                                table,
                                p0,
                              ).skuRatioOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.skuId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recommendationItemsRefs)
                        await $_getPrefetchedData<
                          IngredientSkusData,
                          $IngredientSkusTable,
                          RecommendationItem
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientSkusTableReferences
                              ._recommendationItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientSkusTableReferences(
                                db,
                                table,
                                p0,
                              ).recommendationItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.skuId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientSkusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientSkusTable,
      IngredientSkusData,
      $$IngredientSkusTableFilterComposer,
      $$IngredientSkusTableOrderingComposer,
      $$IngredientSkusTableAnnotationComposer,
      $$IngredientSkusTableCreateCompanionBuilder,
      $$IngredientSkusTableUpdateCompanionBuilder,
      (IngredientSkusData, $$IngredientSkusTableReferences),
      IngredientSkusData,
      PrefetchHooks Function({
        bool ingredientId,
        bool skuRatioOverridesRefs,
        bool recommendationItemsRefs,
      })
    >;
typedef $$CategoryRatioRangesTableCreateCompanionBuilder =
    CategoryRatioRangesCompanion Function({
      required String productionTypeId,
      required int minRatio,
      required int maxRatio,
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String categoryId,
      Value<int> rowid,
    });
typedef $$CategoryRatioRangesTableUpdateCompanionBuilder =
    CategoryRatioRangesCompanion Function({
      Value<String> productionTypeId,
      Value<int> minRatio,
      Value<int> maxRatio,
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> categoryId,
      Value<int> rowid,
    });

final class $$CategoryRatioRangesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoryRatioRangesTable,
          CategoryRatioRange
        > {
  $$CategoryRatioRangesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductionTypesTable _productionTypeIdTable(_$AppDatabase db) =>
      db.productionTypes.createAlias(
        'category_ratio_ranges__production_type_id__production_types__id',
      );

  $$ProductionTypesTableProcessedTableManager get productionTypeId {
    final $_column = $_itemColumn<String>('production_type_id')!;

    final manager = $$ProductionTypesTableTableManager(
      $_db,
      $_db.productionTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productionTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.ingredientCategories.createAlias(
        'category_ratio_ranges__category_id__ingredient_categories__id',
      );

  $$IngredientCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$IngredientCategoriesTableTableManager(
      $_db,
      $_db.ingredientCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CategoryRatioRangesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryRatioRangesTable> {
  $$CategoryRatioRangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get minRatio => $composableBuilder(
    column: $table.minRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxRatio => $composableBuilder(
    column: $table.maxRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductionTypesTableFilterComposer get productionTypeId {
    final $$ProductionTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableFilterComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientCategoriesTableFilterComposer get categoryId {
    final $$IngredientCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ingredientCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRatioRangesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryRatioRangesTable> {
  $$CategoryRatioRangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get minRatio => $composableBuilder(
    column: $table.minRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRatio => $composableBuilder(
    column: $table.maxRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductionTypesTableOrderingComposer get productionTypeId {
    final $$ProductionTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableOrderingComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientCategoriesTableOrderingComposer get categoryId {
    final $$IngredientCategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CategoryRatioRangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryRatioRangesTable> {
  $$CategoryRatioRangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get minRatio =>
      $composableBuilder(column: $table.minRatio, builder: (column) => column);

  GeneratedColumn<int> get maxRatio =>
      $composableBuilder(column: $table.maxRatio, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  $$ProductionTypesTableAnnotationComposer get productionTypeId {
    final $$ProductionTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientCategoriesTableAnnotationComposer get categoryId {
    final $$IngredientCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CategoryRatioRangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryRatioRangesTable,
          CategoryRatioRange,
          $$CategoryRatioRangesTableFilterComposer,
          $$CategoryRatioRangesTableOrderingComposer,
          $$CategoryRatioRangesTableAnnotationComposer,
          $$CategoryRatioRangesTableCreateCompanionBuilder,
          $$CategoryRatioRangesTableUpdateCompanionBuilder,
          (CategoryRatioRange, $$CategoryRatioRangesTableReferences),
          CategoryRatioRange,
          PrefetchHooks Function({bool productionTypeId, bool categoryId})
        > {
  $$CategoryRatioRangesTableTableManager(
    _$AppDatabase db,
    $CategoryRatioRangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryRatioRangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryRatioRangesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategoryRatioRangesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> productionTypeId = const Value.absent(),
                Value<int> minRatio = const Value.absent(),
                Value<int> maxRatio = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryRatioRangesCompanion(
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productionTypeId,
                required int minRatio,
                required int maxRatio,
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String categoryId,
                Value<int> rowid = const Value.absent(),
              }) => CategoryRatioRangesCompanion.insert(
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoryRatioRangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productionTypeId = false, categoryId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productionTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productionTypeId,
                                    referencedTable:
                                        $$CategoryRatioRangesTableReferences
                                            ._productionTypeIdTable(db),
                                    referencedColumn:
                                        $$CategoryRatioRangesTableReferences
                                            ._productionTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$CategoryRatioRangesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$CategoryRatioRangesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$CategoryRatioRangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryRatioRangesTable,
      CategoryRatioRange,
      $$CategoryRatioRangesTableFilterComposer,
      $$CategoryRatioRangesTableOrderingComposer,
      $$CategoryRatioRangesTableAnnotationComposer,
      $$CategoryRatioRangesTableCreateCompanionBuilder,
      $$CategoryRatioRangesTableUpdateCompanionBuilder,
      (CategoryRatioRange, $$CategoryRatioRangesTableReferences),
      CategoryRatioRange,
      PrefetchHooks Function({bool productionTypeId, bool categoryId})
    >;
typedef $$IngredientRatioRangesTableCreateCompanionBuilder =
    IngredientRatioRangesCompanion Function({
      required String productionTypeId,
      required int minRatio,
      required int maxRatio,
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String ingredientId,
      Value<int> rowid,
    });
typedef $$IngredientRatioRangesTableUpdateCompanionBuilder =
    IngredientRatioRangesCompanion Function({
      Value<String> productionTypeId,
      Value<int> minRatio,
      Value<int> maxRatio,
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> ingredientId,
      Value<int> rowid,
    });

final class $$IngredientRatioRangesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngredientRatioRangesTable,
          IngredientRatioRange
        > {
  $$IngredientRatioRangesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductionTypesTable _productionTypeIdTable(_$AppDatabase db) =>
      db.productionTypes.createAlias(
        'ingredient_ratio_ranges__production_type_id__production_types__id',
      );

  $$ProductionTypesTableProcessedTableManager get productionTypeId {
    final $_column = $_itemColumn<String>('production_type_id')!;

    final manager = $$ProductionTypesTableTableManager(
      $_db,
      $_db.productionTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productionTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) => db
      .ingredients
      .createAlias('ingredient_ratio_ranges__ingredient_id__ingredients__id');

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientRatioRangesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientRatioRangesTable> {
  $$IngredientRatioRangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get minRatio => $composableBuilder(
    column: $table.minRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxRatio => $composableBuilder(
    column: $table.maxRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductionTypesTableFilterComposer get productionTypeId {
    final $$ProductionTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableFilterComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientRatioRangesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientRatioRangesTable> {
  $$IngredientRatioRangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get minRatio => $composableBuilder(
    column: $table.minRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRatio => $composableBuilder(
    column: $table.maxRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductionTypesTableOrderingComposer get productionTypeId {
    final $$ProductionTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableOrderingComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientRatioRangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientRatioRangesTable> {
  $$IngredientRatioRangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get minRatio =>
      $composableBuilder(column: $table.minRatio, builder: (column) => column);

  GeneratedColumn<int> get maxRatio =>
      $composableBuilder(column: $table.maxRatio, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  $$ProductionTypesTableAnnotationComposer get productionTypeId {
    final $$ProductionTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientRatioRangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientRatioRangesTable,
          IngredientRatioRange,
          $$IngredientRatioRangesTableFilterComposer,
          $$IngredientRatioRangesTableOrderingComposer,
          $$IngredientRatioRangesTableAnnotationComposer,
          $$IngredientRatioRangesTableCreateCompanionBuilder,
          $$IngredientRatioRangesTableUpdateCompanionBuilder,
          (IngredientRatioRange, $$IngredientRatioRangesTableReferences),
          IngredientRatioRange,
          PrefetchHooks Function({bool productionTypeId, bool ingredientId})
        > {
  $$IngredientRatioRangesTableTableManager(
    _$AppDatabase db,
    $IngredientRatioRangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientRatioRangesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IngredientRatioRangesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientRatioRangesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> productionTypeId = const Value.absent(),
                Value<int> minRatio = const Value.absent(),
                Value<int> maxRatio = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientRatioRangesCompanion(
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                ingredientId: ingredientId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productionTypeId,
                required int minRatio,
                required int maxRatio,
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String ingredientId,
                Value<int> rowid = const Value.absent(),
              }) => IngredientRatioRangesCompanion.insert(
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                ingredientId: ingredientId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientRatioRangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productionTypeId = false, ingredientId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productionTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productionTypeId,
                                    referencedTable:
                                        $$IngredientRatioRangesTableReferences
                                            ._productionTypeIdTable(db),
                                    referencedColumn:
                                        $$IngredientRatioRangesTableReferences
                                            ._productionTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (ingredientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ingredientId,
                                    referencedTable:
                                        $$IngredientRatioRangesTableReferences
                                            ._ingredientIdTable(db),
                                    referencedColumn:
                                        $$IngredientRatioRangesTableReferences
                                            ._ingredientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientRatioRangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientRatioRangesTable,
      IngredientRatioRange,
      $$IngredientRatioRangesTableFilterComposer,
      $$IngredientRatioRangesTableOrderingComposer,
      $$IngredientRatioRangesTableAnnotationComposer,
      $$IngredientRatioRangesTableCreateCompanionBuilder,
      $$IngredientRatioRangesTableUpdateCompanionBuilder,
      (IngredientRatioRange, $$IngredientRatioRangesTableReferences),
      IngredientRatioRange,
      PrefetchHooks Function({bool productionTypeId, bool ingredientId})
    >;
typedef $$SkuRatioOverridesTableCreateCompanionBuilder =
    SkuRatioOverridesCompanion Function({
      required String productionTypeId,
      required int minRatio,
      required int maxRatio,
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String skuId,
      Value<int> rowid,
    });
typedef $$SkuRatioOverridesTableUpdateCompanionBuilder =
    SkuRatioOverridesCompanion Function({
      Value<String> productionTypeId,
      Value<int> minRatio,
      Value<int> maxRatio,
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> skuId,
      Value<int> rowid,
    });

final class $$SkuRatioOverridesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SkuRatioOverridesTable,
          SkuRatioOverride
        > {
  $$SkuRatioOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductionTypesTable _productionTypeIdTable(_$AppDatabase db) =>
      db.productionTypes.createAlias(
        'sku_ratio_overrides__production_type_id__production_types__id',
      );

  $$ProductionTypesTableProcessedTableManager get productionTypeId {
    final $_column = $_itemColumn<String>('production_type_id')!;

    final manager = $$ProductionTypesTableTableManager(
      $_db,
      $_db.productionTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productionTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientSkusTable _skuIdTable(_$AppDatabase db) => db.ingredientSkus
      .createAlias('sku_ratio_overrides__sku_id__ingredient_skus__id');

  $$IngredientSkusTableProcessedTableManager get skuId {
    final $_column = $_itemColumn<String>('sku_id')!;

    final manager = $$IngredientSkusTableTableManager(
      $_db,
      $_db.ingredientSkus,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_skuIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SkuRatioOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $SkuRatioOverridesTable> {
  $$SkuRatioOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get minRatio => $composableBuilder(
    column: $table.minRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxRatio => $composableBuilder(
    column: $table.maxRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductionTypesTableFilterComposer get productionTypeId {
    final $$ProductionTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableFilterComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientSkusTableFilterComposer get skuId {
    final $$IngredientSkusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.skuId,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableFilterComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkuRatioOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $SkuRatioOverridesTable> {
  $$SkuRatioOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get minRatio => $composableBuilder(
    column: $table.minRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRatio => $composableBuilder(
    column: $table.maxRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductionTypesTableOrderingComposer get productionTypeId {
    final $$ProductionTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableOrderingComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientSkusTableOrderingComposer get skuId {
    final $$IngredientSkusTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.skuId,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableOrderingComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkuRatioOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkuRatioOverridesTable> {
  $$SkuRatioOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get minRatio =>
      $composableBuilder(column: $table.minRatio, builder: (column) => column);

  GeneratedColumn<int> get maxRatio =>
      $composableBuilder(column: $table.maxRatio, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  $$ProductionTypesTableAnnotationComposer get productionTypeId {
    final $$ProductionTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientSkusTableAnnotationComposer get skuId {
    final $$IngredientSkusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.skuId,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SkuRatioOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkuRatioOverridesTable,
          SkuRatioOverride,
          $$SkuRatioOverridesTableFilterComposer,
          $$SkuRatioOverridesTableOrderingComposer,
          $$SkuRatioOverridesTableAnnotationComposer,
          $$SkuRatioOverridesTableCreateCompanionBuilder,
          $$SkuRatioOverridesTableUpdateCompanionBuilder,
          (SkuRatioOverride, $$SkuRatioOverridesTableReferences),
          SkuRatioOverride,
          PrefetchHooks Function({bool productionTypeId, bool skuId})
        > {
  $$SkuRatioOverridesTableTableManager(
    _$AppDatabase db,
    $SkuRatioOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkuRatioOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkuRatioOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkuRatioOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> productionTypeId = const Value.absent(),
                Value<int> minRatio = const Value.absent(),
                Value<int> maxRatio = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> skuId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SkuRatioOverridesCompanion(
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                skuId: skuId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productionTypeId,
                required int minRatio,
                required int maxRatio,
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String skuId,
                Value<int> rowid = const Value.absent(),
              }) => SkuRatioOverridesCompanion.insert(
                productionTypeId: productionTypeId,
                minRatio: minRatio,
                maxRatio: maxRatio,
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                skuId: skuId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SkuRatioOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productionTypeId = false, skuId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productionTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productionTypeId,
                                referencedTable:
                                    $$SkuRatioOverridesTableReferences
                                        ._productionTypeIdTable(db),
                                referencedColumn:
                                    $$SkuRatioOverridesTableReferences
                                        ._productionTypeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (skuId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.skuId,
                                referencedTable:
                                    $$SkuRatioOverridesTableReferences
                                        ._skuIdTable(db),
                                referencedColumn:
                                    $$SkuRatioOverridesTableReferences
                                        ._skuIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SkuRatioOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkuRatioOverridesTable,
      SkuRatioOverride,
      $$SkuRatioOverridesTableFilterComposer,
      $$SkuRatioOverridesTableOrderingComposer,
      $$SkuRatioOverridesTableAnnotationComposer,
      $$SkuRatioOverridesTableCreateCompanionBuilder,
      $$SkuRatioOverridesTableUpdateCompanionBuilder,
      (SkuRatioOverride, $$SkuRatioOverridesTableReferences),
      SkuRatioOverride,
      PrefetchHooks Function({bool productionTypeId, bool skuId})
    >;
typedef $$RecommendationPresetsTableCreateCompanionBuilder =
    RecommendationPresetsCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String productionTypeId,
      required String name,
      Value<String?> notes,
      required int sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$RecommendationPresetsTableUpdateCompanionBuilder =
    RecommendationPresetsCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> productionTypeId,
      Value<String> name,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$RecommendationPresetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecommendationPresetsTable,
          RecommendationPreset
        > {
  $$RecommendationPresetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductionTypesTable _productionTypeIdTable(_$AppDatabase db) =>
      db.productionTypes.createAlias(
        'recommendation_presets__production_type_id__production_types__id',
      );

  $$ProductionTypesTableProcessedTableManager get productionTypeId {
    final $_column = $_itemColumn<String>('production_type_id')!;

    final manager = $$ProductionTypesTableTableManager(
      $_db,
      $_db.productionTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productionTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecommendationGroupsTable,
    List<RecommendationGroup>
  >
  _recommendationGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recommendationGroups,
        aliasName:
            'recommendation_presets__id__recommendation_groups__preset_id',
      );

  $$RecommendationGroupsTableProcessedTableManager
  get recommendationGroupsRefs {
    final manager = $$RecommendationGroupsTableTableManager(
      $_db,
      $_db.recommendationGroups,
    ).filter((f) => f.presetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recommendationGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecommendationPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $RecommendationPresetsTable> {
  $$RecommendationPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductionTypesTableFilterComposer get productionTypeId {
    final $$ProductionTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableFilterComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recommendationGroupsRefs(
    Expression<bool> Function($$RecommendationGroupsTableFilterComposer f) f,
  ) {
    final $$RecommendationGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recommendationGroups,
      getReferencedColumn: (t) => t.presetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecommendationGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recommendationGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecommendationPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecommendationPresetsTable> {
  $$RecommendationPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductionTypesTableOrderingComposer get productionTypeId {
    final $$ProductionTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableOrderingComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecommendationPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecommendationPresetsTable> {
  $$RecommendationPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  $$ProductionTypesTableAnnotationComposer get productionTypeId {
    final $$ProductionTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productionTypeId,
      referencedTable: $db.productionTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.productionTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recommendationGroupsRefs<T extends Object>(
    Expression<T> Function($$RecommendationGroupsTableAnnotationComposer a) f,
  ) {
    final $$RecommendationGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recommendationGroups,
          getReferencedColumn: (t) => t.presetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecommendationPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecommendationPresetsTable,
          RecommendationPreset,
          $$RecommendationPresetsTableFilterComposer,
          $$RecommendationPresetsTableOrderingComposer,
          $$RecommendationPresetsTableAnnotationComposer,
          $$RecommendationPresetsTableCreateCompanionBuilder,
          $$RecommendationPresetsTableUpdateCompanionBuilder,
          (RecommendationPreset, $$RecommendationPresetsTableReferences),
          RecommendationPreset,
          PrefetchHooks Function({
            bool productionTypeId,
            bool recommendationGroupsRefs,
          })
        > {
  $$RecommendationPresetsTableTableManager(
    _$AppDatabase db,
    $RecommendationPresetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecommendationPresetsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecommendationPresetsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecommendationPresetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> productionTypeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecommendationPresetsCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                productionTypeId: productionTypeId,
                name: name,
                notes: notes,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String productionTypeId,
                required String name,
                Value<String?> notes = const Value.absent(),
                required int sortOrder,
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecommendationPresetsCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                productionTypeId: productionTypeId,
                name: name,
                notes: notes,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecommendationPresetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productionTypeId = false, recommendationGroupsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recommendationGroupsRefs) db.recommendationGroups,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productionTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productionTypeId,
                                    referencedTable:
                                        $$RecommendationPresetsTableReferences
                                            ._productionTypeIdTable(db),
                                    referencedColumn:
                                        $$RecommendationPresetsTableReferences
                                            ._productionTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recommendationGroupsRefs)
                        await $_getPrefetchedData<
                          RecommendationPreset,
                          $RecommendationPresetsTable,
                          RecommendationGroup
                        >(
                          currentTable: table,
                          referencedTable:
                              $$RecommendationPresetsTableReferences
                                  ._recommendationGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecommendationPresetsTableReferences(
                                db,
                                table,
                                p0,
                              ).recommendationGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.presetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecommendationPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecommendationPresetsTable,
      RecommendationPreset,
      $$RecommendationPresetsTableFilterComposer,
      $$RecommendationPresetsTableOrderingComposer,
      $$RecommendationPresetsTableAnnotationComposer,
      $$RecommendationPresetsTableCreateCompanionBuilder,
      $$RecommendationPresetsTableUpdateCompanionBuilder,
      (RecommendationPreset, $$RecommendationPresetsTableReferences),
      RecommendationPreset,
      PrefetchHooks Function({
        bool productionTypeId,
        bool recommendationGroupsRefs,
      })
    >;
typedef $$RecommendationGroupsTableCreateCompanionBuilder =
    RecommendationGroupsCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String presetId,
      required String categoryId,
      required int ratio,
      Value<int> rowid,
    });
typedef $$RecommendationGroupsTableUpdateCompanionBuilder =
    RecommendationGroupsCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> presetId,
      Value<String> categoryId,
      Value<int> ratio,
      Value<int> rowid,
    });

final class $$RecommendationGroupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecommendationGroupsTable,
          RecommendationGroup
        > {
  $$RecommendationGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecommendationPresetsTable _presetIdTable(_$AppDatabase db) =>
      db.recommendationPresets.createAlias(
        'recommendation_groups__preset_id__recommendation_presets__id',
      );

  $$RecommendationPresetsTableProcessedTableManager get presetId {
    final $_column = $_itemColumn<String>('preset_id')!;

    final manager = $$RecommendationPresetsTableTableManager(
      $_db,
      $_db.recommendationPresets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_presetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.ingredientCategories.createAlias(
        'recommendation_groups__category_id__ingredient_categories__id',
      );

  $$IngredientCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$IngredientCategoriesTableTableManager(
      $_db,
      $_db.ingredientCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecommendationItemsTable,
    List<RecommendationItem>
  >
  _recommendationItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recommendationItems,
        aliasName: 'recommendation_groups__id__recommendation_items__group_id',
      );

  $$RecommendationItemsTableProcessedTableManager get recommendationItemsRefs {
    final manager = $$RecommendationItemsTableTableManager(
      $_db,
      $_db.recommendationItems,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recommendationItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecommendationGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $RecommendationGroupsTable> {
  $$RecommendationGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnFilters(column),
  );

  $$RecommendationPresetsTableFilterComposer get presetId {
    final $$RecommendationPresetsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.presetId,
          referencedTable: $db.recommendationPresets,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationPresetsTableFilterComposer(
                $db: $db,
                $table: $db.recommendationPresets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IngredientCategoriesTableFilterComposer get categoryId {
    final $$IngredientCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ingredientCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recommendationItemsRefs(
    Expression<bool> Function($$RecommendationItemsTableFilterComposer f) f,
  ) {
    final $$RecommendationItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recommendationItems,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecommendationItemsTableFilterComposer(
            $db: $db,
            $table: $db.recommendationItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecommendationGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecommendationGroupsTable> {
  $$RecommendationGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecommendationPresetsTableOrderingComposer get presetId {
    final $$RecommendationPresetsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.presetId,
          referencedTable: $db.recommendationPresets,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationPresetsTableOrderingComposer(
                $db: $db,
                $table: $db.recommendationPresets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IngredientCategoriesTableOrderingComposer get categoryId {
    final $$IngredientCategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RecommendationGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecommendationGroupsTable> {
  $$RecommendationGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ratio =>
      $composableBuilder(column: $table.ratio, builder: (column) => column);

  $$RecommendationPresetsTableAnnotationComposer get presetId {
    final $$RecommendationPresetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.presetId,
          referencedTable: $db.recommendationPresets,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationPresetsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationPresets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IngredientCategoriesTableAnnotationComposer get categoryId {
    final $$IngredientCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> recommendationItemsRefs<T extends Object>(
    Expression<T> Function($$RecommendationItemsTableAnnotationComposer a) f,
  ) {
    final $$RecommendationItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recommendationItems,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecommendationGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecommendationGroupsTable,
          RecommendationGroup,
          $$RecommendationGroupsTableFilterComposer,
          $$RecommendationGroupsTableOrderingComposer,
          $$RecommendationGroupsTableAnnotationComposer,
          $$RecommendationGroupsTableCreateCompanionBuilder,
          $$RecommendationGroupsTableUpdateCompanionBuilder,
          (RecommendationGroup, $$RecommendationGroupsTableReferences),
          RecommendationGroup,
          PrefetchHooks Function({
            bool presetId,
            bool categoryId,
            bool recommendationItemsRefs,
          })
        > {
  $$RecommendationGroupsTableTableManager(
    _$AppDatabase db,
    $RecommendationGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecommendationGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecommendationGroupsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecommendationGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> presetId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> ratio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecommendationGroupsCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                presetId: presetId,
                categoryId: categoryId,
                ratio: ratio,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String presetId,
                required String categoryId,
                required int ratio,
                Value<int> rowid = const Value.absent(),
              }) => RecommendationGroupsCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                presetId: presetId,
                categoryId: categoryId,
                ratio: ratio,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecommendationGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                presetId = false,
                categoryId = false,
                recommendationItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recommendationItemsRefs) db.recommendationItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (presetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.presetId,
                                    referencedTable:
                                        $$RecommendationGroupsTableReferences
                                            ._presetIdTable(db),
                                    referencedColumn:
                                        $$RecommendationGroupsTableReferences
                                            ._presetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$RecommendationGroupsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$RecommendationGroupsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recommendationItemsRefs)
                        await $_getPrefetchedData<
                          RecommendationGroup,
                          $RecommendationGroupsTable,
                          RecommendationItem
                        >(
                          currentTable: table,
                          referencedTable: $$RecommendationGroupsTableReferences
                              ._recommendationItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecommendationGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).recommendationItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecommendationGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecommendationGroupsTable,
      RecommendationGroup,
      $$RecommendationGroupsTableFilterComposer,
      $$RecommendationGroupsTableOrderingComposer,
      $$RecommendationGroupsTableAnnotationComposer,
      $$RecommendationGroupsTableCreateCompanionBuilder,
      $$RecommendationGroupsTableUpdateCompanionBuilder,
      (RecommendationGroup, $$RecommendationGroupsTableReferences),
      RecommendationGroup,
      PrefetchHooks Function({
        bool presetId,
        bool categoryId,
        bool recommendationItemsRefs,
      })
    >;
typedef $$RecommendationItemsTableCreateCompanionBuilder =
    RecommendationItemsCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String groupId,
      required String skuId,
      required int ratio,
      Value<int> rowid,
    });
typedef $$RecommendationItemsTableUpdateCompanionBuilder =
    RecommendationItemsCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> groupId,
      Value<String> skuId,
      Value<int> ratio,
      Value<int> rowid,
    });

final class $$RecommendationItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecommendationItemsTable,
          RecommendationItem
        > {
  $$RecommendationItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecommendationGroupsTable _groupIdTable(_$AppDatabase db) => db
      .recommendationGroups
      .createAlias('recommendation_items__group_id__recommendation_groups__id');

  $$RecommendationGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$RecommendationGroupsTableTableManager(
      $_db,
      $_db.recommendationGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientSkusTable _skuIdTable(_$AppDatabase db) => db.ingredientSkus
      .createAlias('recommendation_items__sku_id__ingredient_skus__id');

  $$IngredientSkusTableProcessedTableManager get skuId {
    final $_column = $_itemColumn<String>('sku_id')!;

    final manager = $$IngredientSkusTableTableManager(
      $_db,
      $_db.ingredientSkus,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_skuIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecommendationItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecommendationItemsTable> {
  $$RecommendationItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnFilters(column),
  );

  $$RecommendationGroupsTableFilterComposer get groupId {
    final $$RecommendationGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.recommendationGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecommendationGroupsTableFilterComposer(
            $db: $db,
            $table: $db.recommendationGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientSkusTableFilterComposer get skuId {
    final $$IngredientSkusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.skuId,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableFilterComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecommendationItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecommendationItemsTable> {
  $$RecommendationItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecommendationGroupsTableOrderingComposer get groupId {
    final $$RecommendationGroupsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.recommendationGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationGroupsTableOrderingComposer(
                $db: $db,
                $table: $db.recommendationGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IngredientSkusTableOrderingComposer get skuId {
    final $$IngredientSkusTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.skuId,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableOrderingComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecommendationItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecommendationItemsTable> {
  $$RecommendationItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ratio =>
      $composableBuilder(column: $table.ratio, builder: (column) => column);

  $$RecommendationGroupsTableAnnotationComposer get groupId {
    final $$RecommendationGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.recommendationGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecommendationGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.recommendationGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IngredientSkusTableAnnotationComposer get skuId {
    final $$IngredientSkusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.skuId,
      referencedTable: $db.ingredientSkus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientSkusTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientSkus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecommendationItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecommendationItemsTable,
          RecommendationItem,
          $$RecommendationItemsTableFilterComposer,
          $$RecommendationItemsTableOrderingComposer,
          $$RecommendationItemsTableAnnotationComposer,
          $$RecommendationItemsTableCreateCompanionBuilder,
          $$RecommendationItemsTableUpdateCompanionBuilder,
          (RecommendationItem, $$RecommendationItemsTableReferences),
          RecommendationItem,
          PrefetchHooks Function({bool groupId, bool skuId})
        > {
  $$RecommendationItemsTableTableManager(
    _$AppDatabase db,
    $RecommendationItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecommendationItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecommendationItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecommendationItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> skuId = const Value.absent(),
                Value<int> ratio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecommendationItemsCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                groupId: groupId,
                skuId: skuId,
                ratio: ratio,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String groupId,
                required String skuId,
                required int ratio,
                Value<int> rowid = const Value.absent(),
              }) => RecommendationItemsCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                groupId: groupId,
                skuId: skuId,
                ratio: ratio,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecommendationItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, skuId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$RecommendationItemsTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$RecommendationItemsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (skuId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.skuId,
                                referencedTable:
                                    $$RecommendationItemsTableReferences
                                        ._skuIdTable(db),
                                referencedColumn:
                                    $$RecommendationItemsTableReferences
                                        ._skuIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecommendationItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecommendationItemsTable,
      RecommendationItem,
      $$RecommendationItemsTableFilterComposer,
      $$RecommendationItemsTableOrderingComposer,
      $$RecommendationItemsTableAnnotationComposer,
      $$RecommendationItemsTableCreateCompanionBuilder,
      $$RecommendationItemsTableUpdateCompanionBuilder,
      (RecommendationItem, $$RecommendationItemsTableReferences),
      RecommendationItem,
      PrefetchHooks Function({bool groupId, bool skuId})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<String> phone,
      Value<String?> notes,
      required DateTime createdAtUtc,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<String> phone,
      Value<String?> notes,
      Value<DateTime> createdAtUtc,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                phone: phone,
                notes: notes,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                phone: phone,
                notes: notes,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$PlaqueTypesTableCreateCompanionBuilder =
    PlaqueTypesCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String name,
      Value<String?> imageHash,
      Value<String?> specification,
      Value<String?> notes,
      required int sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$PlaqueTypesTableUpdateCompanionBuilder =
    PlaqueTypesCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<String?> imageHash,
      Value<String?> specification,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });

class $$PlaqueTypesTableFilterComposer
    extends Composer<_$AppDatabase, $PlaqueTypesTable> {
  $$PlaqueTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageHash => $composableBuilder(
    column: $table.imageHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specification => $composableBuilder(
    column: $table.specification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaqueTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaqueTypesTable> {
  $$PlaqueTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageHash => $composableBuilder(
    column: $table.imageHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specification => $composableBuilder(
    column: $table.specification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaqueTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaqueTypesTable> {
  $$PlaqueTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageHash =>
      $composableBuilder(column: $table.imageHash, builder: (column) => column);

  GeneratedColumn<String> get specification => $composableBuilder(
    column: $table.specification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );
}

class $$PlaqueTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaqueTypesTable,
          PlaqueType,
          $$PlaqueTypesTableFilterComposer,
          $$PlaqueTypesTableOrderingComposer,
          $$PlaqueTypesTableAnnotationComposer,
          $$PlaqueTypesTableCreateCompanionBuilder,
          $$PlaqueTypesTableUpdateCompanionBuilder,
          (
            PlaqueType,
            BaseReferences<_$AppDatabase, $PlaqueTypesTable, PlaqueType>,
          ),
          PlaqueType,
          PrefetchHooks Function()
        > {
  $$PlaqueTypesTableTableManager(_$AppDatabase db, $PlaqueTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaqueTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaqueTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaqueTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imageHash = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaqueTypesCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                imageHash: imageHash,
                specification: specification,
                notes: notes,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String name,
                Value<String?> imageHash = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required int sortOrder,
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaqueTypesCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                imageHash: imageHash,
                specification: specification,
                notes: notes,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaqueTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaqueTypesTable,
      PlaqueType,
      $$PlaqueTypesTableFilterComposer,
      $$PlaqueTypesTableOrderingComposer,
      $$PlaqueTypesTableAnnotationComposer,
      $$PlaqueTypesTableCreateCompanionBuilder,
      $$PlaqueTypesTableUpdateCompanionBuilder,
      (
        PlaqueType,
        BaseReferences<_$AppDatabase, $PlaqueTypesTable, PlaqueType>,
      ),
      PlaqueType,
      PrefetchHooks Function()
    >;
typedef $$AssetCategoriesTableCreateCompanionBuilder =
    AssetCategoriesCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String name,
      required int sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$AssetCategoriesTableUpdateCompanionBuilder =
    AssetCategoriesCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$AssetCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $AssetCategoriesTable, AssetCategory> {
  $$AssetCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AssetsTable, List<Asset>> _assetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.assets,
    aliasName: 'asset_categories__id__assets__category_id',
  );

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AssetCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $AssetCategoriesTable> {
  $$AssetCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assetsRefs(
    Expression<bool> Function($$AssetsTableFilterComposer f) f,
  ) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetCategoriesTable> {
  $$AssetCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetCategoriesTable> {
  $$AssetCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  Expression<T> assetsRefs<T extends Object>(
    Expression<T> Function($$AssetsTableAnnotationComposer a) f,
  ) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetCategoriesTable,
          AssetCategory,
          $$AssetCategoriesTableFilterComposer,
          $$AssetCategoriesTableOrderingComposer,
          $$AssetCategoriesTableAnnotationComposer,
          $$AssetCategoriesTableCreateCompanionBuilder,
          $$AssetCategoriesTableUpdateCompanionBuilder,
          (AssetCategory, $$AssetCategoriesTableReferences),
          AssetCategory,
          PrefetchHooks Function({bool assetsRefs})
        > {
  $$AssetCategoriesTableTableManager(
    _$AppDatabase db,
    $AssetCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetCategoriesCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String name,
                required int sortOrder,
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetCategoriesCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AssetCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (assetsRefs) db.assets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetsRefs)
                    await $_getPrefetchedData<
                      AssetCategory,
                      $AssetCategoriesTable,
                      Asset
                    >(
                      currentTable: table,
                      referencedTable: $$AssetCategoriesTableReferences
                          ._assetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AssetCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).assetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AssetCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetCategoriesTable,
      AssetCategory,
      $$AssetCategoriesTableFilterComposer,
      $$AssetCategoriesTableOrderingComposer,
      $$AssetCategoriesTableAnnotationComposer,
      $$AssetCategoriesTableCreateCompanionBuilder,
      $$AssetCategoriesTableUpdateCompanionBuilder,
      (AssetCategory, $$AssetCategoriesTableReferences),
      AssetCategory,
      PrefetchHooks Function({bool assetsRefs})
    >;
typedef $$AssetStatusesTableCreateCompanionBuilder =
    AssetStatusesCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String name,
      required int sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$AssetStatusesTableUpdateCompanionBuilder =
    AssetStatusesCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$AssetStatusesTableReferences
    extends BaseReferences<_$AppDatabase, $AssetStatusesTable, AssetStatuse> {
  $$AssetStatusesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AssetsTable, List<Asset>> _assetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.assets,
    aliasName: 'asset_statuses__id__assets__status_id',
  );

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager(
      $_db,
      $_db.assets,
    ).filter((f) => f.statusId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AssetStatusesTableFilterComposer
    extends Composer<_$AppDatabase, $AssetStatusesTable> {
  $$AssetStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assetsRefs(
    Expression<bool> Function($$AssetsTableFilterComposer f) f,
  ) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.statusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableFilterComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetStatusesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetStatusesTable> {
  $$AssetStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetStatusesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetStatusesTable> {
  $$AssetStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  Expression<T> assetsRefs<T extends Object>(
    Expression<T> Function($$AssetsTableAnnotationComposer a) f,
  ) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assets,
      getReferencedColumn: (t) => t.statusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.assets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AssetStatusesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetStatusesTable,
          AssetStatuse,
          $$AssetStatusesTableFilterComposer,
          $$AssetStatusesTableOrderingComposer,
          $$AssetStatusesTableAnnotationComposer,
          $$AssetStatusesTableCreateCompanionBuilder,
          $$AssetStatusesTableUpdateCompanionBuilder,
          (AssetStatuse, $$AssetStatusesTableReferences),
          AssetStatuse,
          PrefetchHooks Function({bool assetsRefs})
        > {
  $$AssetStatusesTableTableManager(_$AppDatabase db, $AssetStatusesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetStatusesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetStatusesCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String name,
                required int sortOrder,
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetStatusesCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                name: name,
                sortOrder: sortOrder,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AssetStatusesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (assetsRefs) db.assets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetsRefs)
                    await $_getPrefetchedData<
                      AssetStatuse,
                      $AssetStatusesTable,
                      Asset
                    >(
                      currentTable: table,
                      referencedTable: $$AssetStatusesTableReferences
                          ._assetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AssetStatusesTableReferences(
                            db,
                            table,
                            p0,
                          ).assetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.statusId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AssetStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetStatusesTable,
      AssetStatuse,
      $$AssetStatusesTableFilterComposer,
      $$AssetStatusesTableOrderingComposer,
      $$AssetStatusesTableAnnotationComposer,
      $$AssetStatusesTableCreateCompanionBuilder,
      $$AssetStatusesTableUpdateCompanionBuilder,
      (AssetStatuse, $$AssetStatusesTableReferences),
      AssetStatuse,
      PrefetchHooks Function({bool assetsRefs})
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      required String revisionId,
      required String updatedByDevice,
      required DateTime updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      required String categoryId,
      Value<String?> statusId,
      required String name,
      Value<String?> imageHash,
      required int quantity,
      Value<String?> location,
      Value<String?> purchaseUrl,
      Value<String?> notes,
      Value<DateTime?> lastCountedAtUtc,
      Value<bool> isInactive,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<String> updatedByDevice,
      Value<DateTime> updatedAtUtc,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAtUtc,
      Value<String> categoryId,
      Value<String?> statusId,
      Value<String> name,
      Value<String?> imageHash,
      Value<int> quantity,
      Value<String?> location,
      Value<String?> purchaseUrl,
      Value<String?> notes,
      Value<DateTime?> lastCountedAtUtc,
      Value<bool> isInactive,
      Value<int> rowid,
    });

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, Asset> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .assetCategories
      .createAlias('assets__category_id__asset_categories__id');

  $$AssetCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$AssetCategoriesTableTableManager(
      $_db,
      $_db.assetCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AssetStatusesTable _statusIdTable(_$AppDatabase db) =>
      db.assetStatuses.createAlias('assets__status_id__asset_statuses__id');

  $$AssetStatusesTableProcessedTableManager? get statusId {
    final $_column = $_itemColumn<String>('status_id');
    if ($_column == null) return null;
    final manager = $$AssetStatusesTableTableManager(
      $_db,
      $_db.assetStatuses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_statusIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageHash => $composableBuilder(
    column: $table.imageHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseUrl => $composableBuilder(
    column: $table.purchaseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCountedAtUtc => $composableBuilder(
    column: $table.lastCountedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnFilters(column),
  );

  $$AssetCategoriesTableFilterComposer get categoryId {
    final $$AssetCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.assetCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.assetCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetStatusesTableFilterComposer get statusId {
    final $$AssetStatusesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statusId,
      referencedTable: $db.assetStatuses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetStatusesTableFilterComposer(
            $db: $db,
            $table: $db.assetStatuses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageHash => $composableBuilder(
    column: $table.imageHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseUrl => $composableBuilder(
    column: $table.purchaseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCountedAtUtc => $composableBuilder(
    column: $table.lastCountedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => ColumnOrderings(column),
  );

  $$AssetCategoriesTableOrderingComposer get categoryId {
    final $$AssetCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.assetCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.assetCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetStatusesTableOrderingComposer get statusId {
    final $$AssetStatusesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statusId,
      referencedTable: $db.assetStatuses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetStatusesTableOrderingComposer(
            $db: $db,
            $table: $db.assetStatuses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get revisionId => $composableBuilder(
    column: $table.revisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByDevice => $composableBuilder(
    column: $table.updatedByDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageHash =>
      $composableBuilder(column: $table.imageHash, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get purchaseUrl => $composableBuilder(
    column: $table.purchaseUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCountedAtUtc => $composableBuilder(
    column: $table.lastCountedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isInactive => $composableBuilder(
    column: $table.isInactive,
    builder: (column) => column,
  );

  $$AssetCategoriesTableAnnotationComposer get categoryId {
    final $$AssetCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.assetCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.assetCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AssetStatusesTableAnnotationComposer get statusId {
    final $$AssetStatusesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statusId,
      referencedTable: $db.assetStatuses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssetStatusesTableAnnotationComposer(
            $db: $db,
            $table: $db.assetStatuses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          Asset,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (Asset, $$AssetsTableReferences),
          Asset,
          PrefetchHooks Function({bool categoryId, bool statusId})
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<String> updatedByDevice = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> statusId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imageHash = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> purchaseUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> lastCountedAtUtc = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                categoryId: categoryId,
                statusId: statusId,
                name: name,
                imageHash: imageHash,
                quantity: quantity,
                location: location,
                purchaseUrl: purchaseUrl,
                notes: notes,
                lastCountedAtUtc: lastCountedAtUtc,
                isInactive: isInactive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required String updatedByDevice,
                required DateTime updatedAtUtc,
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAtUtc = const Value.absent(),
                required String categoryId,
                Value<String?> statusId = const Value.absent(),
                required String name,
                Value<String?> imageHash = const Value.absent(),
                required int quantity,
                Value<String?> location = const Value.absent(),
                Value<String?> purchaseUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> lastCountedAtUtc = const Value.absent(),
                Value<bool> isInactive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                revisionId: revisionId,
                updatedByDevice: updatedByDevice,
                updatedAtUtc: updatedAtUtc,
                isDeleted: isDeleted,
                deletedAtUtc: deletedAtUtc,
                categoryId: categoryId,
                statusId: statusId,
                name: name,
                imageHash: imageHash,
                quantity: quantity,
                location: location,
                purchaseUrl: purchaseUrl,
                notes: notes,
                lastCountedAtUtc: lastCountedAtUtc,
                isInactive: isInactive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AssetsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, statusId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$AssetsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$AssetsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (statusId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.statusId,
                                referencedTable: $$AssetsTableReferences
                                    ._statusIdTable(db),
                                referencedColumn: $$AssetsTableReferences
                                    ._statusIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      Asset,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (Asset, $$AssetsTableReferences),
      Asset,
      PrefetchHooks Function({bool categoryId, bool statusId})
    >;
typedef $$LocalDevicesTableCreateCompanionBuilder =
    LocalDevicesCompanion Function({
      required String id,
      Value<int> deviceSeq,
      required DateTime createdAtUtc,
      Value<int> rowid,
    });
typedef $$LocalDevicesTableUpdateCompanionBuilder =
    LocalDevicesCompanion Function({
      Value<String> id,
      Value<int> deviceSeq,
      Value<DateTime> createdAtUtc,
      Value<int> rowid,
    });

class $$LocalDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDevicesTable> {
  $$LocalDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deviceSeq => $composableBuilder(
    column: $table.deviceSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDevicesTable> {
  $$LocalDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deviceSeq => $composableBuilder(
    column: $table.deviceSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDevicesTable> {
  $$LocalDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get deviceSeq =>
      $composableBuilder(column: $table.deviceSeq, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$LocalDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDevicesTable,
          LocalDevice,
          $$LocalDevicesTableFilterComposer,
          $$LocalDevicesTableOrderingComposer,
          $$LocalDevicesTableAnnotationComposer,
          $$LocalDevicesTableCreateCompanionBuilder,
          $$LocalDevicesTableUpdateCompanionBuilder,
          (
            LocalDevice,
            BaseReferences<_$AppDatabase, $LocalDevicesTable, LocalDevice>,
          ),
          LocalDevice,
          PrefetchHooks Function()
        > {
  $$LocalDevicesTableTableManager(_$AppDatabase db, $LocalDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> deviceSeq = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDevicesCompanion(
                id: id,
                deviceSeq: deviceSeq,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> deviceSeq = const Value.absent(),
                required DateTime createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => LocalDevicesCompanion.insert(
                id: id,
                deviceSeq: deviceSeq,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDevicesTable,
      LocalDevice,
      $$LocalDevicesTableFilterComposer,
      $$LocalDevicesTableOrderingComposer,
      $$LocalDevicesTableAnnotationComposer,
      $$LocalDevicesTableCreateCompanionBuilder,
      $$LocalDevicesTableUpdateCompanionBuilder,
      (
        LocalDevice,
        BaseReferences<_$AppDatabase, $LocalDevicesTable, LocalDevice>,
      ),
      LocalDevice,
      PrefetchHooks Function()
    >;
typedef $$SyncOperationsTableCreateCompanionBuilder =
    SyncOperationsCompanion Function({
      required String operationId,
      required String originDeviceId,
      required int deviceSeq,
      required String entityType,
      required String entityId,
      Value<String?> baseRevisionId,
      required String newRevisionId,
      required String operationKind,
      required String payloadJson,
      required DateTime createdAtUtc,
      Value<int> rowid,
    });
typedef $$SyncOperationsTableUpdateCompanionBuilder =
    SyncOperationsCompanion Function({
      Value<String> operationId,
      Value<String> originDeviceId,
      Value<int> deviceSeq,
      Value<String> entityType,
      Value<String> entityId,
      Value<String?> baseRevisionId,
      Value<String> newRevisionId,
      Value<String> operationKind,
      Value<String> payloadJson,
      Value<DateTime> createdAtUtc,
      Value<int> rowid,
    });

class $$SyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deviceSeq => $composableBuilder(
    column: $table.deviceSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseRevisionId => $composableBuilder(
    column: $table.baseRevisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newRevisionId => $composableBuilder(
    column: $table.newRevisionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationKind => $composableBuilder(
    column: $table.operationKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deviceSeq => $composableBuilder(
    column: $table.deviceSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseRevisionId => $composableBuilder(
    column: $table.baseRevisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newRevisionId => $composableBuilder(
    column: $table.newRevisionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationKind => $composableBuilder(
    column: $table.operationKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deviceSeq =>
      $composableBuilder(column: $table.deviceSeq, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get baseRevisionId => $composableBuilder(
    column: $table.baseRevisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newRevisionId => $composableBuilder(
    column: $table.newRevisionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationKind => $composableBuilder(
    column: $table.operationKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$SyncOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOperationsTable,
          SyncOperation,
          $$SyncOperationsTableFilterComposer,
          $$SyncOperationsTableOrderingComposer,
          $$SyncOperationsTableAnnotationComposer,
          $$SyncOperationsTableCreateCompanionBuilder,
          $$SyncOperationsTableUpdateCompanionBuilder,
          (
            SyncOperation,
            BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>,
          ),
          SyncOperation,
          PrefetchHooks Function()
        > {
  $$SyncOperationsTableTableManager(
    _$AppDatabase db,
    $SyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<int> deviceSeq = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String?> baseRevisionId = const Value.absent(),
                Value<String> newRevisionId = const Value.absent(),
                Value<String> operationKind = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion(
                operationId: operationId,
                originDeviceId: originDeviceId,
                deviceSeq: deviceSeq,
                entityType: entityType,
                entityId: entityId,
                baseRevisionId: baseRevisionId,
                newRevisionId: newRevisionId,
                operationKind: operationKind,
                payloadJson: payloadJson,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String originDeviceId,
                required int deviceSeq,
                required String entityType,
                required String entityId,
                Value<String?> baseRevisionId = const Value.absent(),
                required String newRevisionId,
                required String operationKind,
                required String payloadJson,
                required DateTime createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion.insert(
                operationId: operationId,
                originDeviceId: originDeviceId,
                deviceSeq: deviceSeq,
                entityType: entityType,
                entityId: entityId,
                baseRevisionId: baseRevisionId,
                newRevisionId: newRevisionId,
                operationKind: operationKind,
                payloadJson: payloadJson,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOperationsTable,
      SyncOperation,
      $$SyncOperationsTableFilterComposer,
      $$SyncOperationsTableOrderingComposer,
      $$SyncOperationsTableAnnotationComposer,
      $$SyncOperationsTableCreateCompanionBuilder,
      $$SyncOperationsTableUpdateCompanionBuilder,
      (
        SyncOperation,
        BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>,
      ),
      SyncOperation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductionTypesTableTableManager get productionTypes =>
      $$ProductionTypesTableTableManager(_db, _db.productionTypes);
  $$IngredientCategoriesTableTableManager get ingredientCategories =>
      $$IngredientCategoriesTableTableManager(_db, _db.ingredientCategories);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$IngredientSkusTableTableManager get ingredientSkus =>
      $$IngredientSkusTableTableManager(_db, _db.ingredientSkus);
  $$CategoryRatioRangesTableTableManager get categoryRatioRanges =>
      $$CategoryRatioRangesTableTableManager(_db, _db.categoryRatioRanges);
  $$IngredientRatioRangesTableTableManager get ingredientRatioRanges =>
      $$IngredientRatioRangesTableTableManager(_db, _db.ingredientRatioRanges);
  $$SkuRatioOverridesTableTableManager get skuRatioOverrides =>
      $$SkuRatioOverridesTableTableManager(_db, _db.skuRatioOverrides);
  $$RecommendationPresetsTableTableManager get recommendationPresets =>
      $$RecommendationPresetsTableTableManager(_db, _db.recommendationPresets);
  $$RecommendationGroupsTableTableManager get recommendationGroups =>
      $$RecommendationGroupsTableTableManager(_db, _db.recommendationGroups);
  $$RecommendationItemsTableTableManager get recommendationItems =>
      $$RecommendationItemsTableTableManager(_db, _db.recommendationItems);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$PlaqueTypesTableTableManager get plaqueTypes =>
      $$PlaqueTypesTableTableManager(_db, _db.plaqueTypes);
  $$AssetCategoriesTableTableManager get assetCategories =>
      $$AssetCategoriesTableTableManager(_db, _db.assetCategories);
  $$AssetStatusesTableTableManager get assetStatuses =>
      $$AssetStatusesTableTableManager(_db, _db.assetStatuses);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$LocalDevicesTableTableManager get localDevices =>
      $$LocalDevicesTableTableManager(_db, _db.localDevices);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
}
