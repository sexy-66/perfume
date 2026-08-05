import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/app_database.dart';
import 'data/media_store.dart';
import 'features/assets/asset_inventory_page.dart';
import 'features/customers/customers_page.dart';
import 'features/ingredients/ingredient_library_page.dart';
import 'features/plaques/plaque_catalog_page.dart';
import 'features/recommendations/recommendation_presets_page.dart';
import 'features/settings/settings_page.dart';
import 'features/trash/recently_deleted_page.dart';

class XiangApp extends StatelessWidget {
  const XiangApp({super.key, required this.database, required this.mediaStore});

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '香方簿',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('zh', 'CN')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6b4f3a)),
        useMaterial3: true,
      ),
      home: _Shell(database: database, mediaStore: mediaStore),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell({required this.database, required this.mediaStore});

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _Page(title: '主页', icon: Icons.home_outlined),
      const _Page(title: '香方', icon: Icons.menu_book_outlined),
      _MorePage(database: widget.database, mediaStore: widget.mediaStore),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '主页'),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: '香方',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: '更多'),
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class _MorePage extends StatelessWidget {
  const _MorePage({required this.database, required this.mediaStore});

  final AppDatabase database;
  final MediaStore mediaStore;

  static const _items = <String>[
    '香料库',
    '香牌目录',
    '顾客',
    '推荐配置',
    '资产清点',
    '最近删除',
    '同步与设备',
    '备份与恢复',
    '设置',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        children: [
          Text('更多', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          for (final item in _items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item),
              subtitle: switch (item) {
                '同步与设备' || '备份与恢复' => const Text('后续里程碑'),
                _ => null,
              },
              trailing: switch (item) {
                '同步与设备' || '备份与恢复' => null,
                _ => const Icon(Icons.chevron_right),
              },
              onTap: switch (item) {
                '香料库' => () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => IngredientLibraryPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
                  ),
                ),
                '推荐配置' => () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        RecommendationPresetsPage(database: database),
                  ),
                ),
                '香牌目录' => () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PlaqueCatalogPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
                  ),
                ),
                '顾客' => () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CustomersPage(database: database),
                  ),
                ),
                '资产清点' => () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AssetInventoryPage(
                      database: database,
                      mediaStore: mediaStore,
                    ),
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
                _ => null,
              },
            ),
        ],
      ),
    );
  }
}
