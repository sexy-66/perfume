import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import '../../services/peer_sync_runtime.dart';
import 'ratio_ranges_page.dart';

class IngredientDetailPage extends StatefulWidget {
  const IngredientDetailPage({
    super.key,
    required this.database,
    required this.mediaStore,
    this.syncRuntime,
    required this.ingredient,
    required this.categoryName,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final PeerSyncRuntime? syncRuntime;
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
    widget.mediaStore.addListener(_mediaChanged);
  }

  @override
  void dispose() {
    widget.mediaStore.removeListener(_mediaChanged);
    super.dispose();
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ingredient.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      <String?>[
                        widget.categoryName,
                        widget.ingredient.alias,
                      ].whereType<String>().join(' · '),
                      style: const TextStyle(color: Color(0xff636366)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('SKU', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _editSku(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('添加 SKU'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshFromPeers,
              child: StreamBuilder<List<IngredientSkusData>>(
                stream: _skus,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _scrollableFill(
                      Center(child: Text('读取失败：${snapshot.error}')),
                    );
                  }
                  final items = snapshot.data ?? const [];
                  if (items.isEmpty) {
                    return _scrollableFill(
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 36,
                                  color: Color(0xff636366),
                                ),
                                const SizedBox(height: 10),
                                const Text('还没有 SKU'),
                                const SizedBox(height: 4),
                                const Text(
                                  '添加品牌、产地和实物图片',
                                  style: TextStyle(color: Color(0xff636366)),
                                ),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: () => _editSku(),
                                  child: const Text('添加第一个 SKU'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final sku = items[index];
                      final details = <String?>[
                        sku.supplier,
                        sku.origin,
                        if (sku.isInactive) '已停用',
                      ].whereType<String>().join(' · ');
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          minTileHeight: 96,
                          leading: sku.imageHash == null
                              ? const SizedBox.square(
                                  dimension: 72,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color(0xfff2f2f7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                    ),
                                    child: Icon(Icons.inventory_2_outlined),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: ColoredBox(
                                    color: const Color(0xfff2f2f7),
                                    child: Image.file(
                                      widget.mediaStore.fileFor(sku.imageHash!),
                                      key: ValueKey(
                                        '${sku.imageHash}-${widget.mediaStore.revision}',
                                      ),
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) =>
                                          const SizedBox.square(
                                            dimension: 72,
                                            child: Icon(
                                              Icons.broken_image_outlined,
                                            ),
                                          ),
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
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('编辑'),
                              ),
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
                        ),
                      );
                    },
                  );
                },
              ),
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

  void _mediaChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _refreshFromPeers() async {
    try {
      await widget.syncRuntime?.syncAll();
    } catch (error) {
      if (mounted) _message(_errorText(error));
    } finally {
      if (mounted) setState(() {});
    }
  }

  Widget _scrollableFill(Widget child) => LayoutBuilder(
    builder: (context, constraints) => ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [SizedBox(height: constraints.maxHeight, child: child)],
    ),
  );

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
              const SizedBox(height: 12),
              TextFormField(
                initialValue: supplier,
                decoration: const InputDecoration(labelText: '品牌或供应商'),
                onChanged: (value) => supplier = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: origin,
                decoration: const InputDecoration(labelText: '产地'),
                onChanged: (value) => origin = value,
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
}

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
