import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/app.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';
import 'package:xiangfangbu/features/recommendations/recommendation_preset_detail_page.dart';
import 'package:xiangfangbu/services/peer_handshake.dart';
import 'package:xiangfangbu/services/peer_sync_runtime.dart';

void main() {
  testWidgets('sync services stop in background and resume in foreground', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    final runtime = _RecordingPeerSyncRuntime(
      await PeerIdentity.create(
        deviceId: 'lifecycle-device',
        deviceName: '生命周期设备',
      ),
    );
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(
        database: database,
        mediaStore: MediaStore(mediaDirectory),
        syncRuntime: runtime,
      ),
    );
    await tester.pump();
    expect(runtime.startCalls, 1);
    expect(runtime.syncCalls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(runtime.stopCalls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(runtime.startCalls, 2);
    expect(runtime.syncCalls, 2);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await runtime.close();
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('sync entry retries initialization without duplicate pages', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    final runtime = _RecordingPeerSyncRuntime(
      await PeerIdentity.create(
        deviceId: 'sync-entry-device',
        deviceName: '同步入口设备',
      ),
    );
    final retry = Completer<PeerSyncRuntime>();
    var loaderCalls = 0;
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(
        database: database,
        mediaStore: MediaStore(mediaDirectory),
        syncRuntimeLoader: () async {
          loaderCalls++;
          if (loaderCalls == 1) throw StateError('首次初始化失败');
          return retry.future;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('更多'));
    await tester.pump();
    final syncTile = find.widgetWithText(ListTile, '同步与设备');
    expect(
      find.descendant(of: syncTile, matching: find.text('初始化失败，点按重试')),
      findsOneWidget,
    );
    final tile = tester.widget<ListTile>(syncTile);
    tile.onTap!();
    tile.onTap!();
    tile.onTap!();
    await tester.pump();
    expect(loaderCalls, 2);

    retry.complete(runtime);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, '同步与设备'), findsOneWidget);
    expect(find.text('同步入口设备'), findsOneWidget);
    expect(loaderCalls, 2);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('product entry selects plaque before formula', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    final mediaStore = MediaStore(mediaDirectory);
    await database.initialize();
    await database.createPlaqueType(name: '圆牌');
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: mediaStore),
    );

    await tester.tap(find.text('合香珠 / 香牌'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('选择成品'), findsOneWidget);
    expect(find.text('作为同一种成品统一选择'), findsOneWidget);
    expect(find.text('圆牌'), findsOneWidget);
    await tester.tap(find.text('圆牌'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('为「圆牌」选择香方'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '新建香方'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '新建香方'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('新建香方'), findsWidgets);
    expect(find.text('香牌（可选）'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

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

    expect(find.text('首页'), findsWidgets);
    expect(find.text('香方'), findsWidgets);
    expect(find.text('更多'), findsOneWidget);

    await tester.tap(find.text('更多'));
    await tester.pump();
    for (final item in const [
      '香料库',
      '合香珠 / 香牌目录',
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
    expect(find.widgetWithText(SearchBar, '搜索名称、别名或分类'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.text('添加第一项'), findsOneWidget);
    expect(find.byTooltip('管理分类'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('root back shows a lightweight double-back exit hint', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('再按一次退出香方簿'), findsOneWidget);
    expect(find.text('退出香方簿？'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('再按一次退出香方簿'), findsNothing);

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
    expect(find.byTooltip('添加香料'), findsNWidgets(2));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('添加香料'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('新建大类'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '沉香');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(find.text('沉香'), findsOneWidget);
    expect(find.byIcon(Icons.spa_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('沉香'));
    await tester.pumpAndSettle();
    expect(find.text('编辑香料'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, '推荐区间'));
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
    await tester.tap(find.text('合香珠 / 香牌目录'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('添加合香珠 / 香牌'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '如意牌');
    await tester.enterText(find.byType(TextField).at(1), '6 × 3 cm');
    await tester.tap(find.widgetWithText(TextButton, '保存'));
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
    final database = _DelayedAssetDatabase();
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
    final addFirstAsset = find.widgetWithText(FilledButton, '添加第一项资产');
    final addFirstAssetButton = tester.widget<FilledButton>(addFirstAsset);
    addFirstAssetButton.onPressed!();
    addFirstAssetButton.onPressed!();
    addFirstAssetButton.onPressed!();
    await tester.pump();
    expect(database.categoryQueries, 1);
    database.releaseCategoryQuery.complete();
    await tester.pumpAndSettle();
    expect(database.statusQueries, 1);
    expect(find.text('添加资产'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '压香器');
    await tester.enterText(find.byType(TextFormField).at(1), '2');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(find.text('添加资产'), findsNothing);
    expect(find.text('压香器 × 2'), findsOneWidget);
    expect(find.text('工具'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('ingredient long press supports batch delete and disable', (
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
    for (final name in ['沉香', '檀香', '乳香']) {
      await database.createIngredient(name: name, categoryId: category.id);
    }
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.tap(find.text('香料库'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('沉香'));
    await tester.pump();
    await tester.tap(find.text('檀香'));
    await tester.pump();
    expect(find.text('已选 2 项'), findsOneWidget);
    await tester.tap(find.byTooltip('删除所选香料'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '确认删除'));
    await tester.pumpAndSettle();
    expect(find.text('沉香'), findsNothing);
    expect(find.text('檀香'), findsNothing);
    expect(find.text('乳香'), findsOneWidget);

    await tester.longPress(find.text('乳香'));
    await tester.pump();
    await tester.tap(find.byTooltip('停用所选香料'));
    await tester.pumpAndSettle();
    expect(find.text('乳香'), findsNothing);
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

  testWidgets(
    'shows recommendation category and ingredient completion status',
    (tester) async {
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
        ingredientId: ingredient.id,
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
      expect(find.text('香料合计 100.00%'), findsOneWidget);
      expect(find.text('沉香'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await database.close();
    },
  );

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
    await tester.tap(find.text('沉香'));
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

  testWidgets('unnamed composer draft can be discarded', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    final draft = await database.saveComposerDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeightText: '',
      items: const [],
      formulaName: '',
      notes: '',
    );
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('配制、计算与记录'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.widgetWithText(ListTile, '未命名草稿'));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('已保存'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, '放弃'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.widgetWithText(FilledButton, '放弃草稿'));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      (await (database.select(
        database.formulaDrafts,
      )..where((row) => row.id.equals(draft.id))).getSingle()).isDeleted,
      isTrue,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('formula delete can be undone from feedback', (tester) async {
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
    final draft = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeight: 100,
      formulaName: '可撤销香方',
      items: [
        FormulaDraftItemInput(
          ingredientId: ingredient.id,
          categoryName: '木类',
          ingredientName: '沉香',
          ratio: 10000,
          sortOrder: 0,
        ),
      ],
    );
    await database.completeDraft(draft.id);
    final formula = (await database.watchFormulas().first).single.formula;

    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('可撤销香方'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byTooltip('更多操作'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除香方'));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('已移入最近删除'), findsOneWidget);
    await tester.tap(find.text('撤销'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    expect(
      (await (database.select(
        database.formulas,
      )..where((row) => row.id.equals(formula.id))).getSingle()).isDeleted,
      isFalse,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });

  testWidgets('core destinations fit phone and tablet orientations', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final semantics = tester.ensureSemantics();
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = Directory.systemTemp.createTempSync('xiang-ui-');
    await database.initialize();
    final category = await database.createIngredientCategory('木类');
    await database.createIngredient(name: '沉香', categoryId: category.id);
    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );
    expect(find.bySemanticsLabel('首页'), findsOneWidget);
    expect(find.bySemanticsLabel('首页 首页'), findsNothing);

    for (final size in const [
      Size(360, 640),
      Size(640, 360),
      Size(800, 1280),
      Size(1280, 800),
    ]) {
      tester.view.physicalSize = size;
      await tester.pump();
      await tester.tap(find.text('首页').last);
      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.takeException(), isNull, reason: '首页 $size');

      await tester.tap(find.text('香料').last);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('沉香'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '香料库 $size');

      await tester.tap(find.text('更多').last);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('香料库'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '更多 $size');
    }

    semantics.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
    mediaDirectory.deleteSync(recursive: true);
  });
}

class _RecordingPeerSyncRuntime extends PeerSyncRuntime {
  _RecordingPeerSyncRuntime(PeerIdentity identity)
    : super(identity: identity, groupId: 'store-1');

  int startCalls = 0;
  int stopCalls = 0;
  int syncCalls = 0;

  @override
  Future<void> start() async => startCalls++;

  @override
  Future<void> stop() async => stopCalls++;

  @override
  Future<void> syncAll() async => syncCalls++;
}

class _DelayedAssetDatabase extends AppDatabase {
  _DelayedAssetDatabase() : super(NativeDatabase.memory());

  final releaseCategoryQuery = Completer<void>();
  var categoryQueries = 0;
  var statusQueries = 0;

  @override
  Future<List<AssetCategory>> getActiveAssetCategories({
    String? includeId,
  }) async {
    categoryQueries++;
    await releaseCategoryQuery.future;
    return super.getActiveAssetCategories(includeId: includeId);
  }

  @override
  Future<List<AssetStatuse>> getActiveAssetStatuses({String? includeId}) async {
    statusQueries++;
    return super.getActiveAssetStatuses(includeId: includeId);
  }
}
