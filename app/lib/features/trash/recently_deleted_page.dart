import 'package:flutter/material.dart';

import '../../data/app_database.dart';

class RecentlyDeletedPage extends StatelessWidget {
  const RecentlyDeletedPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('最近删除')),
      body: StreamBuilder<List<TrashEntry>>(
        stream: database.watchTrash(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('读取失败：${snapshot.error}'));
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return const Center(child: Text('最近 30 天没有删除的资料'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final date = item.deletedAtUtc.toLocal();
              return ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(item.name),
                subtitle: Text(
                  '${item.type.label} · '
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-'
                  '${date.day.toString().padLeft(2, '0')}',
                ),
                trailing: TextButton(
                  onPressed: () => _restore(context, item),
                  child: const Text('恢复'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _restore(BuildContext context, TrashEntry item) async {
    try {
      await database.restoreTrashEntry(item);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已恢复${item.type.label}“${item.name}”')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorText(error))));
      }
    }
  }
}

String _errorText(Object error) {
  if (error is StateError) return error.message;
  return '恢复失败，请重试';
}
