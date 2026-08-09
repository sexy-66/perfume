import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xiangfangbu/app.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('three ingredient draft, warning and 10.10g completion', (
    tester,
  ) async {
    final database = AppDatabase.defaults();
    await database.initialize();
    addTearDown(database.close);
    final category = await database.createIngredientCategory('wood');
    final ingredients = <Ingredient>[];
    for (final code in ['A', 'B', 'C']) {
      ingredients.add(
        await database.createIngredient(
          name: 'powder $code',
          categoryId: category.id,
        ),
      );
    }
    await database.setRatioRange(
      target: RatioRangeTarget.ingredient,
      targetId: ingredients.first.id,
      productionTypeId: 'type-zhuanxiang',
      minRatio: 1000,
      maxRatio: 2000,
    );
    final mediaDirectory = await Directory.systemTemp.createTemp('m3-flow-');
    addTearDown(() => mediaDirectory.delete(recursive: true));

    await tester.pumpWidget(
      XiangApp(database: database, mediaStore: MediaStore(mediaDirectory)),
    );
    await tester.pumpAndSettle();
    // M4 starts formula creation from the home "香方" card, then the
    // formula list's empty-state action.
    await tester.tap(find.text('香方').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, '新建香方'));
    await tester.pumpAndSettle();
    for (final code in ['A', 'B', 'C']) {
      await tester.tap(find.text('powder $code'));
    }
    await tester.pump();
    expect(find.text('选择香料（3）'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, '完成'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('formula-name')),
      -300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.enterText(find.byKey(const ValueKey('formula-name')), 'Multi');
    await tester.ensureVisible(
      find.byKey(const ValueKey('formula-target-weight')),
    );
    await tester.enterText(
      find.byKey(const ValueKey('formula-target-weight')),
      '10',
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('香方').last);
    await tester.pumpAndSettle();
    final draftTile = find.widgetWithText(ListTile, 'Multi');
    expect(draftTile, findsOneWidget);
    await tester.tap(draftTile);
    await tester.pumpAndSettle();
    expect(find.text('继续编辑香方'), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      final editor = find.byKey(ValueKey(ingredients[i].id));
      await tester.ensureVisible(editor);
      await tester.enterText(
        find.descendant(of: editor, matching: find.byType(TextFormField)),
        ['20', '60', '20'][i],
      );
    }
    await tester.tap(find.widgetWithText(FilledButton, '进入调配'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '2.10');
    await tester.pump(const Duration(milliseconds: 700));
    await tester.tap(find.widgetWithText(FilledButton, '完成调配'));
    await tester.pumpAndSettle();
    expect(find.text('有香料尚未填写克重'), findsOneWidget);
    expect(find.textContaining('共有 2 味'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '按计划克重填入'));
    await tester.pumpAndSettle();
    expect(find.text('比例超出推荐区间'), findsOneWidget);
    expect(find.text('powder A：20.79%（推荐 10.00%–20.00%）'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '继续使用'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('10.10g · 目标 10.00g'), findsOneWidget);
    expect(find.text('顾客'), findsOneWidget);
    expect(find.text('未关联顾客'), findsOneWidget);
    expect(find.text('调配时间'), findsOneWidget);
    expect(find.textContaining('20.79%'), findsOneWidget);
    expect(find.textContaining('59.41%'), findsOneWidget);
    expect(find.textContaining('19.80%'), findsOneWidget);
    expect(find.textContaining('系统补全'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
