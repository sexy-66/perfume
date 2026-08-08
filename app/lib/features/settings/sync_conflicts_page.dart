import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/app_database.dart';

class SyncConflictsPage extends StatelessWidget {
  const SyncConflictsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('同步冲突')),
    body: StreamBuilder<List<SyncConflict>>(
      stream: database.watchPendingSyncConflicts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('读取失败：${snapshot.error}'));
        }
        final conflicts = snapshot.data ?? const [];
        if (conflicts.isEmpty) return const Center(child: Text('没有待处理冲突'));
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          itemCount: conflicts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _ConflictCard(database: database, conflict: conflicts[index]),
        );
      },
    ),
  );
}

class _ConflictCard extends StatelessWidget {
  const _ConflictCard({required this.database, required this.conflict});

  final AppDatabase database;
  final SyncConflict conflict;

  @override
  Widget build(BuildContext context) {
    final first = _snapshot(conflict.firstSnapshotJson);
    final second = _snapshot(conflict.secondSnapshotJson);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _entityLabel(conflict.entityType),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '两台设备修改了同一资料，请选择保留的版本。',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xff636366)),
            ),
            const SizedBox(height: 12),
            _VersionChoice(
              title: _snapshotTitle(first),
              details: _snapshotDetails(first),
              onTap: () => _resolve(context, conflict.firstRevisionId),
            ),
            const SizedBox(height: 8),
            _VersionChoice(
              title: _snapshotTitle(second),
              details: _snapshotDetails(second),
              onTap: () => _resolve(context, conflict.secondRevisionId),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resolve(BuildContext context, String revisionId) async {
    try {
      await database.resolveSyncConflict(
        conflict.id,
        chosenRevisionId: revisionId,
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('处理失败：$error')));
    }
  }
}

class _VersionChoice extends StatelessWidget {
  const _VersionChoice({
    required this.title,
    required this.details,
    required this.onTap,
  });

  final String title;
  final String details;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (details.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            details,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xff636366), fontSize: 12),
          ),
        ],
      ],
    ),
  );
}

Map<String, dynamic> _snapshot(String value) =>
    Map<String, dynamic>.from(jsonDecode(value) as Map);

String _snapshotTitle(Map<String, dynamic> value) {
  for (final field in const ['name', 'skuCode']) {
    final text = value[field];
    if (text is String && text.trim().isNotEmpty) return text.trim();
  }
  return value['isDeleted'] == true ? '已删除版本' : '未命名版本';
}

String _snapshotDetails(Map<String, dynamic> value) =>
    const ['alias', 'supplier', 'origin', 'notes']
        .map((field) => value[field])
        .whereType<String>()
        .where((text) => text.trim().isNotEmpty)
        .join(' · ');

String _entityLabel(String type) => switch (type) {
  'production_types' => '制作类型冲突',
  'ingredient_categories' => '香料分类冲突',
  'ingredients' => '香料冲突',
  'ingredient_skus' => 'SKU 冲突',
  _ => '资料冲突',
};
