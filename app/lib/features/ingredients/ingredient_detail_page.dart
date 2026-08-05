import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import 'ratio_ranges_page.dart';

class IngredientDetailPage extends StatefulWidget {
  const IngredientDetailPage({
    super.key,
    required this.database,
    required this.mediaStore,
    required this.ingredient,
    required this.categoryName,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final Ingredient ingredient;
  final String categoryName;

  @override
  State<IngredientDetailPage> createState() => _IngredientDetailPageState();
}

class _IngredientDetailPageState extends State<IngredientDetailPage> {
  late final Stream<List<IngredientSkusData>> _skus;

  @override
  void initState() {
    super.initState();
    _skus = widget.database.watchIngredientSkus(widget.ingredient.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingredient.name),
        actions: [
          IconButton(
            tooltip: '香料推荐区间',
            icon: const Icon(Icons.straighten_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RatioRangesPage(
                  database: widget.database,
                  target: RatioRangeTarget.ingredient,
                  targetId: widget.ingredient.id,
                  title: '${widget.ingredient.name}推荐区间',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              <String?>[
                widget.categoryName,
                widget.ingredient.alias,
              ].whereType<String>().join(' · '),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<IngredientSkusData>>(
              stream: _skus,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return Center(
                    child: FilledButton.icon(
                      onPressed: () => _editSku(),
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一个 SKU'),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final sku = items[index];
                    final details = <String?>[
                      sku.supplier,
                      sku.origin,
                      if (sku.isInactive) '已停用',
                    ].whereType<String>().join(' · ');
                    return ListTile(
                      leading: sku.imageHash == null
                          ? const SizedBox.square(
                              dimension: 56,
                              child: Icon(Icons.inventory_2_outlined),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                widget.mediaStore.fileFor(sku.imageHash!),
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
                      title: Text(sku.skuCode ?? '未编号 SKU'),
                      subtitle: details.isEmpty ? null : Text(details),
                      onTap: () => _editSku(sku),
                      trailing: PopupMenuButton<String>(
                        tooltip: '${sku.skuCode ?? '未编号 SKU'}的更多操作',
                        onSelected: (action) => _skuAction(sku, action),
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('编辑')),
                          const PopupMenuItem(
                            value: 'image',
                            child: Text('选择图片'),
                          ),
                          if (sku.imageHash != null)
                            const PopupMenuItem(
                              value: 'removeImage',
                              child: Text('移除图片'),
                            ),
                          const PopupMenuItem(
                            value: 'ratio',
                            child: Text('推荐覆盖区间'),
                          ),
                          PopupMenuItem(
                            value: 'inactive',
                            child: Text(sku.isInactive ? '启用' : '停用'),
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
        tooltip: '添加 SKU',
        onPressed: () => _editSku(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editSku([IngredientSkusData? sku]) async {
    var skuCode = sku?.skuCode ?? '';
    var supplier = sku?.supplier ?? '';
    var origin = sku?.origin ?? '';
    var notes = sku?.notes ?? '';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(sku == null ? '添加 SKU' : '编辑 SKU'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: skuCode,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'SKU 编号'),
                onChanged: (value) => skuCode = value,
              ),
              TextFormField(
                initialValue: supplier,
                decoration: const InputDecoration(labelText: '品牌或供应商'),
                onChanged: (value) => supplier = value,
              ),
              TextFormField(
                initialValue: origin,
                decoration: const InputDecoration(labelText: '产地'),
                onChanged: (value) => origin = value,
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
                if (sku == null) {
                  await widget.database.createIngredientSku(
                    ingredientId: widget.ingredient.id,
                    skuCode: skuCode,
                    supplier: supplier,
                    origin: origin,
                    notes: notes,
                  );
                } else {
                  await widget.database.updateIngredientSku(
                    sku.id,
                    skuCode: skuCode,
                    imageHash: sku.imageHash,
                    supplier: supplier,
                    origin: origin,
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
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已保存')));
    }
  }

  Future<void> _skuAction(IngredientSkusData sku, String action) async {
    try {
      if (action == 'edit') return _editSku(sku);
      if (action == 'image') return _pickImage(sku);
      if (action == 'removeImage') {
        await widget.database.updateIngredientSku(
          sku.id,
          skuCode: sku.skuCode,
          imageHash: null,
          supplier: sku.supplier,
          origin: sku.origin,
          notes: sku.notes,
          isInactive: sku.isInactive,
        );
        return;
      }
      if (action == 'ratio') {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RatioRangesPage(
              database: widget.database,
              target: RatioRangeTarget.sku,
              targetId: sku.id,
              title: '${sku.skuCode ?? '未编号 SKU'}推荐区间',
              description: '未设置时继承所属香料的推荐区间。',
            ),
          ),
        );
        return;
      }
      if (action == 'inactive') {
        await widget.database.updateIngredientSku(
          sku.id,
          skuCode: sku.skuCode,
          imageHash: sku.imageHash,
          supplier: sku.supplier,
          origin: sku.origin,
          notes: sku.notes,
          isInactive: !sku.isInactive,
        );
      } else if (await _confirmDelete(sku.skuCode ?? '未编号 SKU')) {
        await widget.database.deleteIngredientSku(sku.id);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorText(error))));
      }
    }
  }

  Future<void> _pickImage(IngredientSkusData sku) async {
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
      await widget.database.updateIngredientSku(
        sku.id,
        skuCode: sku.skuCode,
        imageHash: hash,
        supplier: sku.supplier,
        origin: sku.origin,
        notes: sku.notes,
        isInactive: sku.isInactive,
      );
      if (mounted) _message('已保存');
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
