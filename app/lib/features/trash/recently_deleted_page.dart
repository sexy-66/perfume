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
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 40,
                    color: Color(0xff636366),
                  ),
                  SizedBox(height: 10),
                  Text('最近 30 天没有删除的资料'),
                  SizedBox(height: 4),
                  Text(
                    '删除的资料会在这里保留 30 天',
                    style: TextStyle(color: Color(0xff636366)),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final date = item.deletedAtUtc.toLocal();
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xfff2f2f7),
                    foregroundColor: const Color(0xff636366),
                    child: Icon(
                      item.type == TrashEntityType.ingredient
                          ? Icons.spa_outlined
                          : Icons.inventory_2_outlined,
                    ),
                  ),
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
