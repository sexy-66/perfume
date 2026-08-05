import 'package:flutter/material.dart';

import 'data/app_database.dart';

class XiangApp extends StatelessWidget {
  const XiangApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '香方簿',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6b4f3a)),
        useMaterial3: true,
      ),
      home: const _Shell(),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  var _index = 0;

  static const _pages = <Widget>[
    _Page(title: '主页', icon: Icons.home_outlined),
    _Page(title: '香方', icon: Icons.menu_book_outlined),
    _MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
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
  const _MorePage();

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
            ),
        ],
      ),
    );
  }
}
