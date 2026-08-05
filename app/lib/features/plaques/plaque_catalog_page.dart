import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';

class PlaqueCatalogPage extends StatefulWidget {
  const PlaqueCatalogPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<PlaqueCatalogPage> createState() => _PlaqueCatalogPageState();
}

class _PlaqueCatalogPageState extends State<PlaqueCatalogPage> {
  final _search = TextEditingController();
  late Stream<List<PlaqueType>> _items;
  var _includeInactive = false;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(title: const Text('香牌目录')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _search,
              hintText: '搜索名称、规格或备注',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(_refresh),
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
            child: StreamBuilder<List<PlaqueType>>(
              stream: _items,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  if (_search.text.trim().isNotEmpty) {
                    return const Center(child: Text('没有匹配的香牌'));
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
                        _search.text.trim().isEmpty && _includeInactive;
                    final details = <String?>[
                      item.specification,
                      item.notes,
                      if (item.isInactive) '已停用',
                    ].whereType<String>().join(' · ');
                    return ListTile(
                      leading: item.imageHash == null
                          ? const SizedBox.square(
                              dimension: 56,
                              child: Icon(Icons.style_outlined),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                widget.mediaStore.fileFor(item.imageHash!),
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
                      title: Text(item.name),
                      subtitle: details.isEmpty ? null : Text(details),
                      onTap: () => _edit(item),
                      trailing: PopupMenuButton<String>(
                        tooltip: '${item.name}的更多操作',
                        onSelected: (action) => _action(item, action),
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('编辑')),
                          if (canReorder && index > 0)
                            const PopupMenuItem(value: 'up', child: Text('上移')),
                          if (canReorder && index < items.length - 1)
                            const PopupMenuItem(
                              value: 'down',
                              child: Text('下移'),
                            ),
                          const PopupMenuItem(
                            value: 'image',
                            child: Text('选择图片'),
                          ),
                          if (item.imageHash != null)
                            const PopupMenuItem(
                              value: 'removeImage',
                              child: Text('移除图片'),
                            ),
                          PopupMenuItem(
                            value: 'inactive',
                            child: Text(item.isInactive ? '启用' : '停用'),
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
        tooltip: '添加香牌',
        onPressed: () => _edit(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _refresh() {
    _items = widget.database.watchPlaqueTypes(
      search: _search.text,
      includeInactive: _includeInactive,
    );
  }

  Future<void> _edit([PlaqueType? item]) async {
    var name = item?.name ?? '';
    var specification = item?.specification ?? '';
    var notes = item?.notes ?? '';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? '添加香牌' : '编辑香牌'),
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
              TextFormField(
                initialValue: specification,
                decoration: const InputDecoration(labelText: '规格或说明'),
                onChanged: (value) => specification = value,
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
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                if (item == null) {
                  await widget.database.createPlaqueType(
                    name: name,
                    specification: specification,
                    notes: notes,
                  );
                } else {
                  await widget.database.updatePlaqueType(
                    item.id,
                    name: name,
                    imageHash: item.imageHash,
                    specification: specification,
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
    );
    if (saved == true && mounted) _message('已保存');
  }

  Future<void> _action(PlaqueType item, String action) async {
    try {
      if (action == 'edit') return _edit(item);
      if (action == 'image') return _pickImage(item);
      if (action == 'removeImage') {
        await widget.database.updatePlaqueType(
          item.id,
          name: item.name,
          imageHash: null,
          specification: item.specification,
          notes: item.notes,
          isInactive: item.isInactive,
        );
        return;
      }
      if (action == 'up' || action == 'down') {
        await widget.database.movePlaqueType(item.id, action == 'up' ? -1 : 1);
      } else if (action == 'inactive') {
        await widget.database.updatePlaqueType(
          item.id,
          name: item.name,
          imageHash: item.imageHash,
          specification: item.specification,
          notes: item.notes,
          isInactive: !item.isInactive,
        );
      } else if (await _confirmDelete(item.name)) {
        await widget.database.deletePlaqueType(item.id);
      }
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  Future<void> _pickImage(PlaqueType item) async {
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
      await widget.database.updatePlaqueType(
        item.id,
        name: item.name,
        imageHash: hash,
        specification: item.specification,
        notes: item.notes,
        isInactive: item.isInactive,
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

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
