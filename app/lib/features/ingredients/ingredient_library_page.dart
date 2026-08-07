import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import 'ingredient_detail_page.dart';
import 'ratio_ranges_page.dart';

class IngredientLibraryPage extends StatefulWidget {
  const IngredientLibraryPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<IngredientLibraryPage> createState() => _IngredientLibraryPageState();
}

class _IngredientLibraryPageState extends State<IngredientLibraryPage> {
  final _search = TextEditingController();
  late final Stream<List<IngredientCategory>> _categories;
  late Stream<List<IngredientSummary>> _ingredients;
  String? _categoryId;

  @override
  void initState() {
    super.initState();
    _categories = widget.database.watchIngredientCategories(
      includeInactive: false,
    );
    _refreshIngredients();
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
        title: const Text('香料'),
        actions: [
          TextButton.icon(
            onPressed: _addIngredient,
            icon: const Icon(Icons.add, size: 17),
            label: const Text('添加'),
          ),
          IconButton(
            tooltip: '管理分类',
            icon: const Icon(Icons.category_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      IngredientCategoriesPage(database: widget.database),
                ),
              );
              if (mounted) {
                setState(() {
                  _categoryId = null;
                  _refreshIngredients();
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
              hintText: '搜索名称、别名、SKU、供应商或分类',
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
            child: StreamBuilder<List<IngredientSummary>>(
              stream: _ingredients,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  if (_search.text.trim().isNotEmpty || _categoryId != null) {
                    return const Center(child: Text('没有匹配的香料'));
                  }
                  return Center(
                    child: FilledButton.icon(
                      onPressed: _addIngredient,
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一项'),
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
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final ingredient = item.ingredient;
                        final details = <String?>[
                          item.categoryName,
                          ingredient.alias,
                          if (ingredient.isInactive) '已停用',
                        ].whereType<String>().join(' · ');
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => IngredientDetailPage(
                                  database: widget.database,
                                  mediaStore: widget.mediaStore,
                                  ingredient: ingredient,
                                  categoryName: item.categoryName,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: item.firstSkuImageHash == null
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
                                            item.firstSkuImageHash!,
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              const ColoredBox(
                                                color: Color(0xffe6e9e7),
                                                child: Icon(
                                                  Icons.broken_image_outlined,
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
                                    4,
                                    8,
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
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              details,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xff636366),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        tooltip: '${ingredient.name}的更多操作',
                                        onSelected: (action) =>
                                            _ingredientAction(item, action),
                                        itemBuilder: (_) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('编辑'),
                                          ),
                                          PopupMenuItem(
                                            value: 'inactive',
                                            child: Text(
                                              ingredient.isInactive
                                                  ? '启用'
                                                  : '停用',
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('删除'),
                                          ),
                                        ],
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '添加香料',
        onPressed: _addIngredient,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addIngredient() => _showIngredientForm();

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
    var alias = item?.ingredient.alias ?? '';
    var categoryId = item?.ingredient.categoryId ?? categories.first.id;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(item == null ? '添加香料' : '编辑香料'),
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
                TextFormField(
                  initialValue: alias,
                  decoration: const InputDecoration(labelText: '别名'),
                  onChanged: (value) => alias = value,
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
                        final created = await _quickCreateCategory();
                        if (created != null) {
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
                  decoration: const InputDecoration(labelText: '选择大类 *'),
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
                  onChanged: (value) =>
                      setDialogState(() => categoryId = value ?? categoryId),
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
                  if (item == null) {
                    await widget.database.createIngredient(
                      name: name,
                      alias: alias,
                      categoryId: categoryId,
                    );
                  } else {
                    await widget.database.updateIngredient(
                      item.ingredient.id,
                      name: name,
                      alias: alias,
                      categoryId: categoryId,
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

  Future<IngredientCategory?> _quickCreateCategory() async {
    var name = '';
    return showDialog<IngredientCategory>(
      context: context,
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
            child: const Text('创建并选择'),
          ),
        ],
      ),
    );
  }

  Future<void> _ingredientAction(IngredientSummary item, String action) async {
    try {
      if (action == 'edit') return _editIngredient(item);
      if (action == 'inactive') {
        await widget.database.updateIngredient(
          item.ingredient.id,
          name: item.ingredient.name,
          alias: item.ingredient.alias,
          categoryId: item.ingredient.categoryId,
          isInactive: !item.ingredient.isInactive,
        );
      } else if (await _confirmDelete('删除“${item.ingredient.name}”？')) {
        await widget.database.deleteIngredient(item.ingredient.id);
      }
    } catch (error) {
      if (mounted) _message(_errorText(error));
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<bool> _confirmDelete(String title) async =>
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
}

class IngredientCategoriesPage extends StatelessWidget {
  const IngredientCategoriesPage({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('香料分类')),
      body: StreamBuilder<List<IngredientCategory>>(
        stream: database.watchIngredientCategories(),
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
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: item.isInactive ? const Text('已停用') : null,
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
                    const PopupMenuItem(value: 'ratio', child: Text('推荐区间')),
                    PopupMenuItem(
                      value: 'inactive',
                      child: Text(item.isInactive ? '启用' : '停用'),
                    ),
                    const PopupMenuItem(value: 'delete', child: Text('删除')),
                  ],
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

  Future<void> _edit(
    BuildContext context, [
    IngredientCategory? category,
  ]) async {
    var name = category?.name ?? '';
    final saved = await showDialog<bool>(
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
        await database.createIngredientCategory(name);
      } else {
        await database.updateIngredientCategory(category.id, name: name);
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
            database: database,
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
        await database.moveIngredientCategory(
          category.id,
          action == 'up' ? -1 : 1,
        );
      } else if (action == 'inactive') {
        await database.updateIngredientCategory(
          category.id,
          isInactive: !category.isInactive,
        );
      } else {
        final confirmed = await showModalBottomSheet<bool>(
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
          await database.deleteIngredientCategory(category.id);
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
