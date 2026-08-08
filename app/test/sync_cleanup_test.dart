import 'package:drift/drift.dart';
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

  test('purges an old deletion only after every active peer confirms it', () async {
    final customer = await database.createCustomer(
      name: '待清理顾客',
      phone: '13800000000',
    );
    await database.deleteCustomer(customer.id);
    await database.customUpdate(
      'UPDATE customers SET deleted_at_utc = ? WHERE id = ?',
      variables: [
        Variable(DateTime.now().toUtc().subtract(const Duration(days: 31))),
        Variable(customer.id),
      ],
      updates: {database.customers},
    );
    await database.rememberPeerDevice(
      deviceId: 'peer-a',
      deviceName: '设备 A',
      identityPublicKey: List<int>.filled(32, 1),
    );
    final deletion = await database
        .customSelect(
          "SELECT origin_device_id, device_seq FROM sync_operations WHERE entity_type = 'customers' AND entity_id = ? AND operation_kind = 'delete'",
          variables: [Variable(customer.id)],
        )
        .getSingle();
    final origin = deletion.read<String>('origin_device_id');
    final sequence = deletion.read<int>('device_seq');

    await database.purgeAcknowledgedDeletions();
    expect(await database.select(database.purgedSyncEntities).get(), isEmpty);

    await database.recordPeerSyncState('peer-a', {origin: sequence - 1});
    await database.purgeAcknowledgedDeletions();
    expect(await database.select(database.purgedSyncEntities).get(), isEmpty);

    final syncedAt = DateTime.utc(2026, 8, 8, 12);
    await database.recordPeerSyncState('peer-a', {
      origin: sequence,
    }, now: syncedAt);
    await database.purgeAcknowledgedDeletions();

    final compacted = await (database.select(
      database.customers,
    )..where((row) => row.id.equals(customer.id))).getSingle();
    expect(compacted.isDeleted, isTrue);
    expect(compacted.name, '已删除');
    expect(compacted.phone, isEmpty);
    expect(
      await database.select(database.purgedSyncEntities).get(),
      hasLength(1),
    );
    final remainingOperations = await database
        .customSelect(
          'SELECT operation_kind, payload_json FROM sync_operations WHERE entity_type = ? AND entity_id = ?',
          variables: [Variable('customers'), Variable(customer.id)],
        )
        .get();
    expect(remainingOperations, hasLength(1));
    expect(remainingOperations.single.read<String>('operation_kind'), 'delete');
    expect(
      remainingOperations.single.read<String>('payload_json'),
      '{"id":"${customer.id}","isDeleted":true}',
    );
    expect(
      (await database.peerDevice(
        'peer-a',
      ))?.lastSyncAtUtc?.millisecondsSinceEpoch,
      syncedAt.millisecondsSinceEpoch,
    );
  });

  test('unresolved conflicts block cleanup and revoked peers do not', () async {
    final customer = await database.createCustomer(name: '冲突顾客');
    await database.deleteCustomer(customer.id);
    await database.customUpdate(
      'UPDATE customers SET deleted_at_utc = ? WHERE id = ?',
      variables: [
        Variable(DateTime.now().toUtc().subtract(const Duration(days: 31))),
        Variable(customer.id),
      ],
      updates: {database.customers},
    );
    await database.rememberPeerDevice(
      deviceId: 'peer-b',
      deviceName: '设备 B',
      identityPublicKey: List<int>.filled(32, 2),
    );
    await database.revokePeerDevice('peer-b');
    await database.customInsert(
      '''INSERT INTO sync_conflicts (
           id, entity_type, entity_id, first_revision_id, second_revision_id,
           first_snapshot_json, second_snapshot_json, created_at_utc
         ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
      variables: [
        Variable('conflict-1'),
        Variable('customers'),
        Variable(customer.id),
        Variable('revision-a'),
        Variable('revision-b'),
        Variable('{}'),
        Variable('{}'),
        Variable(DateTime.now().toUtc()),
      ],
      updates: {database.syncConflicts},
    );

    await database.purgeAcknowledgedDeletions();
    expect(await database.select(database.purgedSyncEntities).get(), isEmpty);

    await database.customUpdate(
      'UPDATE sync_conflicts SET resolved_at_utc = ? WHERE id = ?',
      variables: [Variable(DateTime.now().toUtc()), Variable('conflict-1')],
      updates: {database.syncConflicts},
    );
    await database.purgeAcknowledgedDeletions();
    expect(
      await database.select(database.purgedSyncEntities).get(),
      hasLength(1),
    );
  });
}
