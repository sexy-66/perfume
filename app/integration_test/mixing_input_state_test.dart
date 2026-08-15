import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';
import 'package:xiangfangbu/features/formulas/formulas_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mixing input survives scroll and saves on immediate back', (
    tester,
  ) async {
    final database = AppDatabase.defaults();
    final mediaDirectory = await Directory.systemTemp.createTemp(
      'mixing-input-state-',
    );
    addTearDown(() async {
      await database.close();
      await mediaDirectory.delete(recursive: true);
    });
    await database.initialize();
    final category = await database.createIngredientCategory('滚动测试');
    final ingredients = <Ingredient>[];
    for (var i = 0; i < 8; i++) {
      ingredients.add(
        await database.createIngredient(
          name: '滚动香料 ${i + 1}',
          categoryId: category.id,
        ),
      );
    }
    final draft = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeight: 800,
      formulaName: '滚动状态验证',
      items: [
        for (var i = 0; i < ingredients.length; i++)
          FormulaDraftItemInput(
            ingredientId: ingredients[i].id,
            categoryName: category.name,
            ingredientName: ingredients[i].name,
            ratio: 1250,
            sortOrder: i,
          ),
      ],
    );
    final mediaStore = MediaStore(mediaDirectory);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => MixingPage(
                    database: database,
                    mediaStore: mediaStore,
                    draftId: draft.id,
                  ),
                ),
              ),
              child: const Text('开始验证'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('开始验证'));
    await tester.pumpAndSettle();

    final firstField = find.byKey(ValueKey('${draft.id}-0'));
    final secondField = find.byKey(ValueKey('${draft.id}-1'));
    await tester.enterText(firstField, '12.34');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: secondField,
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(ValueKey('${draft.id}-7')),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      firstField,
      -500,
      scrollable: find.byType(Scrollable).first,
    );

    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: firstField,
              matching: find.byType(EditableText),
            ),
          )
          .controller
          .text,
      '12.34',
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect((await database.getMixingDraft(draft.id)).actualWeights.first, 1234);
    expect(tester.takeException(), isNull);
  });
}
