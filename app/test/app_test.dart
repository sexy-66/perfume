import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/app.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  testWidgets('shows the three destinations and ordered more page', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    await tester.pumpWidget(XiangApp(database: database));

    expect(find.text('主页'), findsWidgets);
    expect(find.text('香方'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);

    await tester.tap(find.text('更多'));
    await tester.pump();
    for (final item in const [
      '香料库',
      '香牌目录',
      '顾客',
      '推荐配置',
      '资产清点',
      '最近删除',
      '同步与设备',
      '备份与恢复',
      '设置',
    ]) {
      expect(find.text(item), findsOneWidget);
    }

    await tester.tap(find.text('香料库'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      find.widgetWithText(SearchBar, '搜索名称、别名、SKU、供应商或分类'),
      findsOneWidget,
    );
    expect(find.text('添加第一项'), findsOneWidget);
    expect(find.byTooltip('管理分类'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });

  testWidgets('saving an ingredient closes the dialog without a red screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    await database.createIngredientCategory('木类');
    await tester.pumpWidget(XiangApp(database: database));

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('香料库'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('添加香料'), findsOneWidget);
    await tester.tap(find.byTooltip('添加香料'));
    await tester.pumpAndSettle();
    expect(find.text('添加香料'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).first, '沉香');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(find.text('沉香'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });
}
