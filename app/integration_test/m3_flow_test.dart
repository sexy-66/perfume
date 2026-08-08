import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xiangfangbu/app.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'three ingredient draft, immediate warning and 10.10g completion',
    (tester) async {
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
      await tester.enterText(find.byType(TextField).at(0), 'Multi');
      await tester.enterText(find.byType(TextField).at(1), '10');
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

      for (final ratio in ['20', '60', '20']) {
        await tester.tap(find.byTooltip('添加香料'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).last, ratio);
        await tester.tap(find.widgetWithText(FilledButton, '添加'));
        await tester.pumpAndSettle();
      }
      expect(find.text('100.00%'), findsWidgets);
      await tester.tap(find.widgetWithText(FilledButton, '进入调配'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '2.10');
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
      expect(find.text('比例超出推荐区间'), findsOneWidget);
      expect(find.text('powder A：20.79%（推荐 10.00%–20.00%）'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, '继续使用'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '完成调配'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('最终总重 10.10g'), findsOneWidget);
      expect(find.textContaining('20.79%'), findsOneWidget);
      expect(find.textContaining('59.41%'), findsOneWidget);
      expect(find.textContaining('19.80%'), findsOneWidget);
      expect(find.text('系统补全'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    },
  );
}
