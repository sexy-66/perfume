import 'package:flutter/material.dart';

import '../../data/app_database.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('制作类型'),
            subtitle: const Text('新增、排序、停用或删除自定义类型'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => _ProductionTypesPage(database: database),
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
      appBar: AppBar(title: const Text('制作类型')),
      body: StreamBuilder<List<ProductionType>>(
        stream: database.watchProductionTypes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('读取失败：${snapshot.error}'));
          }
          final items = snapshot.data ?? const [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final builtIn = database.isBuiltInProductionType(item.id);
              return ListTile(
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '添加制作类型',
        onPressed: () => _edit(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context, [
    ProductionType? productionType,
  ]) async {
    var name = productionType?.name ?? '';
    await showDialog<void>(
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
    await showModalBottomSheet<bool>(
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
  return '操作失败，请重试';
}
