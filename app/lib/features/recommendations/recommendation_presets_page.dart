import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import 'recommendation_preset_detail_page.dart';

class RecommendationPresetsPage extends StatefulWidget {
  const RecommendationPresetsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<RecommendationPresetsPage> createState() =>
      _RecommendationPresetsPageState();
}

class _RecommendationPresetsPageState extends State<RecommendationPresetsPage> {
  final _search = TextEditingController();
  late final Future<List<ProductionType>> _productionTypes;
  late Stream<List<RecommendationPresetSummary>> _presets;
  String? _productionTypeId;
  var _includeInactive = false;

  @override
  void initState() {
    super.initState();
    _productionTypes = widget.database.getActiveProductionTypes();
    _refresh();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('推荐配置')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _search,
              hintText: '搜索配置名称或制作类型',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(_refresh),
            ),
          ),
          FutureBuilder<List<ProductionType>>(
            future: _productionTypes,
            builder: (context, snapshot) {
              final types = snapshot.data ?? const [];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String?>(
                        isExpanded: true,
                        value: _productionTypeId,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('全部制作类型'),
                          ),
                          for (final type in types)
                            DropdownMenuItem(
                              value: type.id,
                              child: Text(type.name),
                            ),
                        ],
                        onChanged: (value) => setState(() {
                          _productionTypeId = value;
                          _refresh();
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      label: const Text('含停用'),
                      selected: _includeInactive,
                      onSelected: (value) => setState(() {
                        _includeInactive = value;
                        _refresh();
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<RecommendationPresetSummary>>(
              stream: _presets,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  if (_search.text.trim().isNotEmpty ||
                      _productionTypeId != null) {
                    return const Center(child: Text('没有匹配的推荐配置'));
                  }
                  return Center(
                    child: FilledButton.icon(
                      onPressed: () => _edit(),
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一项'),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final canReorder =
                        _search.text.trim().isEmpty &&
                        _productionTypeId == null &&
                        _includeInactive;
                    final details = <String?>[
                      item.productionTypeName,
                      item.preset.notes,
                      if (item.preset.isInactive) '已停用',
                    ].whereType<String>().join(' · ');
                    return ListTile(
                      title: Text(item.preset.name),
                      subtitle: Text(details),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => RecommendationPresetDetailPage(
                            database: widget.database,
                            preset: item.preset,
                          ),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        tooltip: '${item.preset.name}的更多操作',
                        onSelected: (action) => _action(item.preset, action),
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('编辑')),
                          if (canReorder && index > 0)
                            const PopupMenuItem(value: 'up', child: Text('上移')),
                          if (canReorder && index < items.length - 1)
                            const PopupMenuItem(
                              value: 'down',
                              child: Text('下移'),
                            ),
                          const PopupMenuItem(value: 'copy', child: Text('复制')),
                          PopupMenuItem(
                            value: 'inactive',
                            child: Text(item.preset.isInactive ? '启用' : '停用'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('删除'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '添加推荐配置',
        onPressed: () => _edit(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _refresh() {
    _presets = widget.database.watchRecommendationPresets(
      search: _search.text,
      productionTypeId: _productionTypeId,
      includeInactive: _includeInactive,
    );
  }

  Future<void> _edit([RecommendationPreset? preset]) async {
    final types = await widget.database.getActiveProductionTypes(
      includeId: preset?.productionTypeId,
    );
    if (!mounted) return;
    if (types.isEmpty) {
      _message('请先添加可用的制作类型');
      return;
    }
    var name = preset?.name ?? '';
    var notes = preset?.notes ?? '';
    var productionTypeId = preset?.productionTypeId ?? types.first.id;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(preset == null ? '添加推荐配置' : '编辑推荐配置'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: '名称 *'),
                  onChanged: (value) => name = value,
                ),
                DropdownButtonFormField<String>(
                  initialValue: productionTypeId,
                  decoration: const InputDecoration(labelText: '制作类型 *'),
                  items: [
                    for (final type in types)
                      DropdownMenuItem(
                        value: type.id,
                        child: Text(
                          type.isInactive ? '${type.name}（已停用）' : type.name,
                        ),
                      ),
                  ],
                  onChanged: (value) => setDialogState(
                    () => productionTypeId = value ?? productionTypeId,
                  ),
                ),
                TextFormField(
                  initialValue: notes,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '备注'),
                  onChanged: (value) => notes = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  if (preset == null) {
                    await widget.database.createRecommendationPreset(
                      name: name,
                      productionTypeId: productionTypeId,
                      notes: notes,
                    );
                  } else {
                    await widget.database.updateRecommendationPreset(
                      preset.id,
                      name: name,
                      productionTypeId: productionTypeId,
                      notes: notes,
                    );
                  }
                  if (context.mounted) Navigator.pop(context, true);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(_errorText(error))));
                  }
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) _message('已保存');
  }

  Future<void> _action(RecommendationPreset preset, String action) async {
    try {
      if (action == 'edit') return _edit(preset);
      if (action == 'copy') {
        await widget.database.copyRecommendationPreset(preset.id);
      } else if (action == 'up' || action == 'down') {
        await widget.database.moveRecommendationPreset(
          preset.id,
          action == 'up' ? -1 : 1,
        );
      } else if (action == 'inactive') {
        await widget.database.updateRecommendationPreset(
          preset.id,
          name: preset.name,
          productionTypeId: preset.productionTypeId,
          notes: preset.notes,
          isInactive: !preset.isInactive,
        );
      } else if (await _confirmDelete(preset.name)) {
        await widget.database.deleteRecommendationPreset(preset.id);
      }
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  Future<bool> _confirmDelete(String name) async =>
      await showModalBottomSheet<bool>(
        context: context,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '删除“$name”？',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
