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

  test('one formula keeps separate ratios for each production type', () async {
    final category = await database.createIngredientCategory('木类');
    final agarwood = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final sandalwood = await database.createIngredient(
      name: '檀香',
      categoryId: category.id,
    );
    final items = [
      FormulaDraftItemInput(
        ingredientId: agarwood.id,
        categoryName: category.name,
        ingredientName: agarwood.name,
        ratio: 2000,
        sortOrder: 0,
      ),
      FormulaDraftItemInput(
        ingredientId: sandalwood.id,
        categoryName: category.name,
        ingredientName: sandalwood.name,
        ratio: 8000,
        sortOrder: 1,
      ),
    ];
    final draft = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      productionTypeIds: const ['type-zhuanxiang', 'type-xianxiang'],
      productionTypeRatios: const {
        'type-zhuanxiang': [2000, 8000],
        'type-xianxiang': [6000, 4000],
      },
      targetWeight: 1000,
      formulaName: '双用香方',
      items: items,
    );
    final session = await database.completeDraft(draft.id);
    final summary = (await database.watchFormulas().first).single;

    expect(summary.productionTypeName, '篆香、线香');
    final repeat = await database.createDraftFromVersion(
      versionId: session.versionId!,
      productionTypeId: 'type-xianxiang',
      targetWeight: 1000,
    );
    final repeatState = await database.getMixingDraft(repeat.id);
    expect(repeatState.items.map((item) => item.ratio), [6000, 4000]);
    expect(repeatState.plannedWeights, [600, 400]);
  });

  test('zero-ratio ingredients stay hidden per production type', () async {
    final category = await database.createIngredientCategory('木类');
    final agarwood = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final sandalwood = await database.createIngredient(
      name: '檀香',
      categoryId: category.id,
    );
    final composing = await database.saveComposerDraft(
      productionTypeId: 'type-zhuanxiang',
      productionTypeIds: const ['type-zhuanxiang', 'type-xianxiang'],
      productionTypeRatios: const {
        'type-zhuanxiang': [10000, 0],
        'type-xianxiang': [0, 10000],
      },
      configuredProductionTypeIds: const ['type-zhuanxiang', 'type-xianxiang'],
      targetWeightText: '1.00',
      formulaName: '零比例香方',
      notes: '',
      items: [
        FormulaDraftItemInput(
          ingredientId: agarwood.id,
          categoryName: category.name,
          ingredientName: agarwood.name,
          ratio: 10000,
          sortOrder: 0,
        ),
        FormulaDraftItemInput(
          ingredientId: sandalwood.id,
          categoryName: category.name,
          ingredientName: sandalwood.name,
          ratio: 0,
          sortOrder: 1,
        ),
      ],
    );
    final mixing = await database.startComposerDraft(composing.id);
    expect((await database.getMixingDraft(mixing.id)).items, hasLength(1));
    final session = await database.completeDraft(mixing.id);
    expect(
      (await database.getFormulaIngredientDetails(
        session.versionId!,
      )).map((item) => item.item.ingredientName),
      ['沉香'],
    );
    final repeat = await database.createDraftFromVersion(
      versionId: session.versionId!,
      productionTypeId: 'type-xianxiang',
      targetWeight: 100,
    );
    expect((await database.getMixingDraft(repeat.id)).items, hasLength(1));
    expect(
      (await database.getMixingDraft(repeat.id)).items.single.ingredientName,
      '檀香',
    );
  });

  test(
    'all mixing records can be searched by formula, customer name, or phone',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      final customer = await database.createCustomer(
        name: '林女士',
        phone: '13800138000',
      );
      final draft = await database.createFormulaDraft(
        productionTypeId: 'type-zhuanxiang',
        targetWeight: 100,
        formulaName: '晚香玉',
        customerId: customer.id,
        items: [
          FormulaDraftItemInput(
            ingredientId: ingredient.id,
            categoryName: category.name,
            ingredientName: ingredient.name,
            ratio: 10000,
            sortOrder: 0,
          ),
        ],
      );
      final session = await database.completeDraft(draft.id);

      expect(
        (await database.watchAllMixingSessions(search: '晚香玉').first),
        hasLength(1),
      );
      expect(
        (await database.watchAllMixingSessions(search: '林女士').first),
        hasLength(1),
      );
      expect(
        (await database.watchAllMixingSessions(search: '13800138000').first),
        hasLength(1),
      );
      expect(
        (await database.watchAllMixingSessions(search: '不存在').first),
        isEmpty,
      );
      await database.deleteMixingSession(session.id);
      expect(await database.watchAllMixingSessions().first, isEmpty);
      expect(
        (await (database.select(
          database.mixingSessions,
        )..where((row) => row.id.equals(session.id))).getSingle()).isDeleted,
        isTrue,
      );
    },
  );

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
      final customer = await database.createCustomer(name: '王女士');
      final draft = await database.createFormulaDraft(
        productionTypeId: 'type-zhuanxiang',
        targetWeight: 1000,
        customerId: customer.id,
        items: [
          FormulaDraftItemInput(
            ingredientId: ingredientA.id,
            categoryName: '木类',
            ingredientName: '沉香',
            ratio: 2000,
            sortOrder: 0,
          ),
          FormulaDraftItemInput(
            ingredientId: ingredientB.id,
            categoryName: '木类',
            ingredientName: '檀香',
            ratio: 8000,
            sortOrder: 1,
          ),
        ],
      );
      await database.setDraftActualWeight(draft.id, 0, 210);

      final session = await database.completeDraft(draft.id);
      final customerSearch = await database.watchFormulas(search: '王女士').first;
      expect(customerSearch.single.formula.id, session.formulaId);
      expect(customerSearch.single.customers.single.id, customer.id);
      expect(session.finalWeight, 1010);
      expect(session.formulaName, matches(RegExp(r'^王\d{6}$')));
      final formula = await (database.select(database.formulas)).getSingle();
      final version = await (database.select(
        database.formulaVersions,
      )).getSingle();
      final ingredientDetails = await database.getFormulaIngredientDetails(
        version.id,
      );
      expect(ingredientDetails.map((value) => value.item.ingredientName), [
        '沉香',
        '檀香',
      ]);
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
      const formulaImage =
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
      await database.updateFormulaImage(formula.id, formulaImage);
      expect(
        (await database.select(database.formulas).getSingle()).imageHash,
        formulaImage,
      );
      expect(await database.referencedImageHashes(), contains(formulaImage));
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
    await database.setRatioRange(
      target: RatioRangeTarget.category,
      targetId: category.id,
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
          ingredientId: ingredient.id,
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
          ingredientId: ingredient.id,
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
    'composer image and recommended protection survive completion',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      const imageHash =
          'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
      final composing = await database.saveComposerDraft(
        productionTypeId: 'type-zhuanxiang',
        targetWeightText: '1.00',
        items: [
          FormulaDraftItemInput(
            ingredientId: ingredient.id,
            categoryName: category.name,
            ingredientName: ingredient.name,
            ratio: 10000,
            sortOrder: 0,
          ),
        ],
        formulaName: '推荐沉香',
        notes: '门店展示备注',
        imageHash: imageHash,
        isRecommended: true,
      );
      expect(await database.referencedImageHashes(), contains(imageHash));
      final mixing = await database.startComposerDraft(composing.id);
      await database.setDraftActualWeight(mixing.id, 0, 100);
      await database.completeDraft(mixing.id);

      final formula = await database.select(database.formulas).getSingle();
      expect(formula.imageHash, imageHash);
      expect(formula.notes, '门店展示备注');
      expect(formula.isRecommended, isTrue);
      expect(
        (await database.watchFormulas().first).single.formula.id,
        formula.id,
      );
      expect(
        (await database.watchFormulas(recommendedOnly: true).first)
            .single
            .formula
            .id,
        formula.id,
      );
      await expectLater(database.deleteFormula(formula.id), throwsStateError);
      await database.deleteFormula(formula.id, allowRecommended: true);
      expect(
        (await (database.select(
          database.formulas,
        )..where((row) => row.id.equals(formula.id))).getSingle()).isDeleted,
        isTrue,
      );
    },
  );

  test(
    'composer drafts save incomplete input and resume into mixing',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
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
            ingredientId: ingredient.id,
            categoryName: category.name,
            ingredientName: ingredient.name,
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

  test(
    'recommended formula saves without weight customer or mixing session',
    () async {
      final category = await database.createIngredientCategory('木类');
      final ingredient = await database.createIngredient(
        name: '沉香',
        categoryId: category.id,
      );
      final draft = await database.saveComposerDraft(
        productionTypeId: 'type-zhuanxiang',
        targetWeightText: '',
        items: [
          FormulaDraftItemInput(
            ingredientId: ingredient.id,
            categoryName: category.name,
            ingredientName: ingredient.name,
            ratio: 10000,
            sortOrder: 0,
          ),
        ],
        formulaName: '无克重推荐香方',
        notes: '只保存比例',
        isRecommended: true,
      );
      final formula = await database.completeRecommendedFormulaDraft(draft.id);
      expect(formula.isRecommended, isTrue);
      expect(await database.select(database.mixingSessions).get(), isEmpty);
      final items = await database.getVersionDraftItems(
        formula.currentVersionId!,
      );
      expect(items.single.ratio, 10000);
    },
  );

  test('missing actual weights can be filled from planned weights', () async {
    final category = await database.createIngredientCategory('木类');
    final first = await database.createIngredient(
      name: '沉香',
      categoryId: category.id,
    );
    final second = await database.createIngredient(
      name: '檀香',
      categoryId: category.id,
    );
    final draft = await database.createFormulaDraft(
      productionTypeId: 'type-zhuanxiang',
      targetWeight: 1000,
      formulaName: '自动补全',
      items: [
        FormulaDraftItemInput(
          ingredientId: first.id,
          categoryName: category.name,
          ingredientName: first.name,
          ratio: 6000,
          sortOrder: 0,
        ),
        FormulaDraftItemInput(
          ingredientId: second.id,
          categoryName: category.name,
          ingredientName: second.name,
          ratio: 4000,
          sortOrder: 1,
        ),
      ],
    );
    expect(await database.fillMissingDraftWeightsFromPlan(draft.id), 2);
    expect((await database.getMixingDraft(draft.id)).actualWeights, [600, 400]);
  });

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
    await database.setRatioRange(
      target: RatioRangeTarget.ingredient,
      targetId: firstIngredient.id,
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
          ingredientId: firstIngredient.id,
          categoryName: category.name,
          ingredientName: firstIngredient.name,
          ratio: 2000,
          sortOrder: 0,
        ),
        FormulaDraftItemInput(
          ingredientId: secondIngredient.id,
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
