import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../ingredients/ratio_ranges_page.dart';

class RecommendationPresetDetailPage extends StatelessWidget {
  const RecommendationPresetDetailPage({
    super.key,
    required this.database,
    required this.preset,
  });

  final AppDatabase database;
  final RecommendationPreset preset;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RecommendationGroupSummary>>(
      stream: database.watchRecommendationGroups(preset.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(preset.name)),
            body: Center(child: Text('读取失败：${snapshot.error}')),
          );
        }
        final groups = snapshot.data ?? const [];
        final total = groups.fold(0, (sum, group) => sum + group.ratio);
        final complete =
            groups.isNotEmpty &&
            total == 10000 &&
            groups.every((group) => group.itemTotal == group.ratio);
        return Scaffold(
          appBar: AppBar(title: Text(preset.name)),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              ListTile(
                leading: Icon(
                  complete ? Icons.check_circle : Icons.pending_outlined,
                  color: complete ? Colors.green : null,
                ),
                title: Text(complete ? '配置已完成' : '配置待完善'),
                subtitle: Text(
                  '大类合计 ${formatRatioPercentage(total)}% / 100.00%',
                ),
              ),
              const Divider(height: 1),
              if (groups.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('添加大类并设置固定比例')),
                ),
              for (final group in groups)
                ListTile(
                  title: Text(group.categoryName),
                  subtitle: Text(
                    '大类 ${formatRatioPercentage(group.ratio)}% · '
                    'SKU ${formatRatioPercentage(group.itemTotal)}%',
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => _RecommendationItemsPage(
                        database: database,
                        group: group,
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    tooltip: '${group.categoryName}的更多操作',
                    onSelected: (action) => action == 'edit'
                        ? _editGroup(context, group)
                        : _deleteGroup(context, group),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('修改比例')),
                      PopupMenuItem(value: 'delete', child: Text('删除')),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addGroup(context, groups),
            icon: const Icon(Icons.add),
            label: const Text('添加大类'),
          ),
        );
      },
    );
  }

  Future<void> _addGroup(
    BuildContext context,
    List<RecommendationGroupSummary> groups,
  ) async {
    final used = groups.map((group) => group.categoryId).toSet();
    final categories = (await database.getActiveIngredientCategories())
        .where((category) => !used.contains(category.id))
        .toList();
    if (!context.mounted) return;
    if (categories.isEmpty) return _message(context, '没有可添加的大类');
    var categoryId = categories.first.id;
    var ratio = '';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('添加大类比例'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: categoryId,
                  decoration: const InputDecoration(labelText: '大类'),
                  items: [
                    for (final category in categories)
                      DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                  ],
                  onChanged: (value) => setState(() => categoryId = value!),
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: '固定比例',
                    suffixText: '%',
                  ),
                  onChanged: (value) => ratio = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  await database.createRecommendationGroup(
                    presetId: preset.id,
                    categoryId: categoryId,
                    ratio: parseRatioPercentage(ratio),
                  );
                  if (context.mounted) Navigator.pop(context, true);
                } catch (error) {
                  if (context.mounted) _message(context, _errorText(error));
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && context.mounted) _message(context, '已保存');
  }

  Future<void> _editGroup(
    BuildContext context,
    RecommendationGroupSummary group,
  ) async {
    final ratio = await _askRatio(
      context,
      '修改${group.categoryName}比例',
      group.ratio,
    );
    if (ratio == null) return;
    try {
      await database.updateRecommendationGroupRatio(group.id, ratio);
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _deleteGroup(
    BuildContext context,
    RecommendationGroupSummary group,
  ) async {
    if (!await _confirmDelete(context, '删除“${group.categoryName}”大类比例？')) {
      return;
    }
    try {
      await database.deleteRecommendationGroup(group.id);
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }
}

class _RecommendationItemsPage extends StatelessWidget {
  const _RecommendationItemsPage({required this.database, required this.group});

  final AppDatabase database;
  final RecommendationGroupSummary group;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RecommendationItemSummary>>(
      stream: database.watchRecommendationItems(group.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(group.categoryName)),
            body: Center(child: Text('读取失败：${snapshot.error}')),
          );
        }
        final items = snapshot.data ?? const [];
        final total = items.fold(0, (sum, item) => sum + item.ratio);
        return Scaffold(
          appBar: AppBar(title: Text('${group.categoryName} SKU')),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              ListTile(
                leading: Icon(
                  total == 0 || total == group.ratio
                      ? Icons.check_circle_outline
                      : Icons.pending_outlined,
                ),
                title: Text(
                  total == 0
                      ? '未细分 SKU'
                      : 'SKU 合计 ${formatRatioPercentage(total)}%',
                ),
                subtitle: Text('大类比例 ${formatRatioPercentage(group.ratio)}%'),
              ),
              const Divider(height: 1),
              for (final item in items)
                ListTile(
                  title: Text(item.ingredientName),
                  subtitle: item.skuCode == null ? null : Text(item.skuCode!),
                  trailing: PopupMenuButton<String>(
                    tooltip: '${item.ingredientName}的更多操作',
                    icon: Text('${formatRatioPercentage(item.ratio)}%'),
                    onSelected: (action) => action == 'edit'
                        ? _editItem(context, item)
                        : _deleteItem(context, item),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('修改比例')),
                      PopupMenuItem(value: 'delete', child: Text('删除')),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addItem(context, items),
            icon: const Icon(Icons.add),
            label: const Text('添加 SKU'),
          ),
        );
      },
    );
  }

  Future<void> _addItem(
    BuildContext context,
    List<RecommendationItemSummary> items,
  ) async {
    final used = items.map((item) => item.skuId).toSet();
    final choices = (await database.getActiveSkusForCategory(
      group.categoryId,
    )).where((choice) => !used.contains(choice.id)).toList();
    if (!context.mounted) return;
    if (choices.isEmpty) return _message(context, '该大类没有可添加的 SKU');
    var skuId = choices.first.id;
    var ratio = '';
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('添加 SKU 比例'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: skuId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'SKU'),
                  items: [
                    for (final choice in choices)
                      DropdownMenuItem(
                        value: choice.id,
                        child: Text(choice.label),
                      ),
                  ],
                  onChanged: (value) => setState(() => skuId = value!),
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: '固定比例',
                    suffixText: '%',
                  ),
                  onChanged: (value) => ratio = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  await database.createRecommendationItem(
                    groupId: group.id,
                    skuId: skuId,
                    ratio: parseRatioPercentage(ratio),
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
      ),
    );
  }

  Future<void> _editItem(
    BuildContext context,
    RecommendationItemSummary item,
  ) async {
    final ratio = await _askRatio(
      context,
      '修改${item.ingredientName}比例',
      item.ratio,
    );
    if (ratio == null) return;
    try {
      await database.updateRecommendationItemRatio(item.id, ratio);
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _deleteItem(
    BuildContext context,
    RecommendationItemSummary item,
  ) async {
    if (!await _confirmDelete(context, '删除“${item.ingredientName}”SKU 比例？')) {
      return;
    }
    try {
      await database.deleteRecommendationItem(item.id);
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }
}

Future<bool> _confirmDelete(BuildContext context, String title) async =>
    await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('此操作无法从最近删除中恢复。'),
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

Future<int?> _askRatio(BuildContext context, String title, int current) async {
  var text = formatRatioPercentage(current);
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextFormField(
        initialValue: text,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: '固定比例', suffixText: '%'),
        onChanged: (value) => text = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            try {
              Navigator.pop(context, parseRatioPercentage(text));
            } catch (error) {
              _message(context, _errorText(error));
            }
          },
          child: const Text('保存'),
        ),
      ],
    ),
  );
}

void _message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
