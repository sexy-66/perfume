import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
  });

  tearDown(() => database.close());

  test(
    'new mix creates final formula, snapshots and customer history',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredientA = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      final ingredientB = await database.createIngredient(
        name: '檀香',
        categoryId: category.id,
      );
      final skuA = await database.createIngredientSku(
        ingredientId: ingredientA.id,
        skuCode: 'A',
      );
      final skuB = await database.createIngredientSku(
        ingredientId: ingredientB.id,
        skuCode: 'B',
      );
      final customer = await database.createCustomer(name: '王女士');
      final draft = await database.createFormulaDraft(
        productionTypeId: 'type-zhuanxiang',
        targetWeight: 1000,
        customerId: customer.id,
        items: [
          FormulaDraftItemInput(
            skuId: skuA.id,
            categoryName: '木类',
            ingredientName: '沉香',
            skuCode: 'A',
            ratio: 2000,
            sortOrder: 0,
          ),
          FormulaDraftItemInput(
            skuId: skuB.id,
            categoryName: '木类',
            ingredientName: '檀香',
            skuCode: 'B',
            ratio: 8000,
            sortOrder: 1,
          ),
        ],
      );
      await database.setDraftActualWeight(draft.id, 0, 210);

      final session = await database.completeDraft(draft.id);
      expect(session.finalWeight, 1010);
      expect(session.formulaName, matches(RegExp(r'^王\d{6}$')));
      final formula = await (database.select(database.formulas)).getSingle();
      final version = await (database.select(
        database.formulaVersions,
      )).getSingle();
      final formulaItems = await database.select(database.formulaItems).get();
      final mixingItems = await database.select(database.mixingItems).get();
      expect(formula.currentVersionId, version.id);
      expect(formulaItems.map((item) => item.ratio), [2079, 7921]);
      expect(mixingItems.map((item) => item.isManual), [true, false]);
      expect(
        (await database.watchCustomerFormulaHistory(customer.id).first)
            .single
            .useCount,
        1,
      );

      await database.reviseMixingSession(session.id, [220, 800]);
      expect(await database.getMixingRevisions(session.id), hasLength(1));
      expect(
        (await (database.select(
          database.mixingSessions,
        )..where((row) => row.id.equals(session.id))).getSingle()).finalWeight,
        1020,
      );

      final lastUsed = await database.createDraftFromLastCustomerSession(
        customerId: customer.id,
        formulaId: formula.id,
        targetWeight: 500,
      );
      expect(
        (await database.getMixingDraft(
          lastUsed.id,
        )).items.map((item) => item.ratio),
        [2157, 7843],
      );
      await database.completeDraft(lastUsed.id);

      final plaque = await database.createPlaqueType(name: '圆牌');
      final repeat = await database.createDraftFromVersion(
        versionId: version.id,
        targetWeight: 500,
        customerId: customer.id,
        plaqueTypeId: plaque.id,
      );
      expect(repeat.plaqueTypeId, plaque.id);
      await database.completeDraft(repeat.id);
      expect(
        await database.select(database.formulaVersions).get(),
        hasLength(1),
      );
      expect(
        (await database.watchCustomerFormulaHistory(customer.id).first)
            .single
            .useCount,
        3,
      );

      final other = await database.createCustomer(phone: '10086');
      final copy = await database.copyMixingSessionToCustomer(
        session.id,
        other.id,
      );
      expect(
        (await database.watchCustomerFormulaHistory(other.id).first)
            .single
            .useCount,
        1,
      );
      await database.updateFormula(formula.id, name: '改名香方', notes: '备注');
      expect(
        await database.select(database.formulaVersions).get(),
        hasLength(1),
      );
      await database.deleteFormula(formula.id);
      final deletedFormula = (await database.watchTrash().first).singleWhere(
        (item) => item.type == TrashEntityType.formula,
      );
      await database.restoreTrashEntry(deletedFormula);
      expect(
        (await database.watchFormulas().first).single.formula.name,
        '改名香方',
      );

      await database.deleteCustomer(other.id);
      expect(
        (await (database.select(
          database.mixingSessions,
        )..where((row) => row.id.equals(copy.id))).getSingle()).customerId,
        isNull,
      );
      await database.deleteCustomer(customer.id, deleteSessions: true);
      expect(
        await (database.select(database.mixingSessions)..where(
              (row) =>
                  row.customerId.equals(customer.id) &
                  row.isDeleted.equals(false),
            ))
            .get(),
        isEmpty,
      );
    },
  );

  test('range warning must be confirmed once before completion', () async {
    final category = await database.createIngredientCategory('木类');
    final ingredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final sku = await database.createIngredientSku(ingredientId: ingredient.id);
    await database.setRatioRange(
      target: RatioRangeTarget.sku,
      targetId: sku.id,
      productionTypeId: 'type-zhuanxiang',
      minRatio: 1000,
      maxRatio: 2000,
    );
    final draft = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeight: 100,
      formulaName: '通用香方',
      items: [
        FormulaDraftItemInput(
          skuId: sku.id,
          categoryName: '木类',
          ingredientName: '沉香',
          ratio: 10000,
          sortOrder: 0,
        ),
      ],
    );
    final warnings = await database.getDraftRangeWarnings(draft.id);
    expect(warnings, hasLength(1));
    await expectLater(database.completeDraft(draft.id), throwsStateError);
    await database.confirmDraftWarnings(
      draft.id,
      warnings.map((item) => item.key),
    );
    expect((await database.completeDraft(draft.id)).formulaName, '通用香方');

    final disposable = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeight: 100,
      formulaName: '待删草稿',
      items: [
        FormulaDraftItemInput(
          skuId: sku.id,
          categoryName: '木类',
          ingredientName: '沉香',
          ratio: 10000,
          sortOrder: 0,
        ),
      ],
    );
    await database.deleteFormulaDraft(disposable.id);
    expect(await database.watchOpenDrafts().first, isEmpty);
  });

  test(
    'composer drafts save incomplete input and resume into mixing',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      final sku = await database.createIngredientSku(
        ingredientId: ingredient.id,
        skuCode: 'A',
      );
      var draft = await database.saveComposerDraft(
        productionTypeId: 'type-zhuanxiang',
        targetWeightText: '',
        items: const [],
        formulaName: '未完成',
        notes: '',
      );
      var saved = await database.getComposerDraft(draft.id);
      expect(saved.targetWeightText, '');
      expect(saved.items, isEmpty);

      draft = await database.saveComposerDraft(
        draftId: draft.id,
        productionTypeId: 'type-zhuanxiang',
        targetWeightText: '10.00',
        formulaName: '恢复草稿',
        notes: '自动保存',
        items: [
          FormulaDraftItemInput(
            skuId: sku.id,
            categoryName: category.name,
            ingredientName: ingredient.name,
            skuCode: sku.skuCode,
            ratio: 10000,
            sortOrder: 0,
          ),
        ],
      );
      saved = await database.getComposerDraft(draft.id);
      expect(
        (saved.draft.formulaName, saved.targetWeightText),
        ('恢复草稿', '10.00'),
      );
      final mixing = await database.startComposerDraft(draft.id);
      expect((mixing.kind, mixing.targetWeight), ('new', 1000));
      expect((await database.getMixingDraft(draft.id)).plannedWeights, [1000]);
    },
  );

  test('confirmed exceedance stays quiet until it clears and recurs', () async {
    final category = await database.createIngredientCategory('木类');
    final firstIngredient = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final secondIngredient = await database.createIngredient(
      name: '檀香',
      categoryId: category.id,
    );
    final first = await database.createIngredientSku(
      ingredientId: firstIngredient.id,
    );
    final second = await database.createIngredientSku(
      ingredientId: secondIngredient.id,
    );
    await database.setRatioRange(
      target: RatioRangeTarget.sku,
      targetId: first.id,
      productionTypeId: 'type-zhuanxiang',
      minRatio: 1000,
      maxRatio: 2000,
    );
    final draft = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeight: 1000,
      formulaName: '提醒测试',
      items: [
        FormulaDraftItemInput(
          skuId: first.id,
          categoryName: category.name,
          ingredientName: firstIngredient.name,
          ratio: 2000,
          sortOrder: 0,
        ),
        FormulaDraftItemInput(
          skuId: second.id,
          categoryName: category.name,
          ingredientName: secondIngredient.name,
          ratio: 8000,
          sortOrder: 1,
        ),
      ],
    );
    await database.setDraftActualWeight(draft.id, 0, 300);
    var warnings = await database.getDraftRangeWarnings(draft.id);
    expect(warnings, hasLength(1));
    await database.confirmDraftWarnings(
      draft.id,
      warnings.map((item) => item.key),
    );

    await database.setDraftActualWeight(draft.id, 0, 400);
    expect(await database.getDraftRangeWarnings(draft.id), isEmpty);
    await database.setDraftActualWeight(draft.id, 0, 100);
    expect(await database.getDraftRangeWarnings(draft.id), isEmpty);
    await database.setDraftActualWeight(draft.id, 0, 300);
    warnings = await database.getDraftRangeWarnings(draft.id);
    expect(warnings, hasLength(1));
  });
}
