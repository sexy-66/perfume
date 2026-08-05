import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/app.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';
import 'package:xiangfangbu/features/recommendations/recommendation_preset_detail_page.dart';

void main() {
  testWidgets('shows the three destinations and ordered more page', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    final mediaStore = MediaStore(mediaDirectory);
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: mediaStore),
    );

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

    await tester.tap(find.text('推荐配置'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('添加推荐配置'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '篆香基础');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();
    expect(find.text('篆香基础'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

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
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('saving an ingredient closes the dialog without a red screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    final mediaStore = MediaStore(mediaDirectory);
    await database.initialize();
    await database.createIngredientCategory('木类');
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: mediaStore),
    );

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

    await tester.tap(find.text('沉香'));
    await tester.pumpAndSettle();
    expect(find.text('添加第一个 SKU'), findsOneWidget);
    await tester.tap(find.byTooltip('香料推荐区间'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('篆香'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '12.5');
    await tester.enterText(find.byType(TextFormField).last, '25');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();
    expect(find.text('12.50%–25.00%'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('添加 SKU'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'AG-01');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();
    expect(find.text('AG-01'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('creates a plaque from the catalog without a red screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('香牌目录'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('添加香牌'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '如意牌');
    await tester.enterText(find.byType(TextFormField).at(1), '6 × 3 cm');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(find.text('如意牌'), findsOneWidget);
    expect(find.text('6 × 3 cm'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('creates and searches a phone-only customer', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('顾客'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('添加顾客'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pump();
    expect(find.text('姓名和电话不能同时为空'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), '+81 90-1234');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();
    expect(find.text('+81 90-1234'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('+81 90-1234的更多操作'));
    await tester.pumpAndSettle();
    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('删除'), findsOneWidget);
    expect(find.text('停用'), findsNothing);
    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(SearchBar), '90-1234');
    await tester.pumpAndSettle();
    expect(find.text('+81 90-1234'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('creates an asset with category and quantity', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    await database.createAssetCategory('工具');
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('资产清点'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('添加资产'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '压香器');
    await tester.enterText(find.byType(TextFormField).at(1), '2');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(find.text('压香器 × 2'), findsOneWidget);
    expect(find.text('工具'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('restores a customer from recently deleted', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    final customer = await database.createCustomer(name: '王女士');
    await database.deleteCustomer(customer.id);
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('最近删除'));
    await tester.pumpAndSettle();
    expect(find.text('王女士'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, '恢复'));
    await tester.pumpAndSettle();
    expect(find.text('最近 30 天没有删除的资料'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('adds a production type from settings', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('制作类型'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('添加制作类型'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '香丸');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();
    expect(find.text('香丸'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('shows recommendation category and SKU completion status', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    final category = await database.createIngredientCategory('木类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final sku = await database.createIngredientSku(
      ingredientId: ingredient.id,
      skuCode: 'AG-01',
    );
    final preset = await database.createRecommendationPreset(
      name: '篆香基础',
      productionTypeId: 'type-zhuanxiang',
    );
    final group = await database.createRecommendationGroup(
      presetId: preset.id,
      categoryId: category.id,
      ratio: 10000,
    );
    await database.createRecommendationItem(
      groupId: group.id,
      skuId: sku.id,
      ratio: 10000,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: RecommendationPresetDetailPage(
          database: database,
          preset: preset,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('配置已完成'), findsOneWidget);

    await tester.tap(find.text('木类'));
    await tester.pumpAndSettle();
    expect(find.text('SKU 合计 100.00%'), findsOneWidget);
    expect(find.text('AG-01'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });

  testWidgets('edits an ingredient without losing its inactive category', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    final category = await database.createIngredientCategory('木类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    await database.updateIngredientCategory(category.id, isInactive: true);
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('香料库'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('沉香的更多操作'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑'));
    await tester.pumpAndSettle();
    expect(find.text('木类（已停用）'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      (await (database.select(
        database.ingredients,
      )..where((row) => row.id.equals(ingredient.id))).getSingle()).categoryId,
      category.id,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets(
    'incomplete recommendation stays incomplete and delete confirms',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      await database.initialize();
      final category = await database.createIngredientCategory('木类');
      final preset = await database.createRecommendationPreset(
        name: '篆香基础',
        productionTypeId: 'type-zhuanxiang',
      );
      await database.createRecommendationGroup(
        presetId: preset.id,
        categoryId: category.id,
        ratio: 10000,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RecommendationPresetDetailPage(
            database: database,
            preset: preset,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('配置待完善'), findsOneWidget);
      await tester.tap(find.byTooltip('木类的更多操作'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('此操作无法从最近删除中恢复。'), findsOneWidget);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(
        await database.watchRecommendationGroups(preset.id).first,
        hasLength(1),
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await database.close();
    },
  );
}
