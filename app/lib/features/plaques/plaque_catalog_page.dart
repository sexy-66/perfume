import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import '../../ui/image_picker_cropper.dart';
import '../../ui/single_modal.dart';

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
      appBar: AppBar(
        title: const Text('合香珠 / 香牌'),
        actions: [
          Tooltip(
            message: '添加合香珠 / 香牌',
            child: TextButton.icon(
              onPressed: () => _edit(),
              icon: const Icon(Icons.add, size: 17),
              label: const Text('新建'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SearchBar(
              controller: _search,
              hintText: '搜索名称、规格或备注',
              leading: const Icon(Icons.search),
              trailing: _search.text.isEmpty
                  ? null
                  : [
                      IconButton(
                        tooltip: '清空',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _search.clear();
                          _refresh();
                        }),
                      ),
                    ],
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
                    return const Center(child: Text('没有匹配的合香珠 / 香牌'));
                  }
                  return Center(
                    child: FilledButton.icon(
                      onPressed: () => _edit(),
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一项'),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final canReorder =
                        _search.text.trim().isEmpty && _includeInactive;
                    final details = <String?>[
                      item.specification,
                      item.notes,
                      if (item.isInactive) '已停用',
                    ].whereType<String>().join(' · ');
                    return Material(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        onTap: () => _edit(item),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ColoredBox(
                                color: const Color(0xffe6e9e7),
                                child: item.imageHash == null
                                    ? const Center(
                                        child: Text(
                                          '合香珠 / 香牌',
                                          style: TextStyle(
                                            color: Color(0xff415047),
                                            fontFamily: 'serif',
                                            fontSize: 24,
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        widget.mediaStore.fileFor(
                                          item.imageHash!,
                                        ),
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.broken_image_outlined,
                                        ),
                                      ),
                              ),
                            ),
                            ListTile(
                              title: Text(item.name),
                              subtitle: details.isEmpty ? null : Text(details),
                              trailing: PopupMenuButton<String>(
                                tooltip: '${item.name}的更多操作',
                                onSelected: (action) => _action(item, action),
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('编辑'),
                                  ),
                                  if (canReorder && index > 0)
                                    const PopupMenuItem(
                                      value: 'up',
                                      child: Text('上移'),
                                    ),
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => _PlaqueEditorPage(
          database: widget.database,
          mediaStore: widget.mediaStore,
          item: item,
        ),
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
    try {
      final hash = await pickAndCropStoredImage(
        context,
        widget.mediaStore,
        aspectRatio: 4 / 3,
      );
      if (hash == null) return;
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
      await showSingleModalBottomSheet<bool>(
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

class _PlaqueEditorPage extends StatefulWidget {
  const _PlaqueEditorPage({
    required this.database,
    required this.mediaStore,
    this.item,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final PlaqueType? item;

  @override
  State<_PlaqueEditorPage> createState() => _PlaqueEditorPageState();
}

class _PlaqueEditorPageState extends State<_PlaqueEditorPage> {
  late final _name = TextEditingController(text: widget.item?.name ?? '');
  late final _specification = TextEditingController(
    text: widget.item?.specification ?? '',
  );
  late final _notes = TextEditingController(text: widget.item?.notes ?? '');
  late String? _imageHash = widget.item?.imageHash;
  var _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _specification.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.item == null ? '新建合香珠 / 香牌' : '编辑合香珠 / 香牌'),
      actions: [
        TextButton(onPressed: _saving ? null : _save, child: const Text('保存')),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Material(
          color: const Color(0xffe6e9e7),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _pickImage,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_imageHash == null)
                    const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 42,
                            color: Color(0xff415047),
                          ),
                          SizedBox(height: 8),
                          Text('添加成品图片'),
                        ],
                      ),
                    )
                  else
                    Image.file(
                      widget.mediaStore.fileFor(_imageHash!),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: FilledButton.tonalIcon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(_imageHash == null ? '选择图片' : '更换图片'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_imageHash != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() => _imageHash = null),
              child: const Text('移除图片'),
            ),
          )
        else
          const SizedBox(height: 16),
        TextField(
          controller: _name,
          autofocus: widget.item == null,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: '名称 *'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _specification,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: '规格或说明'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notes,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: '备注',
            alignLabelWithHint: true,
          ),
        ),
      ],
    ),
  );

  Future<void> _pickImage() async {
    try {
      final hash = await pickAndCropStoredImage(
        context,
        widget.mediaStore,
        aspectRatio: 4 / 3,
      );
      if (hash == null) return;
      if (mounted) setState(() => _imageHash = hash);
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final item = widget.item;
      if (item == null) {
        await widget.database.createPlaqueType(
          name: _name.text,
          imageHash: _imageHash,
          specification: _specification.text,
          notes: _notes.text,
        );
      } else {
        await widget.database.updatePlaqueType(
          item.id,
          name: _name.text,
          imageHash: _imageHash,
          specification: _specification.text,
          notes: _notes.text,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        _message(_errorText(error));
      }
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
