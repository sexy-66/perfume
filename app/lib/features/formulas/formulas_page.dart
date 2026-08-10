import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import '../../services/formula_calculator.dart';
import '../../ui/image_picker_cropper.dart';
import '../../ui/single_modal.dart';
import '../settings/sync_conflicts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.database, required this.mediaStore});

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _pinchingHomeImage = false;

  AppDatabase get database => widget.database;
  MediaStore get mediaStore => widget.mediaStore;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      physics: _pinchingHomeImage ? const NeverScrollableScrollPhysics() : null,
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
                image: 'assets/home-entry-xiangfang.jpg',
                title: '香方',
                subtitle: '配制、计算与记录',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => FormulasPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
                  ),
                ),
              ),
              _HomeEntryCard(
                image: 'assets/home-entry-hexiangzhu.jpg',
                title: '合香珠 / 香牌',
                subtitle: '成品目录与制作记录',
                pinchZoom: true,
                onPinchActiveChanged: (active) {
                  if (_pinchingHomeImage == active) return;
                  setState(() => _pinchingHomeImage = active);
                },
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
              _HomeMixingEntryCard(
                database: database,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => MixingRecordsPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
                  ),
                ),
              ),
            ];
            return constraints.maxWidth < 720
                ? Column(
                    children: [
                      cards.first,
                      const SizedBox(height: 10),
                      cards[1],
                      const SizedBox(height: 10),
                      cards.last,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: cards.first),
                      const SizedBox(width: 12),
                      Expanded(child: cards[1]),
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
                  builder: (_) =>
                      FormulasPage(database: database, mediaStore: mediaStore),
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
                    builder: (_) => FormulaComposerPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
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
                    childAspectRatio: .72,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _FormulaCoverCard(
                      item: item,
                      mediaStore: mediaStore,
                      onTap: () =>
                          _openFormula(context, database, mediaStore, item),
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
    this.pinchZoom = false,
    this.onPinchActiveChanged,
  });

  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool pinchZoom;
  final ValueChanged<bool>? onPinchActiveChanged;

  @override
  Widget build(BuildContext context) {
    final label = Padding(
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
              style: const TextStyle(color: Color(0xe6ffffff), fontSize: 11),
            ),
          ],
        ),
      ),
    );
    return SizedBox(
      height: 142,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: pinchZoom
            ? _PinchZoomImage(
                image: Image.asset(image, fit: BoxFit.cover, cacheWidth: 1024),
                semanticsLabel: '$title首页图片，支持双指缩放',
                transformKey: const ValueKey('home-plaque-pinch-image'),
                onTap: onTap,
                onPinchActiveChanged: onPinchActiveChanged,
                child: label,
              )
            : Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: ResizeImage(AssetImage(image), width: 1024),
                  fit: BoxFit.cover,
                  child: InkWell(onTap: onTap, child: label),
                ),
              ),
      ),
    );
  }
}

class _PinchZoomImage extends StatefulWidget {
  const _PinchZoomImage({
    required this.image,
    required this.semanticsLabel,
    required this.onTap,
    required this.child,
    required this.transformKey,
    this.onPinchActiveChanged,
    this.overlayOnPinch = false,
  });

  final Widget image;
  final String semanticsLabel;
  final VoidCallback onTap;
  final Widget child;
  final Key transformKey;
  final ValueChanged<bool>? onPinchActiveChanged;
  final bool overlayOnPinch;

  @override
  State<_PinchZoomImage> createState() => _PinchZoomImageState();
}

class _PinchZoomImageState extends State<_PinchZoomImage> {
  static const _maxScale = 4.0;

  final Map<int, Offset> _pointers = {};
  double _scale = 1;
  Offset _translation = Offset.zero;
  double _gestureStartScale = 1;
  double _gestureStartDistance = 1;
  Offset _gestureStartTranslation = Offset.zero;
  Offset _gestureStartFocalPoint = Offset.zero;
  Offset _singlePointerStart = Offset.zero;
  bool _suppressTap = false;
  bool _pinchActive = false;
  Timer? _tapResetTimer;
  OverlayEntry? _overlayEntry;
  Offset _overlayOrigin = Offset.zero;
  Size _overlaySize = Size.zero;

  @override
  void dispose() {
    _tapResetTimer?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _pointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.localPosition;
    if (_pointers.length == 2) {
      _suppressTap = true;
      _setPinchActive(true);
      _startPinch();
      if (widget.overlayOnPinch) _showOverlay();
    }
  }

  void _pointerMove(PointerMoveEvent event, Size size) {
    if (!_pointers.containsKey(event.pointer)) return;
    _pointers[event.pointer] = event.localPosition;
    if (_pointers.length == 1 && _overlayEntry != null && _scale > 1) {
      final nextTranslation =
          _gestureStartTranslation + event.localPosition - _singlePointerStart;
      setState(() {
        _translation = _clampTranslation(nextTranslation, size, _scale);
      });
      _overlayEntry?.markNeedsBuild();
      return;
    }
    if (_pointers.length < 2) return;
    final points = _pointers.values.take(2).toList(growable: false);
    final focalPoint = (points[0] + points[1]) / 2;
    final distance = (points[0] - points[1]).distance;
    final nextScale = (_gestureStartScale * distance / _gestureStartDistance)
        .clamp(1.0, _maxScale)
        .toDouble();
    final scenePoint =
        (_gestureStartFocalPoint - _gestureStartTranslation) /
        _gestureStartScale;
    final nextTranslation = focalPoint - scenePoint * nextScale;
    setState(() {
      _scale = nextScale;
      _translation = _clampTranslation(nextTranslation, size, nextScale);
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _pointerEnd(PointerEvent event) {
    _pointers.remove(event.pointer);
    if (_pointers.isEmpty) {
      _setPinchActive(false);
      if (widget.overlayOnPinch) {
        _hideOverlay();
        setState(() {
          _scale = 1;
          _translation = Offset.zero;
        });
      }
    }
    if (_pointers.length == 1) {
      _gestureStartScale = _scale;
      _gestureStartTranslation = _translation;
      _singlePointerStart = _pointers.values.single;
    }
    _tapResetTimer?.cancel();
    _tapResetTimer = Timer(const Duration(milliseconds: 180), () {
      _suppressTap = false;
    });
  }

  void _startPinch() {
    final points = _pointers.values.take(2).toList(growable: false);
    _gestureStartScale = _scale;
    _gestureStartDistance = (points[0] - points[1]).distance
        .clamp(1.0, double.infinity)
        .toDouble();
    _gestureStartTranslation = _translation;
    _gestureStartFocalPoint = (points[0] + points[1]) / 2;
  }

  void _setPinchActive(bool active) {
    if (_pinchActive == active) return;
    _pinchActive = active;
    widget.onPinchActiveChanged?.call(active);
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final box = context.findRenderObject()! as RenderBox;
    _overlayOrigin = box.localToGlobal(Offset.zero);
    _overlaySize = box.size;
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: Stack(
          key: const ValueKey('plaque-pinch-overlay'),
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xcc000000)),
            Positioned(
              left: _overlayOrigin.dx,
              top: _overlayOrigin.dy,
              width: _overlaySize.width,
              height: _overlaySize.height,
              child: Transform(
                key: const ValueKey('plaque-pinch-overlay-transform'),
                alignment: Alignment.topLeft,
                transform: Matrix4.identity()
                  ..translateByDouble(_translation.dx, _translation.dy, 0, 1)
                  ..scaleByDouble(_scale, _scale, 1, 1),
                child: widget.image,
              ),
            ),
          ],
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Offset _clampTranslation(Offset value, Size size, double scale) => Offset(
    value.dx.clamp(size.width * (1 - scale), 0.0).toDouble(),
    value.dy.clamp(size.height * (1 - scale), 0.0).toDouble(),
  );

  void _tap() {
    if (_suppressTap) return;
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.biggest;
      return Semantics(
        button: true,
        label: widget.semanticsLabel,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _pointerDown,
          onPointerMove: (event) => _pointerMove(event, size),
          onPointerUp: _pointerEnd,
          onPointerCancel: _pointerEnd,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform(
                  key: widget.transformKey,
                  alignment: Alignment.topLeft,
                  transform: Matrix4.identity()
                    ..translateByDouble(_translation.dx, _translation.dy, 0, 1)
                    ..scaleByDouble(_scale, _scale, 1, 1),
                  child: Opacity(
                    opacity: _overlayEntry == null ? 1 : 0,
                    child: widget.image,
                  ),
                ),
                InkWell(onTap: _tap, child: widget.child),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _HomeMixingEntryCard extends StatelessWidget {
  const _HomeMixingEntryCard({required this.database, required this.onTap});

  final AppDatabase database;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 142,
    child: StreamBuilder<List<MixingSessionSummary>>(
      stream: database.watchAllMixingSessions(),
      builder: (context, snapshot) {
        final records = snapshot.data ?? const <MixingSessionSummary>[];
        final latest = records.isEmpty ? null : records.first;
        return Material(
          color: const Color(0xff354139),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/home-entry-mixing-records.jpg',
                  fit: BoxFit.cover,
                  cacheWidth: 1024,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x08000000), Color(0x99000000)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '调配记录',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        latest == null
                            ? '查看全部客人调配记录'
                            : '${latest.session.formulaName} · ${_customerLabel(latest.customer)}',
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
              ],
            ),
          ),
        );
      },
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

class MixingRecordsPage extends StatefulWidget {
  const MixingRecordsPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<MixingRecordsPage> createState() => _MixingRecordsPageState();
}

class _MixingRecordsPageState extends State<MixingRecordsPage> {
  final _search = TextEditingController();
  final Set<String> _selected = {};
  late Stream<List<MixingSessionSummary>> _records;
  bool _deleting = false;

  bool get _selecting => _selected.isNotEmpty;

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

  void _refresh() {
    _records = widget.database.watchAllMixingSessions(search: _search.text);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_selecting,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop && _selecting && !_deleting) setState(_selected.clear);
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(_selecting ? '已选 ${_selected.length} 项' : '调配记录'),
        leading: _selecting
            ? IconButton(
                tooltip: '退出多选',
                onPressed: _deleting ? null : () => setState(_selected.clear),
                icon: const Icon(Icons.close),
              )
            : null,
        actions: _selecting
            ? [
                IconButton(
                  tooltip: '删除所选调配记录',
                  onPressed: _deleting ? null : _deleteSelected,
                  icon: const Icon(Icons.delete_outline),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: '搜索顾客姓名、电话或香方名称',
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(_refresh),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MixingSessionSummary>>(
              stream: _records,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('读取失败：${snapshot.error}'));
                }
                final records = snapshot.data ?? const [];
                if (records.isEmpty) {
                  return Center(
                    child: Text(
                      _search.text.trim().isEmpty
                          ? '还没有调配记录'
                          : '没有匹配记录，请检查姓名、电话或香方名称',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xff636366)),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: records.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = records[index];
                    final selected = _selected.contains(record.session.id);
                    return Material(
                      color: selected ? const Color(0xffeaf2ff) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: selected
                              ? const Color(0xff007aff)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onLongPress: () => _toggleSelection(record.session.id),
                        onTap: () => _selecting
                            ? _toggleSelection(record.session.id)
                            : Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => MixingSessionPage(
                                    database: widget.database,
                                    mediaStore: widget.mediaStore,
                                    session: record.session,
                                  ),
                                ),
                              ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: SizedBox.square(
                                  dimension: 68,
                                  child: record.formulaImageHash == null
                                      ? const ColoredBox(
                                          color: Color(0xffe6e9e7),
                                          child: Icon(Icons.menu_book_outlined),
                                        )
                                      : Image.file(
                                          widget.mediaStore.fileFor(
                                            record.formulaImageHash!,
                                          ),
                                          fit: BoxFit.cover,
                                          cacheWidth: 256,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.session.formulaName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _customerLabel(record.customer),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xff3a3a3c),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_dateText(record.session.completedAtUtc)} · ${formatFixed(record.session.finalWeight)}g',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xff636366),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons.chevron_right,
                                color: selected
                                    ? const Color(0xff007aff)
                                    : const Color(0xff8e8e93),
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
          ),
        ],
      ),
    ),
  );

  void _toggleSelection(String id) => setState(() {
    if (!_selected.add(id)) _selected.remove(id);
  });

  Future<void> _deleteSelected() async {
    final ids = {..._selected};
    final confirmed = await showSingleModalBottomSheet<bool>(
      context: context,
      builder: (context) => _DeleteSelectionSheet(
        title: '删除所选 ${ids.length} 条调配记录？',
        description: '删除后这些记录将不再显示。',
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      for (final id in ids) {
        await widget.database.deleteMixingSession(id);
      }
      if (!mounted) return;
      setState(_selected.clear);
      _message(context, '已删除 ${ids.length} 条调配记录');
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }
}

class _DeleteSelectionSheet extends StatelessWidget {
  const _DeleteSelectionSheet({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Color(0xff636366))),
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
  );
}

class PlaqueProductionStartPage extends StatefulWidget {
  const PlaqueProductionStartPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<PlaqueProductionStartPage> createState() =>
      _PlaqueProductionStartPageState();
}

class _PlaqueProductionStartPageState extends State<PlaqueProductionStartPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('选择成品')),
    body: StreamBuilder<List<PlaqueType>>(
      stream: widget.database.watchPlaqueTypes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('读取失败：${snapshot.error}'));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(
            child: Text(
              '还没有合香珠 / 香牌，请先在更多中建立',
              style: TextStyle(color: Color(0xff636366)),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text('合香珠 / 香牌', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            for (final plaque in items) ...[
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: _PinchZoomImage(
                        image: ColoredBox(
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
                                  widget.mediaStore.fileFor(plaque.imageHash!),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.broken_image_outlined),
                                ),
                        ),
                        semanticsLabel: '${plaque.name}成品图片，支持双指缩放',
                        transformKey: ValueKey(
                          'plaque-pinch-image-${plaque.id}',
                        ),
                        overlayOnPinch: plaque.imageHash != null,
                        onTap: () => _openPlaque(plaque),
                        child: const SizedBox.expand(),
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
                      onTap: () => _openPlaque(plaque),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ],
        );
      },
    ),
  );

  void _openPlaque(PlaqueType plaque) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => FormulaSelectionPage(
        database: widget.database,
        mediaStore: widget.mediaStore,
        plaque: plaque,
      ),
    ),
  );
}

class FormulaSelectionPage extends StatelessWidget {
  const FormulaSelectionPage({
    super.key,
    required this.database,
    required this.mediaStore,
    required this.plaque,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
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
      stream: database.watchFormulas(
        productionTypeId: combinedProductionTypeId,
      ),
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
              child: InkWell(
                onTap: () => _startMixing(context, summary),
                child: Row(
                  children: [
                    SizedBox(
                      key: ValueKey(
                        'formula-selection-image-${summary.formula.id}',
                      ),
                      width: 96,
                      height: 82,
                      child: _FormulaArtwork(
                        name: summary.formula.name,
                        imageHash: summary.formula.imageHash,
                        mediaStore: mediaStore,
                        borderRadius: 0,
                      ),
                    ),
                    Expanded(
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
  );

  void _createFormula(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => FormulaComposerPage(
          database: database,
          mediaStore: mediaStore,
          initialPlaqueTypeId: plaque.id,
          initialProductionTypeId: combinedProductionTypeId,
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
            builder: (_) => MixingPage(
              database: database,
              mediaStore: mediaStore,
              draftId: draft.id,
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }
}

class _FormulaCoverCard extends StatelessWidget {
  const _FormulaCoverCard({
    required this.item,
    required this.mediaStore,
    required this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  final FormulaSummary item;
  final MediaStore mediaStore;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('formula-card-${item.formula.id}'),
      color: selected ? const Color(0xffeaf2ff) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? const Color(0xff007aff) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _FormulaArtwork(
                      name: item.formula.name,
                      imageHash: item.formula.imageHash,
                      mediaStore: mediaStore,
                      cacheWidth: 720,
                    ),
                    if (selected)
                      const Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xff007aff),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Text(
                item.formula.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.productionTypeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xff636366)),
              ),
              if (item.customers.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  '顾客：${item.customers.map(_customerLabel).join('、')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff636366),
                  ),
                ),
              ],
              if (item.formula.notes != null) ...[
                const SizedBox(height: 3),
                Text(
                  item.formula.notes!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff636366),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FormulaArtwork extends StatelessWidget {
  const _FormulaArtwork({
    required this.name,
    required this.mediaStore,
    this.imageHash,
    this.borderRadius = 14,
    this.cacheWidth,
  });

  final String name;
  final String? imageHash;
  final MediaStore mediaStore;
  final double borderRadius;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: imageHash == null
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff354139), Color(0xff566158)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name.isEmpty ? '未命名香方' : name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'serif',
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          )
        : Image.file(
            mediaStore.fileFor(imageHash!),
            key: ValueKey('$imageHash-${mediaStore.revision}'),
            width: double.infinity,
            fit: BoxFit.cover,
            cacheWidth: cacheWidth,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: Color(0xffe6e9e7),
              child: Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
  );
}

class FormulasPage extends StatefulWidget {
  const FormulasPage({
    super.key,
    required this.database,
    required this.mediaStore,
    this.recommendedOnly = false,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final bool recommendedOnly;

  @override
  State<FormulasPage> createState() => _FormulasPageState();
}

class _FormulasPageState extends State<FormulasPage> {
  final _search = TextEditingController();
  final Set<String> _selectedDrafts = {};
  final Set<String> _selectedFormulas = {};
  bool _deletingDrafts = false;
  var _category = _FormulaCategory.all;

  bool get _selecting =>
      _selectedDrafts.isNotEmpty || _selectedFormulas.isNotEmpty;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_selecting,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop && _selecting && !_deletingDrafts) {
        setState(() {
          _selectedDrafts.clear();
          _selectedFormulas.clear();
        });
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          _selecting
              ? '已选 ${_selectedDrafts.length + _selectedFormulas.length} 项'
              : widget.recommendedOnly
              ? '推荐香方'
              : '香方',
        ),
        leading: _selecting
            ? IconButton(
                tooltip: '退出多选',
                onPressed: _deletingDrafts
                    ? null
                    : () => setState(() {
                        _selectedDrafts.clear();
                        _selectedFormulas.clear();
                      }),
                icon: const Icon(Icons.close),
              )
            : null,
        actions: _selecting
            ? [
                IconButton(
                  tooltip: '删除所选香方或草稿',
                  onPressed: _deletingDrafts ? null : _deleteSelected,
                  icon: const Icon(Icons.delete_outline),
                ),
              ]
            : [
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
              hintText: '搜索香方、顾客姓名或电话',
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
          if (!widget.recommendedOnly)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final category in _FormulaCategory.values) ...[
                    ChoiceChip(
                      key: ValueKey('formula-category-${category.name}'),
                      label: Text(category.label),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                    if (category != _FormulaCategory.values.last)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          StreamBuilder<List<FormulaDraft>>(
            stream: widget.database.watchOpenDrafts(
              recommendedOnly: widget.recommendedOnly,
            ),
            builder: (context, snapshot) {
              final drafts = snapshot.data ?? const [];
              if (drafts.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  children: [
                    for (var index = 0; index < drafts.length; index++) ...[
                      Builder(
                        builder: (context) {
                          final draft = drafts[index];
                          final selected = _selectedDrafts.contains(draft.id);
                          return Material(
                            color: selected
                                ? const Color(0xffeaf2ff)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: selected
                                    ? const Color(0xff007aff)
                                    : const Color(0xffe5e5ea),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: Icon(
                                selected ? Icons.check_circle : Icons.edit_note,
                                color: selected
                                    ? const Color(0xff007aff)
                                    : null,
                              ),
                              title: Text(
                                draft.formulaName.isEmpty
                                    ? '未命名草稿'
                                    : draft.formulaName,
                              ),
                              subtitle: const Text('调配未完成 · 点击继续'),
                              trailing: Icon(
                                selected ? Icons.check : Icons.chevron_right,
                              ),
                              onLongPress: () => _toggleDraft(draft.id),
                              onTap: () => _selecting
                                  ? _toggleDraft(draft.id)
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            draft.kind.startsWith('composing-')
                                            ? FormulaComposerPage(
                                                database: widget.database,
                                                mediaStore: widget.mediaStore,
                                                draftId: draft.id,
                                                recommended:
                                                    widget.recommendedOnly,
                                              )
                                            : MixingPage(
                                                database: widget.database,
                                                mediaStore: widget.mediaStore,
                                                draftId: draft.id,
                                              ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      if (index != drafts.length - 1) const SizedBox(height: 8),
                    ],
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<FormulaSummary>>(
              key: ValueKey(
                '${widget.recommendedOnly}-${_category.name}-${_search.text}',
              ),
              stream: widget.database.watchFormulas(
                search: _search.text,
                recommendedOnly:
                    widget.recommendedOnly ||
                    _category == _FormulaCategory.recommended,
                selfBuiltOnly: _category == _FormulaCategory.selfBuilt,
              ),
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
                        childAspectRatio: .68,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final selected = _selectedFormulas.contains(
                          item.formula.id,
                        );
                        return _FormulaCoverCard(
                          item: item,
                          mediaStore: widget.mediaStore,
                          selected: selected,
                          onLongPress:
                              item.formula.isRecommended &&
                                  !widget.recommendedOnly
                              ? null
                              : () => _toggleFormula(item.formula.id),
                          onTap: () {
                            if (_selecting) {
                              if (item.formula.isRecommended &&
                                  !widget.recommendedOnly) {
                                return _message(context, '推荐香方请在推荐香方页管理');
                              }
                              return _toggleFormula(item.formula.id);
                            }
                            _openFormula(
                              context,
                              widget.database,
                              widget.mediaStore,
                              item,
                              allowDelete: widget.recommendedOnly,
                            );
                          },
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
    ),
  );

  void _toggleDraft(String id) => setState(() {
    if (!_selectedDrafts.add(id)) _selectedDrafts.remove(id);
  });

  void _toggleFormula(String id) => setState(() {
    if (!_selectedFormulas.add(id)) _selectedFormulas.remove(id);
  });

  Future<void> _deleteSelected() async {
    final draftIds = {..._selectedDrafts};
    final formulaIds = {..._selectedFormulas};
    final total = draftIds.length + formulaIds.length;
    final confirmed = await showSingleModalBottomSheet<bool>(
      context: context,
      builder: (context) => _DeleteSelectionSheet(
        title: '删除所选 $total 项？',
        description: '香方将移入最近删除，未完成草稿会被删除。',
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deletingDrafts = true);
    try {
      for (final id in draftIds) {
        await widget.database.deleteFormulaDraft(id);
      }
      for (final id in formulaIds) {
        await widget.database.deleteFormula(
          id,
          allowRecommended: widget.recommendedOnly,
        );
      }
      if (!mounted) return;
      setState(() {
        _selectedDrafts.clear();
        _selectedFormulas.clear();
      });
      _message(context, '已删除 $total 项');
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    } finally {
      if (mounted) setState(() => _deletingDrafts = false);
    }
  }

  void _newFormula(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => FormulaComposerPage(
        database: widget.database,
        mediaStore: widget.mediaStore,
        recommended: widget.recommendedOnly,
      ),
    ),
  );
}

enum _FormulaCategory {
  all('全部'),
  selfBuilt('自建香方'),
  recommended('推荐香方');

  const _FormulaCategory(this.label);

  final String label;
}

class FormulaComposerPage extends StatefulWidget {
  const FormulaComposerPage({
    super.key,
    required this.database,
    required this.mediaStore,
    this.formula,
    this.sourceVersion,
    this.initialItems = const [],
    this.draftId,
    this.initialPlaqueTypeId,
    this.initialProductionTypeId,
    this.recommended = false,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final Formula? formula;
  final FormulaVersion? sourceVersion;
  final List<FormulaDraftItemInput> initialItems;
  final String? draftId;
  final String? initialPlaqueTypeId;
  final String? initialProductionTypeId;
  final bool recommended;

  @override
  State<FormulaComposerPage> createState() => _FormulaComposerPageState();
}

class _FormulaComposerPageState extends State<FormulaComposerPage> {
  final _name = TextEditingController();
  final _weight = TextEditingController();
  final _notes = TextEditingController();
  String? _imageHash;
  var _items = <FormulaDraftItemInput>[];
  List<ProductionType> _types = const [];
  List<FormulaIngredientChoice> _ingredients = const [];
  List<Customer> _customers = const [];
  String? _typeId;
  String? _customerId;
  String? _plaqueTypeId;
  var _loading = true;
  String? _draftId;
  Timer? _saveTimer;
  Future<FormulaDraft>? _saving;
  var _dirty = false;
  var _leaving = false;
  var _addItemOpen = false;
  late String _saveStatus;

  @override
  void initState() {
    super.initState();
    _name.text = widget.formula?.name ?? '';
    _items = [...widget.initialItems];
    _draftId = widget.draftId;
    _plaqueTypeId = widget.initialPlaqueTypeId;
    _imageHash = widget.formula?.imageHash;
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
      widget.database.getActiveFormulaIngredients(),
      widget.database.watchCustomers().first,
    ]);
    final saved = widget.draftId == null
        ? null
        : await widget.database.getComposerDraft(widget.draftId!);
    if (!mounted) return;
    setState(() {
      _types = values[0] as List<ProductionType>;
      _ingredients = values[1] as List<FormulaIngredientChoice>;
      _customers = values[2] as List<Customer>;
      _typeId =
          saved?.draft.productionTypeId ??
          widget.sourceVersion?.productionTypeId ??
          widget.initialProductionTypeId ??
          (_types.isEmpty ? null : _types.first.id);
      if (saved != null) {
        _name.text = saved.draft.formulaName;
        _weight.text = saved.targetWeightText;
        _notes.text = saved.draft.notes ?? '';
        _imageHash = saved.draft.imageHash;
        _customerId = saved.draft.customerId;
        _plaqueTypeId = saved.draft.plaqueTypeId;
        _items = saved.items;
      }
      _sortItemsByLibraryOrder();
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
              ? widget.recommended
                    ? '继续编辑推荐香方'
                    : '继续编辑香方'
              : widget.formula == null
              ? widget.recommended
                    ? '新建推荐香方'
                    : '新建香方'
              : '基于此香方调整',
        ),
        actions: [
          if (!_loading)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _RatioProgressCircle(ratio: _configuredRatio),
            ),
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
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _chooseImage,
                    child: SizedBox(
                      height: 156,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _FormulaArtwork(
                            name: _name.text,
                            imageHash: _imageHash,
                            mediaStore: widget.mediaStore,
                            borderRadius: 16,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.62),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _imageHash == null ? '添加香方图片' : '更换图片',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
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
                      onPressed: () {
                        setState(() => _imageHash = null);
                        _scheduleSave();
                      },
                      child: const Text('移除图片'),
                    ),
                  ),
                const SizedBox(height: 12),
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
                if (widget.formula == null)
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: _applyRecommendedFormula,
                        icon: const Icon(Icons.auto_awesome_outlined),
                        label: const Text('从推荐香方开始'),
                      ),
                      TextButton.icon(
                        onPressed: _reuseFormulaIngredients,
                        icon: const Icon(Icons.content_copy_outlined),
                        label: const Text('复用已有香方的全部香料'),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('formula-name'),
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: '香方名称',
                    helperText: '关联顾客后可留空自动生成',
                  ),
                  onChanged: (_) => _scheduleSave(),
                ),
                const SizedBox(height: 12),
                if (!widget.recommended) ...[
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
                    key: const ValueKey('formula-target-weight'),
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
                ],
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
                      tooltip: '选择香料',
                      onPressed: _addItem,
                      icon: const Icon(Icons.library_add_outlined),
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
                    child: Center(
                      child: FilledButton.icon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.grid_view_outlined),
                        label: const Text('从香料库选择'),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      for (var i = 0; i < _items.length; i++) ...[
                        _FormulaRatioEditor(
                          key: ValueKey(_items[i].ingredientId),
                          item: _items[i],
                          imageHash: _ingredients
                              .where(
                                (value) => value.id == _items[i].ingredientId,
                              )
                              .firstOrNull
                              ?.imageHash,
                          mediaStore: widget.mediaStore,
                          isLast: i == _items.length - 1,
                          onChanged: (value) {
                            try {
                              final ratio = parseRatio(value);
                              setState(() {
                                final current = _items[i];
                                _items[i] = FormulaDraftItemInput(
                                  ingredientId: current.ingredientId,
                                  categoryName: current.categoryName,
                                  ingredientName: current.ingredientName,
                                  ratio: ratio,
                                  sortOrder: current.sortOrder,
                                );
                              });
                              _scheduleSave();
                            } on FormatException {
                              // Keep the last valid ratio while the user types.
                            }
                          },
                          onDelete: () {
                            setState(() {
                              _items.removeAt(i);
                              _reorderItems();
                            });
                            _scheduleSave();
                          },
                        ),
                        if (i < _items.length - 1) const SizedBox(height: 10),
                      ],
                    ],
                  ),
                const SizedBox(height: 18),
                TextField(
                  controller: _notes,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: '香方备注（可选）',
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
            onPressed: widget.recommended
                ? _saveRecommendedFormula
                : _startMixing,
            child: Text(widget.recommended ? '保存推荐香方' : '进入调配'),
          ),
        ),
      ),
    ),
  );

  Future<void> _chooseImage() async {
    final selected = await _pickStoredImage(context, widget.mediaStore);
    if (selected == null || !mounted) return;
    setState(() => _imageHash = selected);
    _scheduleSave();
  }

  Future<void> _reuseFormulaIngredients() async {
    final formulas = await widget.database.watchFormulas().first;
    if (!mounted) return;
    if (formulas.isEmpty) return _message(context, '还没有可复用的香方');
    final selected = await showSingleModalBottomSheet<FormulaSummary>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '选择香方，只复用全部香料，比例重新填写',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final formula in formulas)
              ListTile(
                leading: SizedBox.square(
                  dimension: 48,
                  child: _FormulaArtwork(
                    name: formula.formula.name,
                    imageHash: formula.formula.imageHash,
                    mediaStore: widget.mediaStore,
                    borderRadius: 10,
                  ),
                ),
                title: Text(formula.formula.name),
                subtitle: Text(formula.productionTypeName),
                onTap: () => Navigator.pop(context, formula),
              ),
          ],
        ),
      ),
    );
    final versionId = selected?.formula.currentVersionId;
    if (versionId == null) return;
    final sourceItems = await widget.database.getVersionDraftItems(versionId);
    final ids = sourceItems.map((item) => item.ingredientId).toSet();
    final choices = _ingredients.where((item) => ids.contains(item.id)).toList()
      ..sort(_compareIngredientChoices);
    if (!mounted) return;
    setState(() {
      _items = [
        for (var i = 0; i < choices.length; i++)
          FormulaDraftItemInput(
            ingredientId: choices[i].id,
            categoryName: choices[i].categoryName,
            ingredientName: choices[i].ingredientName,
            ratio: 0,
            sortOrder: i,
          ),
      ];
    });
    _scheduleSave();
  }

  Future<void> _applyRecommendedFormula() async {
    final formulas = await widget.database
        .watchFormulas(recommendedOnly: true)
        .first;
    if (!mounted) return;
    if (formulas.isEmpty) return _message(context, '还没有推荐香方');
    final selected = await showSingleModalBottomSheet<FormulaSummary>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '选择推荐香方，带入香材与比例',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final formula in formulas)
              ListTile(
                leading: SizedBox.square(
                  dimension: 48,
                  child: _FormulaArtwork(
                    name: formula.formula.name,
                    imageHash: formula.formula.imageHash,
                    mediaStore: widget.mediaStore,
                    borderRadius: 10,
                  ),
                ),
                title: Text(formula.formula.name),
                subtitle: Text(formula.productionTypeName),
                onTap: () => Navigator.pop(context, formula),
              ),
          ],
        ),
      ),
    );
    final versionId = selected?.formula.currentVersionId;
    if (versionId == null) return;
    final version = await (widget.database.select(
      widget.database.formulaVersions,
    )..where((row) => row.id.equals(versionId))).getSingle();
    final items = await widget.database.getVersionDraftItems(versionId);
    if (!mounted) return;
    setState(() {
      _typeId = version.productionTypeId;
      _items = items;
    });
    _scheduleSave();
  }

  Future<void> _addItem() async {
    if (_addItemOpen) return;
    _addItemOpen = true;
    if (_ingredients.isEmpty) {
      _addItemOpen = false;
      return _message(context, '香料库中没有可用香料');
    }
    try {
      final selected = await Navigator.push<Set<String>>(
        context,
        MaterialPageRoute<Set<String>>(
          builder: (_) => FormulaIngredientPickerPage(
            choices: _ingredients,
            mediaStore: widget.mediaStore,
            initiallySelected: {for (final item in _items) item.ingredientId},
          ),
        ),
      );
      if (selected != null) {
        final existing = {for (final item in _items) item.ingredientId: item};
        final choices =
            _ingredients
                .where((choice) => selected.contains(choice.id))
                .toList()
              ..sort(_compareIngredientChoices);
        setState(() {
          _items = [
            for (var i = 0; i < choices.length; i++)
              FormulaDraftItemInput(
                ingredientId: choices[i].id,
                categoryName: choices[i].categoryName,
                ingredientName: choices[i].ingredientName,
                ratio: existing[choices[i].id]?.ratio ?? 0,
                sortOrder: i,
              ),
          ];
        });
        _scheduleSave();
      }
    } finally {
      _addItemOpen = false;
    }
  }

  Future<void> _createCustomer() async {
    var name = '';
    var phone = '';
    final customer = await showSingleDialog<Customer>(
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
          builder: (_) => MixingPage(
            database: widget.database,
            mediaStore: widget.mediaStore,
            draftId: draft.id,
          ),
        ),
      );
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    }
  }

  int get _configuredRatio =>
      _items.fold<int>(0, (sum, item) => sum + item.ratio);

  Future<void> _saveRecommendedFormula() async {
    try {
      _saveTimer?.cancel();
      await _saveDraft();
      await widget.database.completeRecommendedFormulaDraft(_draftId!);
      if (!mounted) return;
      setState(() => _leaving = true);
      Navigator.pop(context);
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _discardDraft() async {
    final confirmed = await showSingleModalBottomSheet<bool>(
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
      targetWeightText: widget.recommended ? '' : _weight.text,
      items: _items,
      formulaName: _name.text,
      notes: _notes.text,
      imageHash: _imageHash,
      isRecommended: widget.recommended,
      customerId: widget.recommended ? null : _customerId,
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
          ingredientId: _items[i].ingredientId,
          categoryName: _items[i].categoryName,
          ingredientName: _items[i].ingredientName,
          ratio: _items[i].ratio,
          sortOrder: i,
        ),
    ];
  }

  void _sortItemsByLibraryOrder() {
    final choices = {for (final choice in _ingredients) choice.id: choice};
    _items.sort((left, right) {
      final leftChoice = choices[left.ingredientId];
      final rightChoice = choices[right.ingredientId];
      if (leftChoice == null || rightChoice == null) {
        return left.sortOrder.compareTo(right.sortOrder);
      }
      return _compareIngredientChoices(leftChoice, rightChoice);
    });
    _reorderItems();
  }
}

int _compareIngredientChoices(
  FormulaIngredientChoice left,
  FormulaIngredientChoice right,
) {
  final category = left.categorySortOrder.compareTo(right.categorySortOrder);
  if (category != 0) return category;
  final leftPinyin = PinyinHelper.getPinyinE(
    left.ingredientName,
    separator: '',
  ).toLowerCase();
  final rightPinyin = PinyinHelper.getPinyinE(
    right.ingredientName,
    separator: '',
  ).toLowerCase();
  final name = leftPinyin.compareTo(rightPinyin);
  return name != 0 ? name : left.ingredientName.compareTo(right.ingredientName);
}

class _RatioProgressCircle extends StatelessWidget {
  const _RatioProgressCircle({required this.ratio});

  final int ratio;

  @override
  Widget build(BuildContext context) {
    final clamped = ratio.clamp(0, 10000);
    return Semantics(
      key: const ValueKey('formula-ratio-progress'),
      label: '已配置 ${formatFixed(ratio)}%',
      child: SizedBox.square(
        dimension: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: clamped / 10000,
              strokeWidth: 3,
              backgroundColor: const Color(0xffd1d1d6),
              color: ratio == 10000
                  ? const Color(0xff34c759)
                  : const Color(0xff354139),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${formatFixed(ratio)}%',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormulaIngredientPickerPage extends StatefulWidget {
  const FormulaIngredientPickerPage({
    super.key,
    required this.choices,
    required this.mediaStore,
    required this.initiallySelected,
  });

  final List<FormulaIngredientChoice> choices;
  final MediaStore mediaStore;
  final Set<String> initiallySelected;

  @override
  State<FormulaIngredientPickerPage> createState() =>
      _FormulaIngredientPickerPageState();
}

class _FormulaIngredientPickerPageState
    extends State<FormulaIngredientPickerPage> {
  final _search = TextEditingController();
  late final Set<String> _selected = {...widget.initiallySelected};
  String? _categoryId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final categories = <({String id, String name, int sortOrder})>[];
    final seenCategories = <String>{};
    for (final choice in widget.choices) {
      if (seenCategories.add(choice.categoryId)) {
        categories.add((
          id: choice.categoryId,
          name: choice.categoryName,
          sortOrder: choice.categorySortOrder,
        ));
      }
    }
    categories.sort((left, right) {
      final order = left.sortOrder.compareTo(right.sortOrder);
      return order != 0 ? order : left.name.compareTo(right.name);
    });
    final choices =
        widget.choices
            .where(
              (item) =>
                  (_categoryId == null || item.categoryId == _categoryId) &&
                  (query.isEmpty ||
                      item.ingredientName.toLowerCase().contains(query) ||
                      item.categoryName.toLowerCase().contains(query) ||
                      PinyinHelper.getPinyinE(
                        item.ingredientName,
                        separator: '',
                      ).toLowerCase().contains(query)),
            )
            .toList()
          ..sort(_compareIngredientChoices);
    return Scaffold(
      appBar: AppBar(
        title: Text('选择香料（${_selected.length}）'),
        actions: [
          TextButton(
            onPressed: _selected.isEmpty
                ? null
                : () => Navigator.pop(context, _selected),
            child: const Text('完成'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SearchBar(
              controller: _search,
              hintText: '搜索香料或大类',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = index == 0 ? null : categories[index - 1];
                final id = category?.id;
                return FilterChip(
                  label: Text(category?.name ?? '全部大类'),
                  selected: _categoryId == id,
                  onSelected: (_) => setState(() => _categoryId = id),
                );
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 600
                    ? 3
                    : 2;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: choices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .82,
                  ),
                  itemBuilder: (context, index) {
                    final choice = choices[index];
                    final selected = _selected.contains(choice.id);
                    return Material(
                      key: ValueKey('ingredient-choice-${choice.id}'),
                      color: selected ? const Color(0xffeaf2ff) : Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: selected
                              ? const Color(0xff007aff)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => setState(() {
                          if (!_selected.add(choice.id)) {
                            _selected.remove(choice.id);
                          }
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: choice.imageHash == null
                                  ? const ColoredBox(
                                      color: Color(0xffe6e9e7),
                                      child: Icon(Icons.spa_outlined, size: 44),
                                    )
                                  : Image.file(
                                      widget.mediaStore.fileFor(
                                        choice.imageHash!,
                                      ),
                                      fit: BoxFit.cover,
                                      cacheWidth: 480,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.broken_image_outlined,
                                      ),
                                    ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                choice.ingredientName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                choice.categoryName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: selected
                                    ? const Color(0xff007aff)
                                    : const Color(0xff8e8e93),
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
}

class _FormulaRatioEditor extends StatelessWidget {
  const _FormulaRatioEditor({
    super.key,
    required this.item,
    required this.mediaStore,
    required this.isLast,
    required this.onChanged,
    required this.onDelete,
    this.imageHash,
  });

  final FormulaDraftItemInput item;
  final MediaStore mediaStore;
  final String? imageHash;
  final bool isLast;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(13),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.square(
                  dimension: 48,
                  child: imageHash == null
                      ? const ColoredBox(
                          color: Color(0xffe6e9e7),
                          child: Icon(Icons.spa_outlined),
                        )
                      : Image.file(
                          mediaStore.fileFor(imageHash!),
                          fit: BoxFit.cover,
                          cacheWidth: 192,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.ingredientName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.categoryName,
                      style: const TextStyle(
                        color: Color(0xff636366),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '删除 ${item.ingredientName}',
                onPressed: onDelete,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: item.ratio == 0 ? '' : formatFixed(item.ratio),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: isLast
                ? TextInputAction.done
                : TextInputAction.next,
            decoration: const InputDecoration(
              labelText: '计划比例',
              suffixText: '%',
            ),
            onChanged: onChanged,
            onFieldSubmitted: (_) {
              if (!isLast) FocusScope.of(context).nextFocus();
            },
          ),
        ],
      ),
    ),
  );
}

class MixingPage extends StatefulWidget {
  const MixingPage({
    super.key,
    required this.database,
    required this.mediaStore,
    required this.draftId,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final String draftId;

  @override
  State<MixingPage> createState() => _MixingPageState();
}

class _MixingPageState extends State<MixingPage> {
  late final Future<MixingDraftState> _state = widget.database.getMixingDraft(
    widget.draftId,
  );
  final _pendingWeights = <int, String>{};
  final _saveTimers = <int, Timer>{};
  var _warningOpen = false;
  var _completing = false;

  @override
  void dispose() {
    for (final timer in _saveTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

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
            for (var i = 0; i < state.items.length; i++) ...[
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xffeef1ef),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: Color(0xff354139),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.items[i].label,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '预计比例 ${formatFixed(state.projectedRatios[i])}%',
                                  style: const TextStyle(
                                    color: Color(0xff636366),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '计划克重',
                                style: TextStyle(
                                  color: Color(0xff636366),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: formatFixed(
                                        state.plannedWeights[i],
                                      ),
                                      style: const TextStyle(
                                        color: Color(0xff243129),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' g',
                                      style: TextStyle(
                                        color: Color(0xff636366),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                key: ValueKey(
                                  'planned-weight-${state.draft.id}-$i',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(height: 1, color: const Color(0xffe5e5ea)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              '实际称量',
                              style: TextStyle(
                                color: Color(0xff354139),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '按计划称量 ${formatFixed(state.plannedWeights[i])}g',
                            style: const TextStyle(
                              color: Color(0xff636366),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey('${state.draft.id}-$i'),
                        initialValue: state.actualWeights[i] == null
                            ? ''
                            : formatFixed(state.actualWeights[i]!),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: i == state.items.length - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '输入实际克重',
                          suffixText: 'g',
                        ),
                        onChanged: (text) => _queueWeight(i, text),
                        onFieldSubmitted: (_) {
                          if (i < state.items.length - 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (i < state.items.length - 1) const SizedBox(height: 10),
            ],
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
        child: FilledButton(
          onPressed: _completing ? null : _complete,
          child: const Text('完成调配'),
        ),
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
    if (_completing) return;
    setState(() => _completing = true);
    try {
      await _flushWeights();
      if (!await _confirmAndFillMissingWeights()) return;
      if (!await _handleWarnings()) return;
      final session = await widget.database.completeDraft(widget.draftId);
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => MixingSessionPage(
            database: widget.database,
            mediaStore: widget.mediaStore,
            session: session,
          ),
        ),
      );
    } catch (error) {
      if (mounted) _message(context, _errorText(error));
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  Future<bool> _confirmAndFillMissingWeights() async {
    final state = await widget.database.getMixingDraft(widget.draftId);
    final missing = <int>[
      for (var i = 0; i < state.actualWeights.length; i++)
        if (state.actualWeights[i] == null) i,
    ];
    if (missing.isEmpty) return true;
    if (!mounted) return false;
    final confirmed = await showSingleDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('有香料尚未填写克重'),
        content: Text(
          '共有 ${missing.length} 味香料未填写实际克重。确认后将按各自计划克重自动填入，再继续完成调配。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('返回填写'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('按计划克重填入'),
          ),
        ],
      ),
    );
    if (confirmed != true) return false;
    await widget.database.fillMissingDraftWeightsFromPlan(widget.draftId);
    return true;
  }

  Future<bool> _handleWarnings() async {
    if (_warningOpen) return true;
    _warningOpen = true;
    try {
      final warnings = await widget.database.getDraftRangeWarnings(
        widget.draftId,
      );
      if (!mounted || warnings.isEmpty) return true;
      final confirmed = await showSingleDialog<bool>(
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
      if (confirmed != true) return false;
      await widget.database.confirmDraftWarnings(
        widget.draftId,
        warnings.map((item) => item.key),
      );
      return true;
    } finally {
      _warningOpen = false;
    }
  }

  Future<void> _deleteDraft() async {
    final confirmed = await showSingleModalBottomSheet<bool>(
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

class FormulaDetailPage extends StatefulWidget {
  const FormulaDetailPage({
    super.key,
    required this.database,
    required this.mediaStore,
    required this.summary,
    this.allowDelete = false,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final FormulaSummary summary;
  final bool allowDelete;

  @override
  State<FormulaDetailPage> createState() => _FormulaDetailPageState();
}

class _FormulaDetailPageState extends State<FormulaDetailPage> {
  AppDatabase get database => widget.database;
  MediaStore get mediaStore => widget.mediaStore;
  FormulaSummary get summary => widget.summary;
  late String? _imageHash;
  late final Future<List<FormulaIngredientSummary>> _ingredientDetails;

  @override
  void initState() {
    super.initState();
    _imageHash = summary.formula.imageHash;
    _ingredientDetails = summary.formula.currentVersionId == null
        ? Future.value(const [])
        : database.getFormulaIngredientDetails(
            summary.formula.currentVersionId!,
          );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(summary.formula.name),
      actions: [
        if (!summary.formula.isRecommended || widget.allowDelete)
          PopupMenuButton<String>(
            tooltip: '更多操作',
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) =>
                value == 'edit' ? _edit(context) : _delete(context),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 12),
                    Text('修改名称和备注'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
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
            SizedBox(
              height: 170,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _openArtwork(context),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _FormulaArtwork(
                        name: summary.formula.name,
                        imageHash: _imageHash,
                        mediaStore: mediaStore,
                        borderRadius: 16,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.62),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo_camera_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _imageHash == null ? '添加香方图片' : '查看或更换图片',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
            if (summary.formula.notes != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '香方备注',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      summary.formula.notes!,
                      style: const TextStyle(
                        color: Color(0xff3a3a3c),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              [
                summary.productionTypeName,
                summary.topIngredients,
              ].where((text) => text.isNotEmpty).join(' · '),
              style: const TextStyle(color: Color(0xff636366), fontSize: 11),
            ),
            if (summary.customers.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '关联顾客：${summary.customers.map(_customerLabel).join('、')}',
                style: const TextStyle(color: Color(0xff636366), fontSize: 11),
              ),
            ],
            const SizedBox(height: 18),
            Text('香料目录', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder<List<FormulaIngredientSummary>>(
              future: _ingredientDetails,
              builder: (context, ingredientSnapshot) {
                final ingredients = ingredientSnapshot.data;
                if (ingredients == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < ingredients.length;
                        index++
                      ) ...[
                        _FormulaIngredientDetailTile(
                          ingredient: ingredients[index],
                          mediaStore: mediaStore,
                        ),
                        if (index != ingredients.length - 1)
                          const Divider(height: 1, indent: 76),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _repeat(context),
              child: const Text('开始调配'),
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
                                  mediaStore: mediaStore,
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
            builder: (_) => MixingPage(
              database: database,
              mediaStore: mediaStore,
              draftId: draft.id,
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) _message(context, _errorText(error));
    }
  }

  Future<void> _openArtwork(BuildContext context) async {
    final result = await Navigator.push<({bool changed, String? imageHash})>(
      context,
      MaterialPageRoute(
        builder: (_) => _FormulaImagePage(
          name: summary.formula.name,
          imageHash: _imageHash,
          mediaStore: mediaStore,
        ),
      ),
    );
    if (result == null || !result.changed || !mounted) return;
    try {
      await database.updateFormulaImage(summary.formula.id, result.imageHash);
      if (mounted) setState(() => _imageHash = result.imageHash);
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
            mediaStore: mediaStore,
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
        mediaStore: mediaStore,
        formula: summary.formula,
      ),
    ),
  );

  Future<void> _edit(BuildContext context) async {
    var name = summary.formula.name;
    var notes = summary.formula.notes ?? '';
    var imageHash = _imageHash;
    final saved = await showSingleDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('修改香方'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  child: _FormulaArtwork(
                    name: name,
                    imageHash: imageHash,
                    mediaStore: mediaStore,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final selected = await _pickStoredImage(
                          context,
                          mediaStore,
                        );
                        if (selected != null && context.mounted) {
                          setDialogState(() => imageHash = selected);
                        }
                      },
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(imageHash == null ? '选择图片' : '更换图片'),
                    ),
                    if (imageHash != null)
                      TextButton(
                        onPressed: () => setDialogState(() => imageHash = null),
                        child: const Text('移除'),
                      ),
                  ],
                ),
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
                  await database.updateFormulaImage(
                    summary.formula.id,
                    imageHash,
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
    if (saved == true && context.mounted) Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await database.deleteFormula(
      summary.formula.id,
      allowRecommended: widget.allowDelete,
    );
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

class _FormulaIngredientDetailTile extends StatelessWidget {
  const _FormulaIngredientDetailTile({
    required this.ingredient,
    required this.mediaStore,
  });

  final FormulaIngredientSummary ingredient;
  final MediaStore mediaStore;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox.square(
            dimension: 52,
            child: ingredient.imageHash == null
                ? const ColoredBox(
                    color: Color(0xffe6e9e7),
                    child: Icon(Icons.spa_outlined),
                  )
                : Image.file(
                    mediaStore.fileFor(ingredient.imageHash!),
                    fit: BoxFit.cover,
                    cacheWidth: 192,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: Color(0xffe6e9e7),
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ingredient.item.ingredientName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                ingredient.item.categoryName,
                style: const TextStyle(color: Color(0xff636366), fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${formatFixed(ingredient.item.ratio)}%',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class FormulaVersionHistoryPage extends StatelessWidget {
  const FormulaVersionHistoryPage({
    super.key,
    required this.database,
    required this.mediaStore,
    required this.formula,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
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
          builder: (_) => MixingPage(
            database: database,
            mediaStore: mediaStore,
            draftId: draft.id,
          ),
        ),
      );
    }
  }
}

class MixingSessionPage extends StatelessWidget {
  const MixingSessionPage({
    super.key,
    required this.database,
    required this.mediaStore,
    required this.session,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final MixingSession session;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('调配完成'),
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
    body: _MixingSessionBody(
      database: database,
      mediaStore: mediaStore,
      session: session,
    ),
  );

  Future<void> _edit(BuildContext context) async {
    await runSingleModalAction<void>(
      context: context,
      action: 'mixing-session-editor',
      body: () async {
        final items = await database.watchMixingItems(session.id).first;
        final texts = [for (final item in items) formatFixed(item.finalWeight)];
        if (!context.mounted) return;
        final saved = await showSingleDialog<bool>(
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
        if (saved == true && context.mounted) {
          _message(context, '已保存修改');
        }
      },
    );
  }

  Future<void> _copyToCustomer(BuildContext context) async {
    await runSingleModalAction<void>(
      context: context,
      action: 'mixing-session-copy-customer',
      body: () async {
        final customers = await database.watchCustomers().first;
        if (!context.mounted) return;
        if (customers.isEmpty) return _message(context, '请先建立顾客');
        var customerId = customers.first.id;
        final selected = await showSingleDialog<String>(
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
      },
    );
  }
}

class _MixingSessionBody extends StatelessWidget {
  const _MixingSessionBody({
    required this.database,
    required this.mediaStore,
    required this.session,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final MixingSession session;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<MixingItem>>(
    stream: database.watchMixingItems(session.id),
    builder: (context, snapshot) {
      final items = snapshot.data ?? const <MixingItem>[];
      final total = items.fold<int>(0, (sum, item) => sum + item.finalWeight);
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          FutureBuilder<Formula?>(
            future: session.formulaId == null
                ? Future.value()
                : (database.select(database.formulas)
                        ..where((row) => row.id.equals(session.formulaId!)))
                      .getSingleOrNull(),
            builder: (context, formulaSnapshot) {
              final formula = formulaSnapshot.data;
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 150,
                      child: formula?.imageHash == null
                          ? const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xff354139),
                                    Color(0xff738078),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 58,
                                color: Colors.white,
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  mediaStore.fileFor(formula!.imageHash!),
                                  fit: BoxFit.cover,
                                ),
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x00000000),
                                        Color(0x77000000),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xff248a3d),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  session.formulaName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _SessionFact(
                            icon: Icons.person_outline,
                            label: '顾客',
                            child: FutureBuilder<Customer?>(
                              future: session.customerId == null
                                  ? Future.value()
                                  : (database.select(database.customers)..where(
                                          (row) => row.id.equals(
                                            session.customerId!,
                                          ),
                                        ))
                                        .getSingleOrNull(),
                              builder: (_, customerSnapshot) => Text(
                                _customerLabel(customerSnapshot.data),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _SessionFact(
                            icon: Icons.schedule_outlined,
                            label: '调配时间',
                            child: Text(_dateText(session.completedAtUtc)),
                          ),
                          const SizedBox(height: 10),
                          _SessionFact(
                            icon: Icons.scale_outlined,
                            label: '最终总重',
                            child: Text(
                              '${formatFixed(total)}g · 目标 ${formatFixed(session.targetWeight)}g',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (session.plaqueTypeId != null) ...[
            const SizedBox(height: 14),
            FutureBuilder<PlaqueType?>(
              future:
                  (database.select(database.plaqueTypes)
                        ..where((row) => row.id.equals(session.plaqueTypeId!)))
                      .getSingleOrNull(),
              builder: (context, plaqueSnapshot) {
                final plaque = plaqueSnapshot.data;
                if (plaque?.imageHash == null) return const SizedBox.shrink();
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      SizedBox.square(
                        dimension: 92,
                        child: Image.file(
                          mediaStore.fileFor(plaque!.imageHash!),
                          fit: BoxFit.cover,
                          cacheWidth: 320,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '本次成品',
                              style: TextStyle(
                                color: Color(0xff636366),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plaque.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 22),
          Text(
            '香料明细 · ${items.length} 味',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < items.length; i++) ...[
            _MixingItemCard(
              database: database,
              mediaStore: mediaStore,
              item: items[i],
            ),
            if (i < items.length - 1) const SizedBox(height: 10),
          ],
          FutureBuilder<List<MixingRevision>>(
            future: database.getMixingRevisions(session.id),
            builder: (context, revisions) => revisions.data?.isNotEmpty == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text('已修改 ${revisions.data!.length} 次'),
                        subtitle: const Text('修改前数据已保留'),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    },
  );
}

class _SessionFact extends StatelessWidget {
  const _SessionFact({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 19, color: const Color(0xff636366)),
      const SizedBox(width: 9),
      SizedBox(
        width: 68,
        child: Text(
          label,
          style: const TextStyle(color: Color(0xff636366), fontSize: 12),
        ),
      ),
      Expanded(child: child),
    ],
  );
}

class _MixingItemCard extends StatelessWidget {
  const _MixingItemCard({
    required this.database,
    required this.mediaStore,
    required this.item,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final MixingItem item;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(13),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox.square(
              dimension: 54,
              child: FutureBuilder<Ingredient?>(
                future: item.ingredientId == null
                    ? Future.value()
                    : (database.select(database.ingredients)
                            ..where((row) => row.id.equals(item.ingredientId!)))
                          .getSingleOrNull(),
                builder: (_, ingredientSnapshot) {
                  final hash = ingredientSnapshot.data?.imageHash;
                  return hash == null
                      ? const ColoredBox(
                          color: Color(0xffe6e9e7),
                          child: Icon(Icons.spa_outlined),
                        )
                      : Image.file(
                          mediaStore.fileFor(hash),
                          fit: BoxFit.cover,
                          cacheWidth: 192,
                        );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.ingredientName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.categoryName} · ${item.isManual ? '手工填写' : '系统补全'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff636366),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${formatFixed(item.finalWeight)}g',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '${formatFixed(item.finalRatio)}%',
                style: const TextStyle(color: Color(0xff636366), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<(int, String?)?> _askMixingOptions(
  BuildContext context,
  AppDatabase database,
) async {
  return runSingleModalAction<(int, String?)>(
    context: context,
    action: 'mixing-options',
    body: () async {
      final customers = await database.watchCustomers().first;
      if (!context.mounted) return null;
      return showModalBottomSheet<(int, String?)>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (_) => _MixingOptionsSheet(
          database: database,
          initialCustomers: customers,
        ),
      );
    },
  );
}

class _MixingOptionsSheet extends StatefulWidget {
  const _MixingOptionsSheet({
    required this.database,
    required this.initialCustomers,
  });

  final AppDatabase database;
  final List<Customer> initialCustomers;

  @override
  State<_MixingOptionsSheet> createState() => _MixingOptionsSheetState();
}

class _MixingOptionsSheetState extends State<_MixingOptionsSheet> {
  final _weight = TextEditingController();
  late List<Customer> _customers;
  String? _customerId;

  @override
  void initState() {
    super.initState();
    _customers = widget.initialCustomers;
  }

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('开始调配', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _weight,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: '目标总克重',
              suffixText: 'g',
            ),
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            key: ValueKey('$_customerId-${_customers.length}'),
            initialValue: _customerId,
            isExpanded: true,
            menuMaxHeight: 280,
            decoration: const InputDecoration(labelText: '顾客（可选）'),
            items: [
              const DropdownMenuItem(value: null, child: Text('不关联顾客')),
              for (final customer in _customers)
                DropdownMenuItem(
                  value: customer.id,
                  child: Text(
                    _customerLabel(customer),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (value) => setState(() => _customerId = value),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _createCustomer,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('新建顾客并选择'),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _submit, child: const Text('进入调配')),
        ],
      ),
    ),
  );

  Future<void> _createCustomer() async {
    final customer = await _createCustomerForMixing(context, widget.database);
    if (customer == null || !mounted) return;
    setState(() {
      _customers = [..._customers, customer];
      _customerId = customer.id;
    });
  }

  void _submit() {
    try {
      Navigator.pop(context, (parseWeight(_weight.text), _customerId));
    } catch (error) {
      _message(context, _errorText(error));
    }
  }
}

Future<Customer?> _createCustomerForMixing(
  BuildContext context,
  AppDatabase database,
) async {
  var name = '';
  var phone = '';
  var notes = '';
  return showSingleDialog<Customer>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('新建顾客'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(labelText: '姓名'),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: '电话'),
              onChanged: (value) => phone = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
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
              final customer = await database.createCustomer(
                name: name,
                phone: phone,
                notes: notes,
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
}

class _FormulaImagePage extends StatelessWidget {
  const _FormulaImagePage({
    required this.name,
    required this.imageHash,
    required this.mediaStore,
  });

  static const _mediaChannel = MethodChannel('xiangfangbu/media');

  final String name;
  final String? imageHash;
  final MediaStore mediaStore;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text(name),
    ),
    body: Column(
      children: [
        Expanded(
          child: Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: imageHash == null
                  ? SizedBox.square(
                      dimension: 300,
                      child: _FormulaArtwork(
                        name: name,
                        imageHash: null,
                        mediaStore: mediaStore,
                        borderRadius: 0,
                      ),
                    )
                  : Image.file(
                      mediaStore.fileFor(imageHash!),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.broken_image_outlined,
                        size: 64,
                        color: Colors.white70,
                      ),
                    ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              if (imageHash != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    onPressed: () => _save(context),
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('保存图片'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _replace(context),
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: Text(imageHash == null ? '添加图片' : '更换图片'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Future<void> _replace(BuildContext context) async {
    final selected = await _pickStoredImage(context, mediaStore);
    if (selected != null && context.mounted) {
      Navigator.pop(context, (changed: true, imageHash: selected));
    }
  }

  Future<void> _save(BuildContext context) async {
    try {
      await _mediaChannel.invokeMethod<void>('saveImage', {
        'path': mediaStore.fileFor(imageHash!).path,
        'displayName': '${name.trim().isEmpty ? '香方' : name.trim()}.jpg',
      });
      if (context.mounted) _message(context, '图片已保存到相册');
    } catch (_) {
      if (context.mounted) _message(context, '保存图片失败，请重试');
    }
  }
}

void _openFormula(
  BuildContext context,
  AppDatabase database,
  MediaStore mediaStore,
  FormulaSummary summary, {
  bool allowDelete = false,
}) => Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (_) => FormulaDetailPage(
      database: database,
      mediaStore: mediaStore,
      summary: summary,
      allowDelete: allowDelete,
    ),
  ),
);

String _dateText(DateTime utc) {
  final value = utc.toLocal();
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String _customerLabel(Customer? customer) {
  if (customer == null) return '未关联顾客';
  if (customer.name.isEmpty) return customer.phone;
  if (customer.phone.isEmpty) return customer.name;
  return '${customer.name} · ${customer.phone}';
}

Future<String?> _pickStoredImage(BuildContext context, MediaStore mediaStore) =>
    pickAndCropStoredImage(context, mediaStore, aspectRatio: 4 / 3);

void _message(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

String _errorText(Object error) {
  if (error is ArgumentError) return error.message.toString();
  if (error is FormatException) return error.message;
  if (error is StateError) return error.message;
  return '操作失败，请重试';
}
