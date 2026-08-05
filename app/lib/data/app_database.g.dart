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
  late final $LocalDevicesTable localDevices = $LocalDevicesTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productionTypes,
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
          (
            ProductionType,
            BaseReferences<
              _$AppDatabase,
              $ProductionTypesTable,
              ProductionType
            >,
          ),
          ProductionType,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        ProductionType,
        BaseReferences<_$AppDatabase, $ProductionTypesTable, ProductionType>,
      ),
      ProductionType,
      PrefetchHooks Function()
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
  $$LocalDevicesTableTableManager get localDevices =>
      $$LocalDevicesTableTableManager(_db, _db.localDevices);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
}
