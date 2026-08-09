import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/app_database.dart';
import 'data/media_store.dart';
import 'features/assets/asset_inventory_page.dart';
import 'features/customers/customers_page.dart';
import 'features/formulas/formulas_page.dart';
import 'features/ingredients/ingredient_library_page.dart';
import 'features/plaques/plaque_catalog_page.dart';
import 'features/recommendations/recommendation_presets_page.dart';
import 'features/settings/settings_page.dart';
import 'features/trash/recently_deleted_page.dart';
import 'services/peer_sync_runtime.dart';

class XiangApp extends StatelessWidget {
  const XiangApp({
    super.key,
    required this.database,
    required this.mediaStore,
    this.syncRuntime,
    this.syncRuntimeLoader,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final PeerSyncRuntime? syncRuntime;
  final Future<PeerSyncRuntime> Function()? syncRuntimeLoader;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '香方簿',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('zh', 'CN')],
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: const Color(0xfff2f2f7),
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: child!,
      ),
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xff007aff),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xff007aff),
              onPrimary: Colors.white,
              surface: const Color(0xffffffff),
              onSurface: const Color(0xff1c1c1e),
              surfaceContainerLowest: const Color(0xfff2f2f7),
              outline: const Color(0xffc6c6c8),
              error: const Color(0xffff3b30),
            ),
        scaffoldBackgroundColor: const Color(0xfff2f2f7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xff1c1c1e),
          elevation: 0,
          centerTitle: true,
        ),
        dividerTheme: const DividerThemeData(color: Color(0xffd1d1d6)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xff007aff)),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
        ),
        useMaterial3: true,
      ),
      home: _Shell(
        database: database,
        mediaStore: mediaStore,
        syncRuntime: syncRuntime,
        syncRuntimeLoader: syncRuntimeLoader,
      ),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell({
    required this.database,
    required this.mediaStore,
    this.syncRuntime,
    this.syncRuntimeLoader,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final PeerSyncRuntime? syncRuntime;
  final Future<PeerSyncRuntime> Function()? syncRuntimeLoader;

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> with WidgetsBindingObserver {
  var _index = 0;
  PeerSyncRuntime? _runtime;
  Future<PeerSyncRuntime?>? _syncInitialization;
  Object? _syncInitializationError;
  var _syncInitializing = false;
  var _syncRuntimeStarted = false;
  var _openingSyncDevices = false;
  var _exitArmed = false;
  Timer? _exitTimer;
  OverlayEntry? _exitHint;

  @override
  void initState() {
    super.initState();
    _runtime = widget.syncRuntime;
    if (_runtime != null || widget.syncRuntimeLoader != null) {
      WidgetsBinding.instance.addObserver(this);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_initializeSync());
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final runtime = _runtime;
    if (runtime == null) return;
    if (state == AppLifecycleState.resumed) {
      unawaited(_resumeSync(runtime));
    } else {
      unawaited(runtime.stop());
    }
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    _exitHint?.remove();
    final runtime = _runtime;
    if (widget.syncRuntime != null || widget.syncRuntimeLoader != null) {
      WidgetsBinding.instance.removeObserver(this);
    }
    if (runtime != null) {
      unawaited(runtime.close());
    }
    super.dispose();
  }

  Future<PeerSyncRuntime?> _initializeSync() => _syncInitialization ??=
      _initializeSyncOnce().whenComplete(() => _syncInitialization = null);

  Future<PeerSyncRuntime?> _initializeSyncOnce() async {
    final current = _runtime;
    if (current != null) {
      if (!_syncRuntimeStarted) {
        await _resumeSync(current);
        _syncRuntimeStarted = true;
      }
      return current;
    }
    final loader = widget.syncRuntimeLoader;
    if (loader == null) return null;
    if (mounted) {
      setState(() {
        _syncInitializing = true;
        _syncInitializationError = null;
      });
    }
    try {
      final runtime = await loader();
      if (!mounted) {
        await runtime.close();
        return null;
      }
      setState(() => _runtime = runtime);
      await _resumeSync(runtime);
      _syncRuntimeStarted = true;
      return runtime;
    } catch (error, stackTrace) {
      debugPrint('Failed to initialize sync runtime: $error\n$stackTrace');
      if (mounted) setState(() => _syncInitializationError = error);
      return null;
    } finally {
      if (mounted) setState(() => _syncInitializing = false);
    }
  }

  Future<void> _openSyncDevices() async {
    if (_openingSyncDevices) return;
    _openingSyncDevices = true;
    try {
      final runtime = await _initializeSync();
      if (!mounted) return;
      if (runtime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('同步服务初始化失败，请点按重试')));
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SyncDevicesPage(runtime: runtime),
        ),
      );
    } finally {
      _openingSyncDevices = false;
    }
  }

  Future<void> _resumeSync(PeerSyncRuntime runtime) async {
    try {
      await runtime.start();
      await runtime.syncAll();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(database: widget.database, mediaStore: widget.mediaStore),
      IngredientLibraryPage(
        database: widget.database,
        mediaStore: widget.mediaStore,
        syncRuntime: _runtime,
      ),
      _MorePage(
        database: widget.database,
        mediaStore: widget.mediaStore,
        syncRuntime: _runtime,
        syncInitializing: _syncInitializing,
        syncInitializationFailed: _syncInitializationError != null,
        onOpenSync: _openSyncDevices,
      ),
    ];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(index: _index, children: pages),
        bottomNavigationBar: _GlassNavigationBar(
          index: _index,
          onChanged: (index) => setState(() => _index = index),
        ),
      ),
    );
  }

  void _handleBack() {
    if (_exitArmed) {
      _exitArmed = false;
      _exitTimer?.cancel();
      _exitTimer = null;
      _removeExitHint();
      unawaited(SystemNavigator.pop());
      return;
    }

    _exitArmed = true;
    _showExitHint();
    _exitTimer = Timer(const Duration(seconds: 2), () {
      _exitArmed = false;
      _exitTimer = null;
      _removeExitHint();
    });
  }

  void _showExitHint() {
    _removeExitHint();
    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: SizedBox.expand(
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x99666666),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Text(
                  '再按一次退出香方簿',
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    _exitHint = entry;
    overlay.insert(entry);
  }

  void _removeExitHint() {
    final hint = _exitHint;
    if (hint == null) return;
    _exitHint = null;
    hint.remove();
  }
}

class _GlassNavigationBar extends StatelessWidget {
  const _GlassNavigationBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, '首页'),
      (Icons.menu_book_outlined, '香料'),
      (Icons.more_horiz, '更多'),
    ];
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .72),
                border: Border.all(color: Colors.white.withValues(alpha: .84)),
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 22,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: index == i,
                        label: items[i].$2,
                        excludeSemantics: true,
                        child: InkWell(
                          onTap: () => onChanged(i),
                          borderRadius: BorderRadius.circular(28),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: index == i
                                  ? const Color(0x1f007aff)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  items[i].$1,
                                  size: 20,
                                  color: index == i
                                      ? const Color(0xff007aff)
                                      : const Color(0xff636366),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  items[i].$2,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: index == i
                                        ? const Color(0xff007aff)
                                        : const Color(0xff636366),
                                    fontWeight: index == i
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MorePage extends StatelessWidget {
  const _MorePage({
    required this.database,
    required this.mediaStore,
    required this.syncInitializing,
    required this.syncInitializationFailed,
    required this.onOpenSync,
    this.syncRuntime,
  });

  final AppDatabase database;
  final MediaStore mediaStore;
  final PeerSyncRuntime? syncRuntime;
  final bool syncInitializing;
  final bool syncInitializationFailed;
  final VoidCallback onOpenSync;

  @override
  Widget build(BuildContext context) {
    Widget tile(String item) => ListTile(
      title: Text(item),
      subtitle: switch (item) {
        '同步与设备' when syncRuntime != null => const Text('局域网设备与配对状态'),
        '同步与设备' when syncInitializing => const Text('正在初始化局域网同步'),
        '同步与设备' when syncInitializationFailed => const Text('初始化失败，点按重试'),
        '同步与设备' => const Text('局域网设备与配对状态'),
        '备份与恢复' => const Text('后续里程碑'),
        _ => null,
      },
      trailing: switch (item) {
        '备份与恢复' => null,
        _ => const Icon(Icons.chevron_right, color: Color(0xffc7c7cc)),
      },
      onTap: switch (item) {
        '香料库' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => IngredientLibraryPage(
              database: database,
              mediaStore: mediaStore,
              syncRuntime: syncRuntime,
            ),
          ),
        ),
        '推荐香方' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RecommendationPresetsPage(
              database: database,
              mediaStore: mediaStore,
            ),
          ),
        ),
        '合香珠 / 香牌目录' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                PlaqueCatalogPage(database: database, mediaStore: mediaStore),
          ),
        ),
        '顾客' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                CustomersPage(database: database, mediaStore: mediaStore),
          ),
        ),
        '资产清点' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                AssetInventoryPage(database: database, mediaStore: mediaStore),
          ),
        ),
        '最近删除' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RecentlyDeletedPage(database: database),
          ),
        ),
        '设置' => () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SettingsPage(database: database),
          ),
        ),
        '同步与设备' => onOpenSync,
        _ => null,
      },
    );

    Widget section(String title, List<String> items) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 7),
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xff636366)),
          ),
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                tile(items[i]),
                if (i < items.length - 1) const Divider(height: 1, indent: 16),
              ],
            ],
          ),
        ),
      ],
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 112),
        children: [
          Text('更多', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 22),
          section('资料管理', const ['香料库', '合香珠 / 香牌目录', '顾客', '推荐香方', '资产清点']),
          const SizedBox(height: 22),
          section('数据', const ['最近删除', '同步与设备', '备份与恢复']),
          const SizedBox(height: 22),
          section('应用', const ['设置']),
        ],
      ),
    );
  }
}
