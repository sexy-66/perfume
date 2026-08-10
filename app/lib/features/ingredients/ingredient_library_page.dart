import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import '../../services/peer_sync_runtime.dart';
import '../../ui/image_picker_cropper.dart';
import '../../ui/single_modal.dart';
import 'ratio_ranges_page.dart';

class IngredientLibraryPage extends StatefulWidget {
  const IngredientLibraryPage({
    super.key,
    required this.database,
    required this.mediaStore,
    this.syncRuntime,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final PeerSyncRuntime? syncRuntime;

  @override
  State<IngredientLibraryPage> createState() => _IngredientLibraryPageState();
}

class _IngredientLibraryPageState extends State<IngredientLibraryPage> {
  final _search = TextEditingController();
  late final Stream<List<IngredientCategory>> _categories;
  late Stream<List<IngredientSummary>> _ingredients;
  String? _categoryId;
  final Set<String> _selected = {};
  bool _quickCategoryOpen = false;
  bool _batchWorking = false;

  bool get _selecting => _selected.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _categories = widget.database.watchIngredientCategories(
      includeInactive: false,
    );
    widget.mediaStore.addListener(_mediaChanged);
    _refreshIngredients();
  }

  @override
  void dispose() {
    widget.mediaStore.removeListener(_mediaChanged);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selecting && !_batchWorking) {
          setState(_selected.clear);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_selecting ? '已选 ${_selected.length} 项' : '香料'),
          leading: _selecting
              ? IconButton(
                  tooltip: '退出多选',
                  onPressed: _batchWorking
                      ? null
                      : () => setState(_selected.clear),
                  icon: const Icon(Icons.close),
                )
              : null,
          actions: _selecting
              ? [
                  IconButton(
                    tooltip: '停用所选香料',
                    onPressed: _batchWorking ? null : _disableSelected,
                    icon: const Icon(Icons.pause_circle_outline),
                  ),
                  IconButton(
                    tooltip: '删除所选香料',
                    onPressed: _batchWorking ? null : _deleteSelected,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ]
              : [
                  IconButton(
                    tooltip: '添加香料',
                    onPressed: _addIngredient,
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    tooltip: '管理分类',
                    icon: const Icon(Icons.category_outlined),
                    onPressed: _openCategories,
                  ),
                ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: SearchBar(
                controller: _search,
                hintText: '搜索名称、别名或分类',
                leading: const Icon(Icons.search),
                trailing: _search.text.isEmpty
                    ? null
                    : [
                        IconButton(
                          tooltip: '清空',
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() {
                            _search.clear();
                            _refreshIngredients();
                          }),
                        ),
                      ],
                onChanged: (_) => setState(_refreshIngredients),
              ),
            ),
            StreamBuilder<List<IngredientCategory>>(
              stream: _categories,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? const [];
                if (_categoryId != null &&
                    !categories.any((item) => item.id == _categoryId)) {
                  _categoryId = null;
                }
                ChoiceChip categoryChip(String label, String? id) {
                  final selected = _categoryId == id;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    showCheckmark: false,
                    color: WidgetStateProperty.all(
                      selected ? const Color(0xffdbeafe) : Colors.white,
                    ),
                    side: BorderSide(
                      color: selected
                          ? const Color(0xff007aff)
                          : const Color(0xffc6c6c8),
                    ),
                    labelStyle: TextStyle(
                      color: selected
                          ? const Color(0xff005eb8)
                          : const Color(0xff1c1c1e),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (_) => setState(() {
                      _categoryId = id;
                      _refreshIngredients();
                    }),
                  );
                }

                return SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      categoryChip('全部', null),
                      for (final category in categories)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: categoryChip(category.name, category.id),
                        ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshFromPeers,
                child: StreamBuilder<List<IngredientSummary>>(
                  stream: _ingredients,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _scrollableFill(
                        Center(child: Text('读取失败：${snapshot.error}')),
                      );
                    }
                    final items = snapshot.data ?? const [];
                    if (items.isEmpty) {
                      if (_search.text.trim().isNotEmpty ||
                          _categoryId != null) {
                        return _scrollableFill(
                          const Center(child: Text('没有匹配的香料')),
                        );
                      }
                      return _scrollableFill(
                        Center(
                          child: FilledButton.icon(
                            onPressed: _addIngredient,
                            icon: const Icon(Icons.add),
                            label: const Text('添加第一项'),
                          ),
                        ),
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 900
                            ? 4
                            : constraints.maxWidth >= 600
                            ? 3
                            : 2;
                        return GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.78,
                              ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final ingredient = item.ingredient;
                            final selected = _selected.contains(ingredient.id);
                            final details = <String?>[
                              item.categoryName,
                              ingredient.alias,
                              if (ingredient.isInactive) '已停用',
                            ].whereType<String>().join(' · ');
                            return Material(
                              color: selected
                                  ? const Color(0xffeaf2ff)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: selected
                                      ? const Color(0xff007aff)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _selecting
                                    ? _toggleSelection(ingredient.id)
                                    : _editIngredient(item),
                                onLongPress: () =>
                                    _toggleSelection(ingredient.id),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ingredient.imageHash == null
                                          ? const ColoredBox(
                                              color: Color(0xffe6e9e7),
                                              child: Icon(
                                                Icons.spa_outlined,
                                                size: 48,
                                                color: Color(0xff566158),
                                              ),
                                            )
                                          : Image.file(
                                              widget.mediaStore.fileFor(
                                                ingredient.imageHash!,
                                              ),
                                              key: ValueKey(
                                                '${ingredient.imageHash}-${widget.mediaStore.revision}',
                                              ),
                                              fit: BoxFit.cover,
                                              cacheWidth: 480,
                                              errorBuilder: (_, _, _) =>
                                                  const ColoredBox(
                                                    color: Color(0xffe6e9e7),
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      size: 48,
                                                      color: Color(0xff566158),
                                                    ),
                                                  ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        12,
                                        12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ingredient.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  details,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xff636366),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (selected)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Color(0xff007aff),
                                              ),
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _selecting
            ? null
            : FloatingActionButton(
                tooltip: '添加香料',
                onPressed: _addIngredient,
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  Future<void> _addIngredient() => _showIngredientForm();

  Future<void> _openCategories() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => IngredientCategoriesPage(database: widget.database),
      ),
    );
    if (!mounted) return;
    setState(() {
      _categoryId = null;
      _refreshIngredients();
    });
  }

  void _toggleSelection(String id) => setState(() {
    if (!_selected.add(id)) _selected.remove(id);
  });

  Future<void> _disableSelected() async {
    final ids = {..._selected};
    setState(() => _batchWorking = true);
    try {
      await widget.database.setIngredientsInactive(ids);
      if (!mounted) return;
      setState(_selected.clear);
      _message('已停用 ${ids.length} 项');
    } catch (error) {
      if (mounted) _message(_errorText(error));
    } finally {
      if (mounted) setState(() => _batchWorking = false);
    }
  }

  Future<void> _deleteSelected() async {
    final ids = {..._selected};
    if (!await _confirmDelete('删除所选 ${ids.length} 项香料？')) return;
    setState(() => _batchWorking = true);
    try {
      await widget.database.deleteIngredients(ids);
      if (!mounted) return;
      setState(_selected.clear);
      _message('已删除 ${ids.length} 项');
    } catch (error) {
      if (mounted) _message(_errorText(error));
    } finally {
      if (mounted) setState(() => _batchWorking = false);
    }
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
      if (mounted) setState(_refreshIngredients);
    }
  }

  Widget _scrollableFill(Widget child) => LayoutBuilder(
    builder: (context, constraints) => ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [SizedBox(height: constraints.maxHeight, child: child)],
    ),
  );

  void _refreshIngredients() {
    _ingredients = widget.database.watchIngredients(
      search: _search.text,
      categoryId: _categoryId,
      includeInactive: false,
    );
  }

  Future<void> _editIngredient(IngredientSummary item) =>
      _showIngredientForm(item: item);

  Future<void> _showIngredientForm({IngredientSummary? item}) async {
    await runSingleModalAction<void>(
      context: context,
      action: 'ingredient-editor',
      body: () async {
        var categories = await widget.database.getActiveIngredientCategories(
          includeId: item?.ingredient.categoryId,
        );
        if (!mounted) return;
        if (categories.isEmpty) {
          final created = await _quickCreateCategory();
          if (created == null) return;
          categories = [created];
        }
        if (!mounted) return;
        var name = item?.ingredient.name ?? '';
        var imageHash = item?.ingredient.imageHash;
        var alias = item?.ingredient.alias ?? '';
        var notes = item?.ingredient.notes ?? '';
        var categoryId = item?.ingredient.categoryId ?? categories.first.id;
        var saving = false;
        var nameError = false;
        var nameShake = 0;
        var pickingImage = false;
        final saved = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: FractionallySizedBox(
                heightFactor: .92,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item == null ? '添加香料' : '编辑香料',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            tooltip: '关闭',
                            onPressed: saving
                                ? null
                                : () => Navigator.pop(context, false),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox.square(
                                    dimension: 72,
                                    child: imageHash == null
                                        ? const ColoredBox(
                                            color: Color(0xffe6e9e7),
                                            child: Icon(Icons.spa_outlined),
                                          )
                                        : Image.file(
                                            widget.mediaStore.fileFor(
                                              imageHash!,
                                            ),
                                            fit: BoxFit.cover,
                                            cacheWidth: 256,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: pickingImage
                                        ? null
                                        : () async {
                                            setDialogState(
                                              () => pickingImage = true,
                                            );
                                            try {
                                              final selected = await _pickImage(
                                                context,
                                              );
                                              if (selected != null &&
                                                  context.mounted) {
                                                setDialogState(
                                                  () => imageHash = selected,
                                                );
                                              }
                                            } catch (error) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _errorText(error),
                                                    ),
                                                  ),
                                                );
                                              }
                                            } finally {
                                              if (context.mounted) {
                                                setDialogState(
                                                  () => pickingImage = false,
                                                );
                                              }
                                            }
                                          },
                                    icon: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                    ),
                                    label: Text(
                                      imageHash == null ? '选择图片' : '更换图片',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TweenAnimationBuilder<double>(
                              key: ValueKey(nameShake),
                              tween: Tween(
                                begin: nameShake == 0 ? 1 : 0,
                                end: 1,
                              ),
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOut,
                              builder: (context, value, child) =>
                                  Transform.translate(
                                    offset: Offset(
                                      math.sin(value * math.pi * 6) * 5,
                                      0,
                                    ),
                                    child: child,
                                  ),
                              child: TextFormField(
                                initialValue: name,
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: '名称 *',
                                  errorText: nameError ? '请输入香料名称' : null,
                                ),
                                onChanged: (value) {
                                  name = value;
                                  if (nameError && value.trim().isNotEmpty) {
                                    setDialogState(() => nameError = false);
                                  }
                                },
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: alias,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: '别名',
                              ),
                              onChanged: (value) => alias = value,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  '香料大类',
                                  style: TextStyle(color: Color(0xff636366)),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () async {
                                    final created = await _quickCreateCategory(
                                      context,
                                    );
                                    if (created != null && context.mounted) {
                                      setDialogState(() {
                                        categories = [...categories, created];
                                        categoryId = created.id;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('新建大类'),
                                ),
                              ],
                            ),
                            DropdownButtonFormField<String>(
                              initialValue: categoryId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: '选择大类 *',
                              ),
                              items: [
                                for (final category in categories)
                                  DropdownMenuItem(
                                    value: category.id,
                                    child: Text(
                                      category.isInactive
                                          ? '${category.name}（已停用）'
                                          : category.name,
                                    ),
                                  ),
                              ],
                              onChanged: (value) => setDialogState(
                                () => categoryId = value ?? categoryId,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: notes,
                              minLines: 2,
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: '备注',
                                alignLabelWithHint: true,
                              ),
                              onChanged: (value) => notes = value,
                            ),
                            if (item != null) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => RatioRangesPage(
                                        database: widget.database,
                                        target: RatioRangeTarget.ingredient,
                                        targetId: item.ingredient.id,
                                        title: '${item.ingredient.name}推荐区间',
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(Icons.tune),
                                  label: const Text('推荐区间'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: FilledButton(
                          onPressed: saving
                              ? null
                              : () async {
                                  if (name.trim().isEmpty) {
                                    setDialogState(() {
                                      nameError = true;
                                      nameShake++;
                                    });
                                    return;
                                  }
                                  setDialogState(() => saving = true);
                                  try {
                                    if (item == null) {
                                      await widget.database.createIngredient(
                                        name: name,
                                        imageHash: imageHash,
                                        alias: alias,
                                        notes: notes,
                                        categoryId: categoryId,
                                      );
                                    } else {
                                      await widget.database.updateIngredient(
                                        item.ingredient.id,
                                        name: name,
                                        imageHash: imageHash,
                                        alias: alias,
                                        notes: notes,
                                        categoryId: categoryId,
                                      );
                                    }
                                    if (context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  } catch (error) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(_errorText(error)),
                                        ),
                                      );
                                      setDialogState(() => saving = false);
                                    }
                                  }
                                },
                          child: Text(saving ? '保存中…' : '保存'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        if (saved == true && mounted) _message('已保存');
      },
    );
  }

  Future<String?> _pickImage(BuildContext context) async {
    return pickAndCropStoredImage(context, widget.mediaStore, aspectRatio: 1);
  }

  Future<IngredientCategory?> _quickCreateCategory([
    BuildContext? modalContext,
  ]) async {
    if (_quickCategoryOpen) return null;
    _quickCategoryOpen = true;
    var name = '';
    try {
      return await showSingleDialog<IngredientCategory>(
        context: modalContext ?? context,
        builder: (context) => AlertDialog(
          title: const Text('新建香料大类'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(labelText: '大类名称 *'),
            onChanged: (value) => name = value,
            onSubmitted: (_) async {
              try {
                final category = await widget.database.createIngredientCategory(
                  name,
                );
                if (context.mounted) Navigator.pop(context, category);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(_errorText(error))));
                }
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  final category = await widget.database
                      .createIngredientCategory(name);
                  if (context.mounted) Navigator.pop(context, category);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(_errorText(error))));
                  }
                }
              },
              child: const Text('创建并选择'),
            ),
          ],
        ),
      );
    } finally {
      _quickCategoryOpen = false;
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<bool> _confirmDelete(String title) async =>
      await showSingleModalBottomSheet<bool>(
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
}

class IngredientCategoriesPage extends StatefulWidget {
  const IngredientCategoriesPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<IngredientCategoriesPage> createState() =>
      _IngredientCategoriesPageState();
}

class _IngredientCategoriesPageState extends State<IngredientCategoriesPage> {
  late final Stream<List<IngredientCategory>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.database.watchIngredientCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('香料分类')),
      body: StreamBuilder<List<IngredientCategory>>(
        stream: _categories,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(
              child: FilledButton.icon(
                onPressed: () => _edit(context),
                icon: const Icon(Icons.add),
                label: const Text('添加第一项'),
              ),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
            buildDefaultDragHandles: false,
            itemCount: items.length,
            onReorderItem: (oldIndex, newIndex) =>
                _reorder(items, oldIndex, newIndex),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                key: ValueKey(item.id),
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  key: ValueKey('ingredient-category-card-${item.id}'),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                    minTileHeight: 64,
                    title: Text(item.name),
                    subtitle: item.isInactive ? const Text('已停用') : null,
                    onTap: () => _edit(context, item),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<String>(
                          tooltip: '${item.name}的更多操作',
                          onSelected: (action) =>
                              _action(context, item, action),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('编辑'),
                            ),
                            const PopupMenuItem(
                              value: 'ratio',
                              child: Text('推荐区间'),
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
                        ReorderableDelayedDragStartListener(
                          index: index,
                          child: Semantics(
                            button: true,
                            label: '长按拖动${item.name}',
                            child: const SizedBox.square(
                              dimension: 48,
                              child: Icon(Icons.drag_handle),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '添加分类',
        onPressed: () => _edit(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _reorder(
    List<IngredientCategory> items,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex == newIndex) return;
    final direction = newIndex > oldIndex ? 1 : -1;
    for (var i = 0; i < (newIndex - oldIndex).abs(); i++) {
      await widget.database.moveIngredientCategory(
        items[oldIndex].id,
        direction,
      );
    }
  }

  Future<void> _edit(
    BuildContext context, [
    IngredientCategory? category,
  ]) async {
    var name = category?.name ?? '';
    final saved = await showSingleDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? '添加分类' : '编辑分类'),
        content: TextFormField(
          initialValue: name,
          autofocus: true,
          decoration: const InputDecoration(labelText: '名称 *'),
          onChanged: (value) => name = value,
          onFieldSubmitted: (value) => _save(context, value, category),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => _save(context, name, category),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已保存')));
    }
  }

  Future<void> _save(
    BuildContext context,
    String name,
    IngredientCategory? category,
  ) async {
    try {
      if (category == null) {
        await widget.database.createIngredientCategory(name);
      } else {
        await widget.database.updateIngredientCategory(category.id, name: name);
      }
      if (context.mounted) Navigator.pop(context, true);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorText(error))));
      }
    }
  }

  Future<void> _action(
    BuildContext context,
    IngredientCategory category,
    String action,
  ) async {
    if (action == 'edit') return _edit(context, category);
    if (action == 'ratio') {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RatioRangesPage(
            database: widget.database,
            target: RatioRangeTarget.category,
            targetId: category.id,
            title: '${category.name}推荐区间',
          ),
        ),
      );
      return;
    }
    try {
      if (action == 'up' || action == 'down') {
        await widget.database.moveIngredientCategory(
          category.id,
          action == 'up' ? -1 : 1,
        );
      } else if (action == 'inactive') {
        await widget.database.updateIngredientCategory(
          category.id,
          isInactive: !category.isInactive,
        );
      } else {
        final confirmed = await showSingleModalBottomSheet<bool>(
          context: context,
          builder: (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '删除“${category.name}”？',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('分类仍被香料使用时不会删除。'),
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
        );
        if (confirmed == true) {
          await widget.database.deleteIngredientCategory(category.id);
        }
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
  if (error is ArgumentError) return error.message.toString();
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
