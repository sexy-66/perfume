import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../ui/single_modal.dart';
import '../../services/peer_discovery.dart';
import '../../services/peer_http_transport.dart';
import '../../services/peer_sync_runtime.dart';
import 'sync_conflicts_page.dart';

class SyncDevicesPage extends StatefulWidget {
  const SyncDevicesPage({super.key, required this.runtime});

  final PeerSyncRuntime runtime;

  @override
  State<SyncDevicesPage> createState() => _SyncDevicesPageState();
}

class _SyncDevicesPageState extends State<SyncDevicesPage> {
  PeerSyncRuntime get runtime => widget.runtime;
  late int _seenSyncCompletion;

  @override
  void initState() {
    super.initState();
    _seenSyncCompletion = runtime.syncCompletionSerial;
    runtime.addListener(_showSyncCompletion);
  }

  @override
  void didUpdateWidget(covariant SyncDevicesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.runtime == runtime) return;
    oldWidget.runtime.removeListener(_showSyncCompletion);
    _seenSyncCompletion = runtime.syncCompletionSerial;
    runtime.addListener(_showSyncCompletion);
  }

  @override
  void dispose() {
    runtime.removeListener(_showSyncCompletion);
    super.dispose();
  }

  void _showSyncCompletion() {
    final serial = runtime.syncCompletionSerial;
    if (serial == _seenSyncCompletion) return;
    _seenSyncCompletion = serial;
    final transferred = runtime.lastSyncTransferredCount;
    if (transferred == 0 && !runtime.lastSyncWasManual) return;
    final text = transferred == 0 ? '同步完成，没有新资料' : '同步完成，已传输 $transferred 项资料';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
        );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('同步与设备')),
    body: AnimatedBuilder(
      animation: runtime,
      builder: (context, _) => StreamBuilder<List<PeerDevice>>(
        stream: runtime.watchDevices(),
        initialData: const [],
        builder: (context, snapshot) =>
            _body(context, snapshot.data ?? const []),
      ),
    ),
  );

  Widget _body(BuildContext context, List<PeerDevice> allDevices) {
    final devices = [
      for (final device in allDevices)
        if (device.id != runtime.identity.deviceId) device,
    ];
    final devicesById = {for (final device in devices) device.id: device};
    final peers = runtime.knownPeers;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _syncCard(
          children: [
            ListTile(
              leading: const Icon(Icons.phone_android_outlined),
              title: Text(runtime.identity.deviceName),
              subtitle: Text('设备 ID：${runtime.identity.deviceId}'),
            ),
            const Divider(height: 1, indent: 16),
            ListTile(title: const Text('设备组'), subtitle: Text(runtime.groupId)),
            ListTile(
              title: const Text('局域网服务'),
              subtitle: Text(_statusText(runtime)),
              trailing: Icon(
                runtime.isRunning
                    ? Icons.check_circle_outline
                    : Icons.pause_circle_outline,
                color: runtime.isRunning
                    ? const Color(0xff34c759)
                    : const Color(0xff8e8e93),
              ),
            ),
            if (runtime.pairingCode != null)
              ListTile(
                title: const Text('本次配对码'),
                subtitle: const Text('首次连接或已移除设备重新加入时使用，一次有效'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      runtime.pairingCode!.value,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      tooltip: '生成新配对码',
                      onPressed: runtime.refreshPairingCode,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            if (runtime.pairingCode == null && runtime.isRunning)
              ListTile(
                title: const Text('配对码已失效'),
                subtitle: const Text('已授权设备仍会自动连接；新增设备时再生成'),
                trailing: TextButton(
                  onPressed: runtime.refreshPairingCode,
                  child: const Text('生成配对码'),
                ),
              ),
            if (runtime.error != null)
              ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('服务启动失败'),
                subtitle: Text('${runtime.error}'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _syncCard(
          children: [
            ListTile(
              leading: const Icon(Icons.sync_outlined),
              title: const Text('同步全部已连接设备'),
              subtitle: Text(
                runtime.isManualSyncing
                    ? '正在同步'
                    : runtime.isSyncing
                    ? '自动同步中'
                    : runtime.lastSyncAtUtc == null
                    ? '尚未同步'
                    : '最近同步：${_syncTime(runtime.lastSyncAtUtc!)}',
              ),
              trailing: FilledButton.icon(
                onPressed: runtime.isManualSyncing || !runtime.canSync
                    ? null
                    : () => _syncAll(context),
                icon: const Icon(Icons.sync, size: 18),
                label: const Text('立即同步'),
              ),
            ),
          ],
        ),
        if (runtime.database != null) ...[
          const SizedBox(height: 12),
          StreamBuilder<List<SyncConflict>>(
            stream: runtime.watchPendingConflicts(),
            initialData: const [],
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return _syncCard(
                children: [
                  ListTile(
                    leading: Icon(
                      count == 0
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_rounded,
                    ),
                    title: const Text('同步冲突'),
                    subtitle: Text(count == 0 ? '没有待处理冲突' : '$count 项待处理'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openConflicts(context),
                  ),
                ],
              );
            },
          ),
        ],
        const SizedBox(height: 22),
        _sectionTitle('已授权设备'),
        _syncCard(children: _memberTiles(context, devices)),
        const SizedBox(height: 22),
        _sectionTitle('发现的设备'),
        _syncCard(
          children: peers.isEmpty
              ? [
                  const ListTile(
                    leading: Icon(Icons.wifi_find),
                    title: Text('暂未发现同组设备'),
                    subtitle: Text('请确认设备在同一 Wi-Fi，并保持应用处于前台'),
                  ),
                ]
              : [
                  for (final peer in peers)
                    _discoveredPeerTile(
                      context,
                      peer,
                      devicesById[peer.advertisement.deviceId],
                    ),
                ],
        ),
      ],
    );
  }

  List<Widget> _memberTiles(BuildContext context, List<PeerDevice> devices) {
    if (devices.isEmpty) {
      return const [
        ListTile(
          leading: Icon(Icons.devices_other_outlined),
          title: Text('还没有已授权设备'),
          subtitle: Text('首次连接成功后会显示在这里'),
        ),
      ];
    }
    return [
      for (var index = 0; index < devices.length; index++) ...[
        if (index > 0) const Divider(height: 1, indent: 56),
        _memberTile(context, devices[index]),
      ],
    ];
  }

  Widget _memberTile(BuildContext context, PeerDevice device) {
    final connected = runtime.isPaired(device.id);
    final lastSync = runtime.lastSyncFor(device.id) ?? device.lastSyncAtUtc;
    final state = device.isRevoked
        ? '已移除，旧授权已撤销'
        : device.isPendingRejoin
        ? '保护性重新加入，等待处理'
        : connected
        ? '已连接'
        : '已授权，同网时自动连接';
    return ListTile(
      leading: const Icon(Icons.devices_outlined),
      title: Text(device.deviceName),
      subtitle: Text(
        '$state\n设备 ID：${device.id}'
        '${lastSync == null ? '' : '\n最近同步：${_syncTime(lastSync)}'}',
      ),
      isThreeLine: lastSync != null,
      trailing: device.isRevoked
          ? const Chip(label: Text('已移除'))
          : device.isPendingRejoin
          ? FilledButton.tonal(
              onPressed: () => _reviewRejoin(context, device),
              child: const Text('处理'),
            )
          : PopupMenuButton<String>(
              tooltip: '${device.deviceName}的设备操作',
              onSelected: (value) {
                if (value == 'remove') _confirmRemove(context, device);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'remove', child: Text('移除设备')),
              ],
            ),
    );
  }

  Widget _discoveredPeerTile(
    BuildContext context,
    PeerDiscoveryPeer peer,
    PeerDevice? device,
  ) {
    final paired = runtime.isPaired(peer.advertisement.deviceId);
    final authorized =
        device != null && !device.isRevoked && !device.isPendingRejoin;
    return ListTile(
      leading: const Icon(Icons.wifi_find),
      title: Text(peer.advertisement.deviceName),
      subtitle: Text(
        '${peer.address.address}:${peer.advertisement.httpPort} · '
        '${paired
            ? '已连接'
            : authorized
            ? '已授权，自动连接中'
            : '未连接'}',
      ),
      trailing: paired
          ? const Chip(label: Text('已连接'))
          : device?.isPendingRejoin == true
          ? const Chip(label: Text('待处理'))
          : authorized
          ? const Chip(label: Text('自动连接'))
          : FilledButton.tonal(
              onPressed: () => _pair(context, peer),
              child: Text(device?.isRevoked == true ? '重新加入' : '连接'),
            ),
    );
  }

  Future<void> _pair(BuildContext context, PeerDiscoveryPeer peer) async {
    var code = '';
    final pairingCode = await showSingleDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('连接设备'),
        content: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(labelText: '输入对方设备显示的 6 位配对码'),
          onChanged: (value) => code = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () =>
                code.length == 6 ? Navigator.pop(context, code) : null,
            child: const Text('连接'),
          ),
        ],
      ),
    );
    if (pairingCode == null || !context.mounted) return;
    try {
      await runtime.pair(peer, pairingCode);
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _syncAll(BuildContext context) async {
    try {
      await runtime.manualSync();
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  void _openConflicts(BuildContext context) {
    final database = runtime.database;
    if (database == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SyncConflictsPage(database: database),
      ),
    );
  }

  Future<void> _reviewRejoin(BuildContext context, PeerDevice device) async {
    await runSingleModalAction<void>(
      context: context,
      action: 'sync-device-rejoin-review',
      body: () async {
        final database = runtime.database;
        if (database == null) return;
        final conflicts = await database.quarantinedConflictCount(device.id);
        if (!context.mounted) return;
        final action = await showSingleModalBottomSheet<String>(
          context: context,
          builder: (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    device.deviceName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    conflicts == 0
                        ? '隔离资料没有未处理冲突，可以完成重新加入。完成后下一轮才会接收设备组数据。'
                        : '隔离资料中有 $conflicts 项冲突，处理完后才能完成重新加入。',
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pop(
                      context,
                      conflicts == 0 ? 'complete' : 'conflicts',
                    ),
                    child: Text(conflicts == 0 ? '完成重新加入' : '处理同步冲突'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'remove'),
                    child: const Text('取消重新加入并保持移除'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            ),
          ),
        );
        if (!context.mounted) return;
        if (action == 'conflicts') return _openConflicts(context);
        if (action == 'remove') return _confirmRemove(context, device);
        if (action != 'complete') return;
        try {
          await runtime.completeDeviceRejoin(device.id);
          if (context.mounted) {
            _message(context, '已完成重新加入，下一轮开始正常同步');
          }
        } catch (error) {
          if (context.mounted) _message(context, _errorText(error));
        }
      },
    );
  }

  Future<void> _confirmRemove(BuildContext context, PeerDevice device) async {
    final confirmed = await showSingleDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('移除“${device.deviceName}”？'),
        content: const Text(
          '该设备的自动连接授权会立即撤销。再次加入必须使用新的 PIN，带回的资料会先隔离，已有资料冲突需人工确认。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xffff3b30),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认移除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await runtime.removeDevice(device.id);
      if (context.mounted) _message(context, '设备已移除，旧授权已撤销');
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 7),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, color: Color(0xff636366)),
    ),
  );

  Widget _syncCard({required List<Widget> children}) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(13),
    clipBehavior: Clip.antiAlias,
    child: Column(children: children),
  );
}

String _syncTime(DateTime value) {
  final local = value.toLocal();
  String two(int part) => part.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}';
}

String _statusText(PeerSyncRuntime runtime) => switch (runtime.status) {
  PeerSyncStatus.stopped => '未运行',
  PeerSyncStatus.starting => '正在启动',
  PeerSyncStatus.running => '已启动，正在监听同组设备',
  PeerSyncStatus.stopping => '正在停止',
  PeerSyncStatus.error => '启动失败',
};

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 7),
            child: Text(
              '资料设置',
              style: TextStyle(fontSize: 13, color: Color(0xff636366)),
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('制作类型'),
              subtitle: const Text('新增、排序、停用或删除自定义类型'),
              trailing: const Icon(
                Icons.chevron_right,
                color: Color(0xffc7c7cc),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => _ProductionTypesPage(database: database),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductionTypesPage extends StatelessWidget {
  const _ProductionTypesPage({required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('制作类型'),
        actions: [
          IconButton(
            tooltip: '添加制作类型',
            onPressed: () => _edit(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<ProductionType>>(
        stream: database.watchProductionTypes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('读取失败：${snapshot.error}'));
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return const Center(
              child: Text(
                '还没有制作类型',
                style: TextStyle(color: Color(0xff636366)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final builtIn = database.isBuiltInProductionType(item.id);
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    [if (builtIn) '内置', if (item.isInactive) '已停用'].join(' · '),
                  ),
                  onTap: () => _edit(context, item),
                  trailing: PopupMenuButton<String>(
                    tooltip: '${item.name}的更多操作',
                    onSelected: (action) => _action(context, item, action),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('编辑')),
                      if (index > 0)
                        const PopupMenuItem(value: 'up', child: Text('上移')),
                      if (index < items.length - 1)
                        const PopupMenuItem(value: 'down', child: Text('下移')),
                      PopupMenuItem(
                        value: 'inactive',
                        child: Text(item.isInactive ? '启用' : '停用'),
                      ),
                      if (!builtIn)
                        const PopupMenuItem(value: 'delete', child: Text('删除')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _edit(
    BuildContext context, [
    ProductionType? productionType,
  ]) async {
    var name = productionType?.name ?? '';
    await showSingleDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(productionType == null ? '添加制作类型' : '编辑制作类型'),
        content: TextFormField(
          initialValue: name,
          autofocus: true,
          decoration: const InputDecoration(labelText: '名称 *'),
          onChanged: (value) => name = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                productionType == null
                    ? await database.createProductionType(name)
                    : await database.updateProductionType(
                        productionType.id,
                        name: name,
                      );
                if (context.mounted) Navigator.pop(context);
              } catch (error) {
                if (context.mounted) _message(context, _errorText(error));
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Future<void> _action(
    BuildContext context,
    ProductionType item,
    String action,
  ) async {
    try {
      switch (action) {
        case 'edit':
          return _edit(context, item);
        case 'up':
          await database.moveProductionType(item.id, -1);
        case 'down':
          await database.moveProductionType(item.id, 1);
        case 'inactive':
          await database.updateProductionType(
            item.id,
            name: item.name,
            isInactive: !item.isInactive,
          );
        case 'delete':
          if (await _confirmDelete(context, item.name)) {
            await database.deleteProductionType(item.id);
          }
      }
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }
}

Future<bool> _confirmDelete(BuildContext context, String name) async =>
    await showSingleModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('删除“$name”？', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('删除后可在最近删除中恢复。'),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffff3b30),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('确认删除'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
            ],
          ),
        ),
      ),
    ) ??
    false;

void _message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  if (error is PeerHttpFailure) return error.message;
  return '操作失败，请重试';
}
