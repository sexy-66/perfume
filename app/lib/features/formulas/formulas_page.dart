import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import '../../services/formula_calculator.dart';
import '../settings/sync_conflicts_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.database, required this.mediaStore});

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 104),
      children: [
        Text(
          '今天想做什么？',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '从香方或成品开始',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xff636366)),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<SyncConflict>>(
          stream: database.watchPendingSyncConflicts(),
          builder: (context, snapshot) {
            final count = snapshot.data?.length ?? 0;
            if (count == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: const Color(0xfffff3cd),
                borderRadius: BorderRadius.circular(13),
                child: ListTile(
                  leading: const Icon(
                    Icons.sync_problem_outlined,
                    color: Color(0xff8a5a00),
                  ),
                  title: const Text('有待处理冲突'),
                  subtitle: Text('$count 项资料需要选择保留版本'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => SyncConflictsPage(database: database),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _HomeEntryCard(
                image: 'assets/home-entry-xiangfang.png',
                title: '香方',
                subtitle: '配制、计算与记录',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => FormulasPage(database: database),
                  ),
                ),
              ),
              _HomeEntryCard(
                image: 'assets/home-entry-hexiangzhu.png',
                title: '香牌 / 合香珠',
                subtitle: '成品目录与制作记录',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => PlaqueProductionStartPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
                  ),
                ),
              ),
            ];
            return constraints.maxWidth < 600
                ? Column(
                    children: [
                      cards.first,
                      const SizedBox(height: 10),
                      cards.last,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: cards.first),
                      const SizedBox(width: 12),
                      Expanded(child: cards.last),
                    ],
                  );
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '香方',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => FormulasPage(database: database),
                ),
              ),
              child: const Text('查看全部'),
            ),
          ],
        ),
        StreamBuilder<List<FormulaSummary>>(
          stream: database.watchFormulas(),
          builder: (context, snapshot) {
            final items = (snapshot.data ?? const []).take(4).toList();
            if (items.isEmpty) {
              return _HomeEmptyCard(
                text: '还没有香方',
                action: '新建香方',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => FormulaComposerPage(database: database),
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .88,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _FormulaCoverCard(
                      item: item,
                      onTap: () => _openFormula(context, database, item),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    ),
  );
}

class _HomeEntryCard extends StatelessWidget {
  const _HomeEntryCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 142,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: AssetImage(image),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xe6ffffff),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _HomeEmptyCard extends StatelessWidget {
  const _HomeEmptyCard({
    required this.text,
    required this.action,
    required this.onTap,
  });

  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 15, 8, 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        Expanded(child: Text(text)),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    ),
  );
}

class PlaqueProductionStartPage extends StatelessWidget {
  const PlaqueProductionStartPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('选择成品')),
    body: StreamBuilder<List<PlaqueType>>(
      stream: database.watchPlaqueTypes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('读取失败：${snapshot.error}'));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(
            child: Text(
              '还没有香牌 / 合香珠，请先在更多中建立',
              style: TextStyle(color: Color(0xff636366)),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text('香牌 / 合香珠', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              '作为同一种成品统一选择',
              style: TextStyle(color: Color(0xff636366)),
            ),
            const SizedBox(height: 16),
            for (final plaque in items) ...[
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => FormulaSelectionPage(
                        database: database,
                        plaque: plaque,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ColoredBox(
                          color: const Color(0xffe6e9e7),
                          child: plaque.imageHash == null
                              ? const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 44,
                                        color: Color(0xff415047),
                                      ),
                                      SizedBox(height: 8),
                                      Text('尚未添加成品图片'),
                                    ],
                                  ),
                                )
                              : Image.file(
                                  mediaStore.fileFor(plaque.imageHash!),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.broken_image_outlined),
                                ),
                        ),
                      ),
                      ListTile(
                        title: Text(plaque.name),
                        subtitle: plaque.specification == null
                            ? null
                            : Text(plaque.specification!),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Color(0xffc7c7cc),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ],
        );
      },
    ),
  );
}

class FormulaSelectionPage extends StatelessWidget {
  const FormulaSelectionPage({
    super.key,
    required this.database,
    required this.plaque,
  });

  final AppDatabase database;
  final PlaqueType plaque;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('为「${plaque.name}」选择香方'),
      actions: [
        TextButton.icon(
          onPressed: () => _createFormula(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新建香方'),
        ),
      ],
    ),
    body: StreamBuilder<List<FormulaSummary>>(
      stream: database.watchFormulas(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('读取失败：${snapshot.error}'));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '还没有可用香方',
                  style: TextStyle(color: Color(0xff636366)),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _createFormula(context),
                  icon: const Icon(Icons.add),
                  label: const Text('新建香方'),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final summary = items[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(summary.formula.name),
                subtitle: Text(
                  [
                    summary.productionTypeName,
                    summary.topIngredients,
                  ].where((value) => value.isNotEmpty).join(' · '),
                ),
                trailing: const Text(
                  '选择',
                  style: TextStyle(color: Color(0xff007aff)),
                ),
                onTap: () => _startMixing(context, summary),
              ),
            );
          },
        );
      },
    ),
  );

  void _createFormula(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => FormulaComposerPage(
          database: database,
          initialPlaqueTypeId: plaque.id,
        ),
      ),
    );
  }

  Future<void> _startMixing(
    BuildContext context,
    FormulaSummary summary,
  ) async {
    final versionId = summary.formula.currentVersionId;
    if (versionId == null) return;
    final input = await _askMixingOptions(context, database);
    if (input == null) return;
    try {
      final draft = await database.createDraftFromVersion(
        versionId: versionId,
        targetWeight: input.$1,
        customerId: input.$2,
        plaqueTypeId: plaque.id,
      );
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => MixingPage(database: database, draftId: draft.id),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }
}

class _FormulaCoverCard extends StatelessWidget {
  const _FormulaCoverCard({required this.item, required this.onTap});

  final FormulaSummary item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final letter = item.formula.name.isEmpty ? '香' : item.formula.name[0];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Ink(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xff354139), Color(0xff566158)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'serif',
                    fontSize: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              item.formula.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              item.productionTypeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Color(0xff636366)),
            ),
          ],
        ),
      ),
    );
  }
}

class FormulasPage extends StatefulWidget {
  const FormulasPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<FormulasPage> createState() => _FormulasPageState();
}

class _FormulasPageState extends State<FormulasPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('香方'),
      actions: [
        TextButton.icon(
          onPressed: () => _newFormula(context),
          icon: const Icon(Icons.add, size: 17),
          label: const Text('新建'),
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: SearchBar(
            controller: _search,
            hintText: '搜索香方名称',
            leading: const Icon(Icons.search),
            trailing: _search.text.isEmpty
                ? null
                : [
                    IconButton(
                      tooltip: '清空',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(_search.clear),
                    ),
                  ],
            onChanged: (_) => setState(() {}),
          ),
        ),
        StreamBuilder<List<FormulaDraft>>(
          stream: widget.database.watchOpenDrafts(),
          builder: (context, snapshot) {
            final drafts = snapshot.data ?? const [];
            if (drafts.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Material(
                color: const Color(0xfffff4df),
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (final draft in drafts)
                      ListTile(
                        leading: const Icon(Icons.edit_note),
                        title: Text(
                          draft.formulaName.isEmpty
                              ? '未命名草稿'
                              : draft.formulaName,
                        ),
                        subtitle: const Text('调配未完成 · 点击继续'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => draft.kind.startsWith('composing-')
                                ? FormulaComposerPage(
                                    database: widget.database,
                                    draftId: draft.id,
                                  )
                                : MixingPage(
                                    database: widget.database,
                                    draftId: draft.id,
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: StreamBuilder<List<FormulaSummary>>(
            stream: widget.database.watchFormulas(search: _search.text),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('读取失败：${snapshot.error}'));
              }
              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('没有找到香方'),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _search.text.isEmpty
                            ? () => _newFormula(context)
                            : () => setState(_search.clear),
                        child: Text(_search.text.isEmpty ? '新建香方' : '清除搜索'),
                      ),
                    ],
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
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: .86,
                    ),
                    itemBuilder: (context, index) => _FormulaCoverCard(
                      item: items[index],
                      onTap: () =>
                          _openFormula(context, widget.database, items[index]),
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

  void _newFormula(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => FormulaComposerPage(database: widget.database),
    ),
  );
}

class FormulaComposerPage extends StatefulWidget {
  const FormulaComposerPage({
    super.key,
    required this.database,
    this.formula,
    this.sourceVersion,
    this.initialItems = const [],
    this.draftId,
    this.initialPlaqueTypeId,
  });

  final AppDatabase database;
  final Formula? formula;
  final FormulaVersion? sourceVersion;
  final List<FormulaDraftItemInput> initialItems;
  final String? draftId;
  final String? initialPlaqueTypeId;

  @override
  State<FormulaComposerPage> createState() => _FormulaComposerPageState();
}

class _FormulaComposerPageState extends State<FormulaComposerPage> {
  final _name = TextEditingController();
  final _weight = TextEditingController();
  final _notes = TextEditingController();
  var _items = <FormulaDraftItemInput>[];
  List<ProductionType> _types = const [];
  List<FormulaSkuChoice> _skus = const [];
  List<Customer> _customers = const [];
  List<RecommendationPresetSummary> _presets = const [];
  String? _typeId;
  String? _customerId;
  String? _presetId;
  String? _plaqueTypeId;
  var _loading = true;
  String? _draftId;
  Timer? _saveTimer;
  Future<FormulaDraft>? _saving;
  var _dirty = false;
  var _leaving = false;
  late String _saveStatus;

  @override
  void initState() {
    super.initState();
    _name.text = widget.formula?.name ?? '';
    _items = [...widget.initialItems];
    _draftId = widget.draftId;
    _plaqueTypeId = widget.initialPlaqueTypeId;
    _saveStatus = widget.draftId == null ? '尚未保存' : '已保存';
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _weight.dispose();
    _notes.dispose();
    _saveTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final values = await Future.wait<Object>([
      widget.database.getActiveProductionTypes(
        includeId: widget.sourceVersion?.productionTypeId,
      ),
      widget.database.getActiveFormulaSkus(),
      widget.database.watchCustomers().first,
      widget.database.watchRecommendationPresets().first,
    ]);
    final saved = widget.draftId == null
        ? null
        : await widget.database.getComposerDraft(widget.draftId!);
    if (!mounted) return;
    setState(() {
      _types = values[0] as List<ProductionType>;
      _skus = values[1] as List<FormulaSkuChoice>;
      _customers = values[2] as List<Customer>;
      _presets = values[3] as List<RecommendationPresetSummary>;
      _typeId =
          saved?.draft.productionTypeId ??
          widget.sourceVersion?.productionTypeId ??
          (_types.isEmpty ? null : _types.first.id);
      if (saved != null) {
        _name.text = saved.draft.formulaName;
        _weight.text = saved.targetWeightText;
        _notes.text = saved.draft.notes ?? '';
        _customerId = saved.draft.customerId;
        _plaqueTypeId = saved.draft.plaqueTypeId;
        _items = saved.items;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _leaving,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop || _leaving) return;
      _saveTimer?.cancel();
      if (_dirty) await _saveDraft();
      if (!context.mounted) return;
      setState(() => _leaving = true);
      Navigator.pop(context);
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.draftId != null
              ? '继续编辑香方'
              : widget.formula == null
              ? '新建香方'
              : '基于此香方调整',
        ),
        actions: [
          TextButton(
            onPressed: _loading ? null : _discardDraft,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xffff3b30),
            ),
            child: const Text('放弃'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                Text(
                  '基本信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _typeId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: '制作类型'),
                  items: [
                    for (final type in _types)
                      DropdownMenuItem(value: type.id, child: Text(type.name)),
                  ],
                  onChanged: widget.sourceVersion == null
                      ? (value) {
                          setState(() => _typeId = value);
                          _scheduleSave();
                        }
                      : null,
                ),
                if (widget.formula == null && _presets.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: _presetId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '推荐配置（可选）'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('空白新建')),
                      for (final preset in _presets)
                        DropdownMenuItem(
                          value: preset.preset.id,
                          child: Text(preset.preset.name),
                        ),
                    ],
                    onChanged: _applyPreset,
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: '香方名称',
                    helperText: '关联顾客后可留空自动生成',
                  ),
                  onChanged: (_) => _scheduleSave(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _customerId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: '顾客（可选）'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('不关联顾客')),
                    for (final customer in _customers)
                      DropdownMenuItem(
                        value: customer.id,
                        child: Text(
                          customer.name.isEmpty
                              ? customer.phone
                              : customer.name,
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() => _customerId = value);
                    _scheduleSave();
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _createCustomer,
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('直接建立顾客'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weight,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: '目标总克重',
                    suffixText: 'g',
                  ),
                  onChanged: (_) => _scheduleSave(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '香材与计划比例',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '${formatFixed(_items.fold<int>(0, (sum, item) => sum + item.ratio))}%',
                    ),
                    IconButton(
                      tooltip: '添加 SKU',
                      onPressed: _addItem,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                if (_items.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Center(
                      child: Text(
                        '请选择具体 SKU',
                        style: TextStyle(color: Color(0xff636366)),
                      ),
                    ),
                  )
                else
                  Material(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    child: Column(
                      children: [
                        for (var i = 0; i < _items.length; i++)
                          ListTile(
                            title: Text(_items[i].label),
                            subtitle: Text(_items[i].categoryName),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${formatFixed(_items[i].ratio)}%'),
                                IconButton(
                                  tooltip: '删除 ${_items[i].label}',
                                  onPressed: () {
                                    setState(() {
                                      _items.removeAt(i);
                                      _reorderItems();
                                    });
                                    _scheduleSave();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
                TextField(
                  controller: _notes,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: '调配备注（可选）',
                    alignLabelWithHint: true,
                  ),
                  onChanged: (_) => _scheduleSave(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      _saveStatus == '已保存'
                          ? Icons.check_circle_outline
                          : Icons.schedule,
                      size: 16,
                      color: _saveStatus == '已保存'
                          ? const Color(0xff34c759)
                          : const Color(0xff636366),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _saveStatus,
                      style: const TextStyle(
                        color: Color(0xff636366),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _startMixing,
            child: const Text('进入调配'),
          ),
        ),
      ),
    ),
  );

  Future<void> _applyPreset(String? id) async {
    setState(() => _presetId = id);
    if (id == null) return;
    try {
      final preset = _presets
          .singleWhere((item) => item.preset.id == id)
          .preset;
      final items = await widget.database.getPresetDraftItems(id);
      setState(() {
        _typeId = preset.productionTypeId;
        _items = items;
      });
      _scheduleSave();
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _addItem() async {
    final choices = _skus
        .where((choice) => !_items.any((item) => item.skuId == choice.id))
        .toList();
    if (choices.isEmpty) return _message(context, '没有可添加的 SKU');
    var skuId = choices.first.id;
    var ratio = '';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('添加 SKU'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: skuId,
                isExpanded: true,
                items: [
                  for (final choice in choices)
                    DropdownMenuItem(
                      value: choice.id,
                      child: Text(choice.label),
                    ),
                ],
                onChanged: (value) => setState(() => skuId = value!),
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '计划比例',
                  suffixText: '%',
                ),
                onChanged: (value) => ratio = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                try {
                  final choice = choices.singleWhere(
                    (item) => item.id == skuId,
                  );
                  final value = parseRatio(ratio);
                  _items.add(
                    FormulaDraftItemInput(
                      skuId: choice.id,
                      categoryName: choice.categoryName,
                      ingredientName: choice.ingredientName,
                      skuCode: choice.skuCode,
                      ratio: value,
                      sortOrder: _items.length,
                    ),
                  );
                  Navigator.pop(context, true);
                } catch (error) {
                  _message(context, _errorText(error));
                }
              },
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      setState(() {});
      _scheduleSave();
    }
  }

  Future<void> _createCustomer() async {
    var name = '';
    var phone = '';
    final customer = await showDialog<Customer>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('建立顾客'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '姓名'),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: '电话'),
                onChanged: (value) => phone = value,
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
                final customer = await widget.database.createCustomer(
                  name: name,
                  phone: phone,
                );
                if (context.mounted) Navigator.pop(context, customer);
              } catch (error) {
                if (context.mounted) _message(context, _errorText(error));
              }
            },
            child: const Text('建立并选择'),
          ),
        ],
      ),
    );
    if (customer != null) {
      setState(() {
        _customers = [..._customers, customer];
        _customerId = customer.id;
      });
      _scheduleSave();
    }
  }

  Future<void> _startMixing() async {
    try {
      _saveTimer?.cancel();
      await _saveDraft();
      final draft = await widget.database.startComposerDraft(_draftId!);
      if (!mounted) return;
      setState(() => _leaving = true);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) =>
              MixingPage(database: widget.database, draftId: draft.id),
        ),
      );
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _discardDraft() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('放弃这份草稿？', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffff3b30),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('放弃草稿'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('继续编辑'),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) return;
    _saveTimer?.cancel();
    _dirty = false;
    try {
      await _saving;
      if (_draftId != null) {
        await widget.database.deleteFormulaDraft(_draftId!);
      }
      if (!mounted) return;
      setState(() => _leaving = true);
      Navigator.pop(context);
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    }
  }

  void _scheduleSave() {
    if (_loading) return;
    _dirty = true;
    setState(() => _saveStatus = '尚未保存');
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), _saveDraft);
  }

  Future<void> _saveDraft() async {
    if (_typeId == null) return;
    if (_saving != null) {
      await _saving;
      if (_dirty) await _saveDraft();
      return;
    }
    _dirty = false;
    if (mounted) setState(() => _saveStatus = '保存中…');
    final saving = widget.database.saveComposerDraft(
      draftId: _draftId,
      productionTypeId: _typeId!,
      targetWeightText: _weight.text,
      items: _items,
      formulaName: _name.text,
      notes: _notes.text,
      customerId: _customerId,
      plaqueTypeId: _plaqueTypeId,
      formulaId: widget.formula?.id,
      sourceVersionId: widget.sourceVersion?.id,
    );
    _saving = saving;
    try {
      _draftId = (await saving).id;
      if (mounted && !_dirty) setState(() => _saveStatus = '已保存');
    } finally {
      _saving = null;
    }
  }

  void _reorderItems() {
    _items = [
      for (var i = 0; i < _items.length; i++)
        FormulaDraftItemInput(
          skuId: _items[i].skuId,
          categoryName: _items[i].categoryName,
          ingredientName: _items[i].ingredientName,
          skuCode: _items[i].skuCode,
          ratio: _items[i].ratio,
          sortOrder: i,
        ),
    ];
  }
}

class MixingPage extends StatefulWidget {
  const MixingPage({super.key, required this.database, required this.draftId});

  final AppDatabase database;
  final String draftId;

  @override
  State<MixingPage> createState() => _MixingPageState();
}

class _MixingPageState extends State<MixingPage> {
  late Future<MixingDraftState> _state = widget.database.getMixingDraft(
    widget.draftId,
  );
  final _pendingWeights = <int, String>{};
  final _saveTimers = <int, Timer>{};
  var _warningOpen = false;

  @override
  void dispose() {
    for (final timer in _saveTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _reload() => setState(() {
    _state = widget.database.getMixingDraft(widget.draftId);
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('调配'),
      actions: [
        IconButton(
          tooltip: '删除草稿',
          onPressed: _deleteDraft,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    ),
    body: FutureBuilder<MixingDraftState>(
      future: _state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('读取失败：${snapshot.error}'));
        }
        final state = snapshot.data;
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final total = state.projectedWeights.fold<int>(
          0,
          (sum, value) => sum + value,
        );
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xff354139), Color(0xff566158)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    state.draft.formulaName.isEmpty
                        ? '香'
                        : state.draft.formulaName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'serif',
                      fontSize: 27,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.draft.formulaName.isEmpty
                            ? '新香方'
                            : state.draft.formulaName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '目标 ${formatFixed(state.draft.targetWeight)}g · 当前预计 ${formatFixed(total)}g',
                        style: const TextStyle(
                          color: Color(0xff636366),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '称量香材',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '共 ${state.items.length} 味',
                  style: const TextStyle(
                    color: Color(0xff636366),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Material(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(13),
              child: Column(
                children: [
                  for (var i = 0; i < state.items.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: i == state.items.length - 1
                            ? null
                            : const Border(
                                bottom: BorderSide(color: Color(0xffd1d1d6)),
                              ),
                      ),
                      child: TextFormField(
                        key: ValueKey('${state.draft.revisionId}-$i'),
                        initialValue: state.actualWeights[i] == null
                            ? ''
                            : formatFixed(state.actualWeights[i]!),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: state.items[i].label,
                          helperText:
                              '计划 ${formatFixed(state.plannedWeights[i])}g · 预计 ${formatFixed(state.projectedRatios[i])}%',
                          suffixText: 'g',
                        ),
                        onChanged: (text) => _queueWeight(i, text),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              '未填写项在完成时采用计划克重，并标记为系统补全。',
              style: TextStyle(color: Color(0xff636366), fontSize: 11),
            ),
          ],
        );
      },
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton(onPressed: _complete, child: const Text('完成调配')),
      ),
    ),
  );

  Future<void> _saveWeight(int index, String text) async {
    try {
      await widget.database.setDraftActualWeight(
        widget.draftId,
        index,
        text.trim().isEmpty ? null : parseWeight(text),
      );
      if (!mounted) return;
      _reload();
      await _handleWarnings();
    } catch (error, stackTrace) {
      debugPrint('Failed to save mixing weight: $error\n$stackTrace');
      if (mounted) _message(context, _errorText(error));
    }
  }

  void _queueWeight(int index, String text) {
    _pendingWeights[index] = text;
    _saveTimers[index]?.cancel();
    _saveTimers[index] = Timer(const Duration(milliseconds: 400), () async {
      final value = _pendingWeights.remove(index);
      _saveTimers.remove(index);
      if (value != null) await _saveWeight(index, value);
    });
  }

  Future<void> _flushWeights() async {
    for (final timer in _saveTimers.values) {
      timer.cancel();
    }
    _saveTimers.clear();
    final pending = Map<int, String>.from(_pendingWeights);
    _pendingWeights.clear();
    for (final entry in pending.entries) {
      await widget.database.setDraftActualWeight(
        widget.draftId,
        entry.key,
        entry.value.trim().isEmpty ? null : parseWeight(entry.value),
      );
    }
  }

  Future<void> _complete() async {
    try {
      await _flushWeights();
      if (!await _handleWarnings()) return;
      final session = await widget.database.completeDraft(widget.draftId);
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) =>
              MixingSessionPage(database: widget.database, session: session),
        ),
      );
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    }
  }

  Future<bool> _handleWarnings() async {
    if (_warningOpen) return true;
    final warnings = await widget.database.getDraftRangeWarnings(
      widget.draftId,
    );
    if (!mounted || warnings.isEmpty) return true;
    _warningOpen = true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('比例超出推荐区间'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final warning in warnings)
                Text(
                  '${warning.label}：${formatFixed(warning.actual)}%（推荐 ${formatFixed(warning.minimum)}%–${formatFixed(warning.maximum)}%）',
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('返回修改'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('继续使用'),
          ),
        ],
      ),
    );
    _warningOpen = false;
    if (confirmed != true) return false;
    await widget.database.confirmDraftWarnings(
      widget.draftId,
      warnings.map((item) => item.key),
    );
    return true;
  }

  Future<void> _deleteDraft() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('删除未完成调配？', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
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
    if (confirmed != true) return;
    await widget.database.deleteFormulaDraft(widget.draftId);
    if (mounted) Navigator.pop(context);
  }
}

class FormulaDetailPage extends StatelessWidget {
  const FormulaDetailPage({
    super.key,
    required this.database,
    required this.summary,
  });

  final AppDatabase database;
  final FormulaSummary summary;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(summary.formula.name),
      actions: [
        PopupMenuButton<String>(
          tooltip: '更多操作',
          icon: const Icon(Icons.more_horiz),
          onSelected: (value) =>
              value == 'edit' ? _edit(context) : _delete(context),
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 12),
                  Text('修改名称和备注'),
                ],
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Color(0xffff3b30)),
                  SizedBox(width: 12),
                  Text('删除香方', style: TextStyle(color: Color(0xffff3b30))),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    body: StreamBuilder<List<MixingSession>>(
      stream: database.watchFormulaSessions(summary.formula.id),
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? const [];
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            Container(
              height: 170,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xff354139), Color(0xff566158)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                summary.formula.name.isEmpty ? '香' : summary.formula.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'serif',
                  fontSize: 52,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              summary.formula.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              [
                summary.productionTypeName,
                summary.topIngredients,
              ].where((text) => text.isNotEmpty).join(' · '),
              style: const TextStyle(color: Color(0xff636366), fontSize: 11),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _repeat(context),
              child: const Text('再次调配'),
            ),
            OutlinedButton(
              onPressed: () => _adjust(context),
              child: const Text('基于此香方调整'),
            ),
            Align(
              child: TextButton(
                onPressed: () => _history(context),
                child: const Text('查看版本历史'),
              ),
            ),
            const SizedBox(height: 12),
            Text('调配记录', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Material(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(13),
              child: sessions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '暂无调配记录',
                        style: TextStyle(
                          color: Color(0xff636366),
                          fontSize: 11,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (final session in sessions)
                          ListTile(
                            title: Text('${formatFixed(session.finalWeight)}g'),
                            subtitle: Text(_dateText(session.completedAtUtc)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => MixingSessionPage(
                                  database: database,
                                  session: session,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    ),
  );

  Future<void> _repeat(BuildContext context) async {
    final input = await _askMixingOptions(context, database);
    if (input == null || summary.formula.currentVersionId == null) return;
    try {
      final draft = await database.createDraftFromVersion(
        versionId: summary.formula.currentVersionId!,
        targetWeight: input.$1,
        customerId: input.$2,
      );
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => MixingPage(database: database, draftId: draft.id),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _adjust(BuildContext context) async {
    final versionId = summary.formula.currentVersionId;
    if (versionId == null) return;
    final version = await (database.select(
      database.formulaVersions,
    )..where((row) => row.id.equals(versionId))).getSingle();
    final items = await database.getVersionDraftItems(versionId);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => FormulaComposerPage(
            database: database,
            formula: summary.formula,
            sourceVersion: version,
            initialItems: items,
          ),
        ),
      );
    }
  }

  void _history(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => FormulaVersionHistoryPage(
        database: database,
        formula: summary.formula,
      ),
    ),
  );

  Future<void> _edit(BuildContext context) async {
    var name = summary.formula.name;
    var notes = summary.formula.notes ?? '';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改香方'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: notes,
                maxLines: 2,
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
                await database.updateFormula(
                  summary.formula.id,
                  name: name,
                  notes: notes,
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
    );
    if (saved == true && context.mounted) Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await database.deleteFormula(summary.formula.id);
    if (!context.mounted) return;
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: const Text('已移入最近删除'),
        action: SnackBarAction(
          label: '撤销',
          onPressed: () async {
            try {
              await database.restoreTrashEntry(
                TrashEntry(
                  type: TrashEntityType.formula,
                  id: summary.formula.id,
                  name: summary.formula.name,
                  deletedAtUtc: DateTime.now().toUtc(),
                ),
              );
            } catch (error) {
              messenger.showSnackBar(
                SnackBar(content: Text(_errorText(error))),
              );
            }
          },
        ),
      ),
    );
  }
}

class FormulaVersionHistoryPage extends StatelessWidget {
  const FormulaVersionHistoryPage({
    super.key,
    required this.database,
    required this.formula,
  });

  final AppDatabase database;
  final Formula formula;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('版本历史')),
    body: StreamBuilder<List<FormulaVersionSummary>>(
      stream: database.watchFormulaVersions(formula.id),
      builder: (context, snapshot) => ListView(
        children: [
          for (final value in snapshot.data ?? const <FormulaVersionSummary>[])
            ExpansionTile(
              title: Text('V${value.version.versionNumber}'),
              subtitle: Text(_dateText(value.version.createdAtUtc)),
              children: [
                for (final item in value.items)
                  ListTile(
                    title: Text(item.ingredientName),
                    trailing: Text('${formatFixed(item.ratio)}%'),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _useVersion(context, value.version),
                    child: const Text('使用此版本调配'),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );

  Future<void> _useVersion(BuildContext context, FormulaVersion version) async {
    final input = await _askMixingOptions(context, database);
    if (input == null) return;
    final draft = await database.createDraftFromVersion(
      versionId: version.id,
      targetWeight: input.$1,
      customerId: input.$2,
    );
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => MixingPage(database: database, draftId: draft.id),
        ),
      );
    }
  }
}

class MixingSessionPage extends StatelessWidget {
  const MixingSessionPage({
    super.key,
    required this.database,
    required this.session,
  });

  final AppDatabase database;
  final MixingSession session;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(session.formulaName),
      actions: [
        IconButton(
          tooltip: '修改调配记录',
          onPressed: () => _edit(context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: '复制给另一顾客',
          onPressed: () => _copyToCustomer(context),
          icon: const Icon(Icons.person_add_outlined),
        ),
      ],
    ),
    body: StreamBuilder<List<MixingItem>>(
      stream: database.watchMixingItems(session.id),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        final total = items.fold<int>(0, (sum, item) => sum + item.finalWeight);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('最终总重 ${formatFixed(total)}g'),
              subtitle: Text(
                '${session.productionTypeName} · 目标 ${formatFixed(session.targetWeight)}g',
              ),
            ),
            for (final item in items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item.skuCode == null
                      ? item.ingredientName
                      : '${item.ingredientName} · ${item.skuCode}',
                ),
                subtitle: Text(item.isManual ? '手工填写' : '系统补全'),
                trailing: Text(
                  '${formatFixed(item.finalWeight)}g\n${formatFixed(item.finalRatio)}%',
                  textAlign: TextAlign.end,
                ),
              ),
            FutureBuilder<List<MixingRevision>>(
              future: database.getMixingRevisions(session.id),
              builder: (context, revisions) =>
                  revisions.data?.isNotEmpty == true
                  ? ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history),
                      title: Text('已修改 ${revisions.data!.length} 次'),
                      subtitle: const Text('修改前数据已保留'),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    ),
  );

  Future<void> _edit(BuildContext context) async {
    final items = await database.watchMixingItems(session.id).first;
    final texts = [for (final item in items) formatFixed(item.finalWeight)];
    if (!context.mounted) return;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改最终克重'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                TextFormField(
                  initialValue: texts[i],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: items[i].ingredientName,
                    suffixText: 'g',
                  ),
                  onChanged: (value) => texts[i] = value,
                ),
              ],
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
                await database.reviseMixingSession(session.id, [
                  for (final text in texts) parseWeight(text),
                ]);
                if (context.mounted) Navigator.pop(context, true);
              } catch (error) {
                if (context.mounted) _message(context, _errorText(error));
              }
            },
            child: const Text('保存修改'),
          ),
        ],
      ),
    );
    if (saved == true && context.mounted) _message(context, '已保存修改');
  }

  Future<void> _copyToCustomer(BuildContext context) async {
    final customers = await database.watchCustomers().first;
    if (!context.mounted) return;
    if (customers.isEmpty) return _message(context, '请先建立顾客');
    var customerId = customers.first.id;
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('复制调配记录给顾客'),
          content: DropdownButtonFormField<String>(
            initialValue: customerId,
            isExpanded: true,
            items: [
              for (final customer in customers)
                DropdownMenuItem(
                  value: customer.id,
                  child: Text(
                    customer.name.isEmpty ? customer.phone : customer.name,
                  ),
                ),
            ],
            onChanged: (value) => setState(() => customerId = value!),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, customerId),
              child: const Text('复制'),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    await database.copyMixingSessionToCustomer(session.id, selected);
    if (context.mounted) _message(context, '已复制');
  }
}

Future<(int, String?)?> _askMixingOptions(
  BuildContext context,
  AppDatabase database,
) async {
  final customers = await database.watchCustomers().first;
  if (!context.mounted) return null;
  var weight = '';
  String? customerId;
  return showDialog<(int, String?)>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('再次调配'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '目标总克重',
                  suffixText: 'g',
                ),
                onChanged: (value) => weight = value,
              ),
              DropdownButtonFormField<String?>(
                initialValue: customerId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: '顾客（可选）'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('不关联顾客')),
                  for (final customer in customers)
                    DropdownMenuItem(
                      value: customer.id,
                      child: Text(
                        customer.name.isEmpty ? customer.phone : customer.name,
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => customerId = value),
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
            onPressed: () {
              try {
                Navigator.pop(context, (parseWeight(weight), customerId));
              } catch (error) {
                _message(context, _errorText(error));
              }
            },
            child: const Text('进入调配'),
          ),
        ],
      ),
    ),
  );
}

void _openFormula(
  BuildContext context,
  AppDatabase database,
  FormulaSummary summary,
) => Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (_) => FormulaDetailPage(database: database, summary: summary),
  ),
);

String _dateText(DateTime utc) {
  final value = utc.toLocal();
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

void _message(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
