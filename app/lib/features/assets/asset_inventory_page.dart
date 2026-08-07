import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';

class AssetInventoryPage extends StatefulWidget {
  const AssetInventoryPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<AssetInventoryPage> createState() => _AssetInventoryPageState();
}

class _AssetInventoryPageState extends State<AssetInventoryPage> {
  static const _withoutStatus = '__without_status__';

  final _search = TextEditingController();
  late final Stream<List<AssetCategory>> _categories;
  late final Stream<List<AssetStatuse>> _statuses;
  late Stream<List<AssetSummary>> _assets;
  String? _categoryId;
  String? _statusId;
  var _includeInactive = false;

  @override
  void initState() {
    super.initState();
    _categories = widget.database.watchAssetCategories();
    _statuses = widget.database.watchAssetStatuses();
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
      appBar: AppBar(
        title: const Text('资产清点'),
        actions: [
          IconButton(
            tooltip: '管理分类与状态',
            icon: const Icon(Icons.tune),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => _AssetOptionsPage(database: widget.database),
                ),
              );
              if (mounted) {
                setState(() {
                  _categoryId = null;
                  _statusId = null;
                  _refresh();
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _search,
              hintText: '搜索名称、分类、位置或状态',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(_refresh),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _categoryFilter()),
                const SizedBox(width: 12),
                Expanded(child: _statusFilter()),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilterChip(
                label: const Text('含停用'),
                selected: _includeInactive,
                onSelected: (value) => setState(() {
                  _includeInactive = value;
                  _refresh();
                }),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AssetSummary>>(
              stream: _assets,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  if (_search.text.trim().isNotEmpty ||
                      _categoryId != null ||
                      _statusId != null) {
                    return const Center(child: Text('没有匹配的资产'));
                  }
                  return Center(
                    child: FilledButton.icon(
                      onPressed: () => _edit(),
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一项资产'),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final asset = item.asset;
                    final details = <String?>[
                      item.categoryName,
                      item.statusName,
                      asset.location,
                      if (asset.lastCountedAtUtc != null)
                        '上次清点 ${_formatDateTime(asset.lastCountedAtUtc!)}',
                      if (asset.isInactive) '已停用',
                    ].whereType<String>().join(' · ');
                    return ListTile(
                      leading: asset.imageHash == null
                          ? const SizedBox.square(
                              dimension: 56,
                              child: Icon(Icons.inventory_2_outlined),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                widget.mediaStore.fileFor(asset.imageHash!),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox.square(
                                      dimension: 56,
                                      child: Icon(Icons.broken_image_outlined),
                                    ),
                              ),
                            ),
                      title: Text('${asset.name} × ${asset.quantity}'),
                      subtitle: Text(details),
                      onTap: () => _edit(asset),
                      trailing: PopupMenuButton<String>(
                        tooltip: '${asset.name}的更多操作',
                        onSelected: (action) => _action(asset, action),
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'count',
                            child: Text('清点数量'),
                          ),
                          const PopupMenuItem(value: 'edit', child: Text('编辑')),
                          const PopupMenuItem(
                            value: 'image',
                            child: Text('选择图片'),
                          ),
                          if (asset.imageHash != null)
                            const PopupMenuItem(
                              value: 'removeImage',
                              child: Text('移除图片'),
                            ),
                          PopupMenuItem(
                            value: 'inactive',
                            child: Text(asset.isInactive ? '启用' : '停用'),
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
        tooltip: '添加资产',
        onPressed: () => _edit(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _categoryFilter() => StreamBuilder<List<AssetCategory>>(
    stream: _categories,
    builder: (context, snapshot) {
      final items = snapshot.data ?? const [];
      return DropdownButton<String?>(
        isExpanded: true,
        value: items.any((item) => item.id == _categoryId) ? _categoryId : null,
        items: [
          const DropdownMenuItem(value: null, child: Text('全部分类')),
          for (final item in items)
            DropdownMenuItem(value: item.id, child: Text(item.name)),
        ],
        onChanged: (value) => setState(() {
          _categoryId = value;
          _refresh();
        }),
      );
    },
  );

  Widget _statusFilter() => StreamBuilder<List<AssetStatuse>>(
    stream: _statuses,
    builder: (context, snapshot) {
      final items = snapshot.data ?? const [];
      return DropdownButton<String?>(
        isExpanded: true,
        value: items.any((item) => item.id == _statusId) ? _statusId : null,
        items: [
          const DropdownMenuItem(value: null, child: Text('全部状态')),
          const DropdownMenuItem(value: _withoutStatus, child: Text('未设置状态')),
          for (final item in items)
            DropdownMenuItem(value: item.id, child: Text(item.name)),
        ],
        onChanged: (value) => setState(() {
          _statusId = value;
          _refresh();
        }),
      );
    },
  );

  void _refresh() {
    _assets = widget.database.watchAssets(
      search: _search.text,
      categoryId: _categoryId,
      statusId: _statusId == _withoutStatus ? null : _statusId,
      withoutStatus: _statusId == _withoutStatus,
      includeInactive: _includeInactive,
    );
  }

  Future<void> _edit([Asset? asset]) async {
    final categories = await widget.database.getActiveAssetCategories(
      includeId: asset?.categoryId,
    );
    final statuses = await widget.database.getActiveAssetStatuses(
      includeId: asset?.statusId,
    );
    if (!mounted) return;
    if (categories.isEmpty) {
      _message('请先添加可用的资产分类');
      return;
    }
    var name = asset?.name ?? '';
    var categoryId = asset?.categoryId ?? categories.first.id;
    var statusId = asset?.statusId;
    var quantity = '${asset?.quantity ?? 0}';
    var location = asset?.location ?? '';
    var notes = asset?.notes ?? '';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(asset == null ? '添加资产' : '编辑资产'),
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
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: categoryId,
                  decoration: const InputDecoration(labelText: '分类 *'),
                  items: [
                    for (final item in categories)
                      DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          item.isInactive ? '${item.name}（已停用）' : item.name,
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => categoryId = value!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: statusId,
                  decoration: const InputDecoration(labelText: '状态'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('未设置')),
                    for (final item in statuses)
                      DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          item.isInactive ? '${item.name}（已停用）' : item.name,
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => statusId = value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: quantity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '当前数量 *'),
                  onChanged: (value) => quantity = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: location,
                  decoration: const InputDecoration(labelText: '存放位置'),
                  onChanged: (value) => location = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: notes,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: '备注',
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) => notes = value,
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
                  final parsed = int.tryParse(quantity);
                  if (parsed == null) throw ArgumentError('数量必须是整数');
                  if (asset == null) {
                    await widget.database.createAsset(
                      name: name,
                      categoryId: categoryId,
                      statusId: statusId,
                      quantity: parsed,
                      location: location,
                      notes: notes,
                    );
                  } else {
                    await widget.database.updateAsset(
                      asset.id,
                      name: name,
                      categoryId: categoryId,
                      statusId: statusId,
                      imageHash: asset.imageHash,
                      quantity: parsed,
                      location: location,
                      notes: notes,
                    );
                  }
                  if (context.mounted) Navigator.pop(context, true);
                } catch (error) {
                  if (context.mounted) _message(_errorText(error), context);
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

  Future<void> _action(Asset asset, String action) async {
    try {
      if (action == 'edit') return _edit(asset);
      if (action == 'image') return _pickImage(asset);
      if (action == 'removeImage') {
        await widget.database.updateAsset(
          asset.id,
          name: asset.name,
          categoryId: asset.categoryId,
          statusId: asset.statusId,
          imageHash: null,
          quantity: asset.quantity,
          location: asset.location,
          notes: asset.notes,
          isInactive: asset.isInactive,
        );
        return;
      }
      if (action == 'count') return _count(asset);
      if (action == 'inactive') {
        await widget.database.updateAsset(
          asset.id,
          name: asset.name,
          categoryId: asset.categoryId,
          statusId: asset.statusId,
          imageHash: asset.imageHash,
          quantity: asset.quantity,
          location: asset.location,
          notes: asset.notes,
          isInactive: !asset.isInactive,
        );
      } else if (await _confirmDelete(asset.name)) {
        await widget.database.deleteAsset(asset.id);
      }
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  Future<void> _count(Asset asset) async {
    var value = '${asset.quantity}';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('清点${asset.name}'),
        content: TextFormField(
          initialValue: value,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '当前数量'),
          onChanged: (text) => value = text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final quantity = int.tryParse(value);
                if (quantity == null) throw ArgumentError('数量必须是整数');
                await widget.database.countAsset(asset.id, quantity);
                if (context.mounted) Navigator.pop(context, true);
              } catch (error) {
                if (context.mounted) _message(_errorText(error), context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (saved == true && mounted) _message('已完成清点');
  }

  Future<void> _pickImage(Asset asset) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final selected = await ImagePicker().pickImage(source: source);
      if (selected == null) return;
      final hash = await widget.mediaStore.putImage(
        await selected.readAsBytes(),
      );
      await widget.database.updateAsset(
        asset.id,
        name: asset.name,
        categoryId: asset.categoryId,
        statusId: asset.statusId,
        imageHash: hash,
        quantity: asset.quantity,
        location: asset.location,
        notes: asset.notes,
        isInactive: asset.isInactive,
      );
      if (mounted) _message('已保存');
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

  void _message(String text, [BuildContext? target]) {
    ScaffoldMessenger.of(
      target ?? context,
    ).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _AssetOptionsPage extends StatelessWidget {
  const _AssetOptionsPage({required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('资产分类与状态')),
      body: ListView(
        children: [
          _heading(context, '分类', () => _edit(context, true)),
          StreamBuilder<List<AssetCategory>>(
            stream: database.watchAssetCategories(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              return Column(
                children: [
                  for (var index = 0; index < items.length; index++)
                    _option(
                      context,
                      true,
                      items[index].id,
                      items[index].name,
                      items[index].isInactive,
                      index,
                      items.length,
                    ),
                ],
              );
            },
          ),
          const Divider(),
          _heading(context, '状态', () => _edit(context, false)),
          StreamBuilder<List<AssetStatuse>>(
            stream: database.watchAssetStatuses(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              return Column(
                children: [
                  for (var index = 0; index < items.length; index++)
                    _option(
                      context,
                      false,
                      items[index].id,
                      items[index].name,
                      items[index].isInactive,
                      index,
                      items.length,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String title, VoidCallback add) =>
      ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        trailing: IconButton(
          tooltip: '添加$title',
          icon: const Icon(Icons.add),
          onPressed: add,
        ),
      );

  Widget _option(
    BuildContext context,
    bool category,
    String id,
    String name,
    bool inactive,
    int index,
    int count,
  ) => ListTile(
    title: Text(name),
    subtitle: inactive ? const Text('已停用') : null,
    onTap: () => _edit(context, category, id: id, name: name),
    trailing: PopupMenuButton<String>(
      tooltip: '$name的更多操作',
      onSelected: (action) =>
          _optionAction(context, category, id, name, inactive, action),
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('编辑')),
        if (index > 0) const PopupMenuItem(value: 'up', child: Text('上移')),
        if (index < count - 1)
          const PopupMenuItem(value: 'down', child: Text('下移')),
        PopupMenuItem(value: 'inactive', child: Text(inactive ? '启用' : '停用')),
        const PopupMenuItem(value: 'delete', child: Text('删除')),
      ],
    ),
  );

  Future<void> _edit(
    BuildContext context,
    bool category, {
    String? id,
    String name = '',
  }) async {
    var value = name;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${id == null ? '添加' : '编辑'}资产${category ? '分类' : '状态'}'),
        content: TextFormField(
          initialValue: value,
          autofocus: true,
          decoration: const InputDecoration(labelText: '名称 *'),
          onChanged: (text) => value = text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                if (category) {
                  id == null
                      ? await database.createAssetCategory(value)
                      : await database.updateAssetCategory(id, name: value);
                } else {
                  id == null
                      ? await database.createAssetStatus(value)
                      : await database.updateAssetStatus(id, name: value);
                }
                if (context.mounted) Navigator.pop(context);
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
    );
  }

  Future<void> _optionAction(
    BuildContext context,
    bool category,
    String id,
    String name,
    bool inactive,
    String action,
  ) async {
    try {
      if (action == 'edit') return _edit(context, category, id: id, name: name);
      if (action == 'up' || action == 'down') {
        category
            ? await database.moveAssetCategory(id, action == 'up' ? -1 : 1)
            : await database.moveAssetStatus(id, action == 'up' ? -1 : 1);
        return;
      }
      if (action == 'delete' &&
          !await _confirmOptionDelete(
            context,
            '删除资产${category ? '分类' : '状态'}“$name”？',
          )) {
        return;
      }
      if (category) {
        action == 'inactive'
            ? await database.updateAssetCategory(
                id,
                name: name,
                isInactive: !inactive,
              )
            : await database.deleteAssetCategory(id);
      } else {
        action == 'inactive'
            ? await database.updateAssetStatus(
                id,
                name: name,
                isInactive: !inactive,
              )
            : await database.deleteAssetStatus(id);
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

Future<bool> _confirmOptionDelete(BuildContext context, String title) async =>
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

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  String two(int part) => part.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}';
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
