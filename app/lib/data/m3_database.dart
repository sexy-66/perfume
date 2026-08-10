part of 'app_database.dart';

class FormulaDraftItemInput {
  const FormulaDraftItemInput({
    required this.ingredientId,
    required this.categoryName,
    required this.ingredientName,
    required this.ratio,
    required this.sortOrder,
  });

  final String ingredientId;
  final String categoryName;
  final String ingredientName;
  final int ratio;
  final int sortOrder;

  Map<String, Object?> toJson() => {
    'ingredientId': ingredientId,
    'categoryName': categoryName,
    'ingredientName': ingredientName,
    'ratio': ratio,
    'sortOrder': sortOrder,
  };

  factory FormulaDraftItemInput.fromJson(Map<String, Object?> json) =>
      FormulaDraftItemInput(
        ingredientId: json['ingredientId']! as String,
        categoryName: json['categoryName']! as String,
        ingredientName: json['ingredientName']! as String,
        ratio: json['ratio']! as int,
        sortOrder: json['sortOrder']! as int,
      );

  String get label => ingredientName;
}

class FormulaIngredientChoice {
  const FormulaIngredientChoice({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.ingredientName,
    required this.categorySortOrder,
    this.imageHash,
  });

  final String id;
  final String categoryId;
  final String categoryName;
  final String ingredientName;
  final int categorySortOrder;
  final String? imageHash;
  String get label => ingredientName;
}

class FormulaSummary {
  const FormulaSummary({
    required this.formula,
    required this.productionTypes,
    required this.topIngredients,
    this.customers = const [],
  });

  final Formula formula;
  final List<ProductionType> productionTypes;
  String get productionTypeName =>
      productionTypes.map((type) => type.name).join('、');
  final String topIngredients;
  final List<Customer> customers;
}

class FormulaIngredientSummary {
  const FormulaIngredientSummary({required this.item, this.imageHash});

  final FormulaItem item;
  final String? imageHash;
}

List<String> formulaVersionProductionTypeIds(FormulaVersion version) =>
    _productionTypeIds(version.productionTypeIdsJson, version.productionTypeId);

List<String> formulaDraftProductionTypeIds(FormulaDraft draft) =>
    _productionTypeIds(draft.productionTypeIdsJson, draft.productionTypeId);

Map<String, List<int>> formulaVersionProductionTypeRatios(
  FormulaVersion version,
) => _productionTypeRatios(version.productionTypeRatiosJson);

Map<String, List<int>> formulaDraftProductionTypeRatios(FormulaDraft draft) =>
    _productionTypeRatios(draft.productionTypeRatiosJson);

Map<String, List<int>> _productionTypeRatios(String json) {
  try {
    return (jsonDecode(json) as Map<String, Object?>).map(
      (id, ratios) => MapEntry(id, (ratios as List<Object?>).cast<int>()),
    );
  } on Object {
    return {};
  }
}

List<String> _productionTypeIds(String json, String fallbackId) {
  try {
    final ids = (jsonDecode(json) as List<Object?>)
        .whereType<String>()
        .toList();
    if (ids.isNotEmpty) return ids;
  } on FormatException {
    // Older or remotely supplied data falls back to the legacy single type.
  }
  return [fallbackId];
}

class FormulaVersionSummary {
  const FormulaVersionSummary(this.version, this.items);

  final FormulaVersion version;
  final List<FormulaItem> items;
}

class MixingDraftState {
  const MixingDraftState({
    required this.draft,
    required this.items,
    required this.plannedWeights,
    required this.actualWeights,
    required this.projectedWeights,
    required this.projectedRatios,
  });

  final FormulaDraft draft;
  final List<FormulaDraftItemInput> items;
  final List<int> plannedWeights;
  final List<int?> actualWeights;
  final List<int> projectedWeights;
  final List<int> projectedRatios;
}

class ComposerDraftState {
  const ComposerDraftState({
    required this.draft,
    required this.targetWeightText,
    required this.items,
    required this.configuredProductionTypeIds,
  });

  final FormulaDraft draft;
  final String targetWeightText;
  final List<FormulaDraftItemInput> items;
  final List<String> configuredProductionTypeIds;
}

class CustomerFormulaHistory {
  const CustomerFormulaHistory({
    required this.formulaId,
    required this.formulaName,
    required this.lastUsedAtUtc,
    required this.useCount,
  });

  final String formulaId;
  final String formulaName;
  final DateTime lastUsedAtUtc;
  final int useCount;
}

class MixingSessionSummary {
  const MixingSessionSummary({
    required this.session,
    this.customer,
    this.formulaImageHash,
  });

  final MixingSession session;
  final Customer? customer;
  final String? formulaImageHash;
}

extension M3Database on AppDatabase {
  Future<FormulaDraft> saveComposerDraft({
    String? draftId,
    required String productionTypeId,
    List<String>? productionTypeIds,
    Map<String, List<int>>? productionTypeRatios,
    List<String>? configuredProductionTypeIds,
    required String targetWeightText,
    required List<FormulaDraftItemInput> items,
    required String formulaName,
    required String notes,
    String? imageHash,
    bool isRecommended = false,
    String? customerId,
    String? plaqueTypeId,
    String? formulaId,
    String? sourceVersionId,
  }) => transaction(() async {
    final typeIds = productionTypeIds ?? [productionTypeId];
    final ratiosByType =
        productionTypeRatios ??
        {
          productionTypeId: [for (final item in items) item.ratio],
        };
    final configuredTypeIds = configuredProductionTypeIds ?? [productionTypeId];
    await _validateProductionTypes(productionTypeId, typeIds);
    if (customerId != null) await _activeCustomer(customerId);
    if (plaqueTypeId != null) await _activePlaque(plaqueTypeId);
    final payload = jsonEncode({
      'targetWeightText': targetWeightText,
      'items': [for (final item in items) item.toJson()],
      'configuredProductionTypeIds': configuredTypeIds,
    });
    var placeholderWeight = 1;
    try {
      final parsed = parseWeight(targetWeightText);
      if (parsed > 0) placeholderWeight = parsed;
    } on FormatException {
      // Incomplete input is valid while composing.
    }
    if (draftId == null) {
      final id = _newId();
      final change = await _recordOperation(
        entityType: 'formula_drafts',
        entityId: id,
        operationKind: 'create',
        payload: {'id': id, 'kind': 'composing'},
      );
      await into(formulaDrafts).insert(
        FormulaDraftsCompanion.insert(
          id: id,
          revisionId: change.revisionId,
          updatedByDevice: change.deviceId,
          updatedAtUtc: change.now,
          kind: formulaId == null ? 'composing-new' : 'composing-adjust',
          formulaId: Value(formulaId),
          sourceVersionId: Value(sourceVersionId),
          customerId: Value(customerId),
          plaqueTypeId: Value(plaqueTypeId),
          formulaName: Value(formulaName.trim()),
          imageHash: Value(_optionalImageHash(imageHash)),
          isRecommended: Value(isRecommended),
          productionTypeId: productionTypeId,
          productionTypeIdsJson: Value(jsonEncode(typeIds)),
          productionTypeRatiosJson: Value(jsonEncode(ratiosByType)),
          targetWeight: placeholderWeight,
          notes: Value(_optionalText(notes)),
          itemsJson: payload,
          actualWeightsJson: '[]',
          createdAtUtc: change.now,
        ),
      );
      return (select(
        formulaDrafts,
      )..where((row) => row.id.equals(id))).getSingle();
    }
    final current = await (select(
      formulaDrafts,
    )..where((row) => row.id.equals(draftId))).getSingle();
    if (current.isDeleted) throw StateError('草稿已删除');
    final change = await _recordOperation(
      entityType: 'formula_drafts',
      entityId: draftId,
      baseRevisionId: current.revisionId,
      operationKind: 'update',
      payload: {'id': draftId, 'kind': 'composing'},
    );
    await (update(formulaDrafts)..where((row) => row.id.equals(draftId))).write(
      FormulaDraftsCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        customerId: Value(customerId),
        plaqueTypeId: Value(plaqueTypeId),
        formulaName: Value(formulaName.trim()),
        imageHash: Value(_optionalImageHash(imageHash)),
        isRecommended: Value(isRecommended),
        productionTypeId: Value(productionTypeId),
        productionTypeIdsJson: Value(jsonEncode(typeIds)),
        productionTypeRatiosJson: Value(jsonEncode(ratiosByType)),
        targetWeight: Value(placeholderWeight),
        notes: Value(_optionalText(notes)),
        itemsJson: Value(payload),
      ),
    );
    return (select(
      formulaDrafts,
    )..where((row) => row.id.equals(draftId))).getSingle();
  });

  Future<ComposerDraftState> getComposerDraft(String id) async {
    final draft = await (select(
      formulaDrafts,
    )..where((row) => row.id.equals(id))).getSingle();
    if (draft.isDeleted || !draft.kind.startsWith('composing-')) {
      throw StateError('该草稿不在编辑阶段');
    }
    final value = (jsonDecode(draft.itemsJson) as Map).cast<String, Object?>();
    return ComposerDraftState(
      draft: draft,
      targetWeightText: value['targetWeightText']! as String,
      items: (value['items']! as List<Object?>)
          .map(
            (item) => FormulaDraftItemInput.fromJson(
              (item! as Map).cast<String, Object?>(),
            ),
          )
          .toList(),
      configuredProductionTypeIds:
          (value['configuredProductionTypeIds'] as List<Object?>?)
              ?.whereType<String>()
              .toList() ??
          [draft.productionTypeId],
    );
  }

  Future<FormulaDraft> startComposerDraft(String id) => transaction(() async {
    final state = await getComposerDraft(id);
    final weight = parseWeight(state.targetWeightText);
    if (weight <= 0) throw ArgumentError('目标总重必须大于 0');
    _validateDraftItems(state.items);
    final typeIds = formulaDraftProductionTypeIds(state.draft);
    if (!state.configuredProductionTypeIds.toSet().containsAll(typeIds)) {
      throw StateError('请先完成全部制作类型的比例配置');
    }
    _validateProductionTypeRatios(
      typeIds,
      state.items.length,
      formulaDraftProductionTypeRatios(state.draft),
    );
    for (final item in state.items) {
      await _validateDraftIngredient(item.ingredientId);
    }
    final change = await _recordOperation(
      entityType: 'formula_drafts',
      entityId: id,
      baseRevisionId: state.draft.revisionId,
      operationKind: 'update',
      payload: {'id': id, 'kind': 'mixing'},
    );
    await (update(formulaDrafts)..where((row) => row.id.equals(id))).write(
      FormulaDraftsCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        kind: Value(state.draft.formulaId == null ? 'new' : 'adjust'),
        targetWeight: Value(weight),
        itemsJson: Value(
          jsonEncode([for (final item in state.items) item.toJson()]),
        ),
        actualWeightsJson: Value(
          jsonEncode(List<Object?>.filled(state.items.length, null)),
        ),
      ),
    );
    return (select(
      formulaDrafts,
    )..where((row) => row.id.equals(id))).getSingle();
  });

  Future<Formula> completeRecommendedFormulaDraft(String id) => transaction(
    () async {
      final state = await getComposerDraft(id);
      if (!state.draft.isRecommended) throw StateError('该草稿不是推荐香方');
      final name = _requiredName(state.draft.formulaName, '香方名称不能为空');
      _validateDraftItems(state.items);
      final typeIds = formulaDraftProductionTypeIds(state.draft);
      _validateProductionTypeRatios(
        typeIds,
        state.items.length,
        formulaDraftProductionTypeRatios(state.draft),
      );
      for (final item in state.items) {
        await _validateDraftIngredient(item.ingredientId);
      }
      final formulaId = _newId();
      final formulaChange = await _recordOperation(
        entityType: 'formulas',
        entityId: formulaId,
        operationKind: 'create',
        payload: {'id': formulaId, 'name': name, 'isRecommended': true},
      );
      await into(formulas).insert(
        FormulasCompanion.insert(
          id: formulaId,
          revisionId: formulaChange.revisionId,
          updatedByDevice: formulaChange.deviceId,
          updatedAtUtc: formulaChange.now,
          name: name,
          imageHash: Value(state.draft.imageHash),
          notes: Value(state.draft.notes),
          isRecommended: const Value(true),
        ),
      );
      final versionId = _newId();
      final versionChange = await _recordOperation(
        entityType: 'formula_versions',
        entityId: versionId,
        operationKind: 'create',
        payload: {'id': versionId, 'formulaId': formulaId},
      );
      await into(formulaVersions).insert(
        FormulaVersionsCompanion.insert(
          id: versionId,
          revisionId: versionChange.revisionId,
          updatedByDevice: versionChange.deviceId,
          updatedAtUtc: versionChange.now,
          formulaId: formulaId,
          versionNumber: 1,
          productionTypeId: state.draft.productionTypeId,
          productionTypeIdsJson: Value(state.draft.productionTypeIdsJson),
          productionTypeRatiosJson: Value(state.draft.productionTypeRatiosJson),
          createdAtUtc: versionChange.now,
        ),
      );
      for (final item in state.items) {
        await _insertFormulaItem(versionId, item, item.ratio);
      }
      final formula = await (select(
        formulas,
      )..where((row) => row.id.equals(formulaId))).getSingle();
      final updateChange = await _recordOperation(
        entityType: 'formulas',
        entityId: formulaId,
        baseRevisionId: formula.revisionId,
        operationKind: 'update',
        payload: {'id': formulaId, 'currentVersionId': versionId},
      );
      await (update(formulas)..where((row) => row.id.equals(formulaId))).write(
        FormulasCompanion(
          revisionId: Value(updateChange.revisionId),
          updatedByDevice: Value(updateChange.deviceId),
          updatedAtUtc: Value(updateChange.now),
          currentVersionId: Value(versionId),
        ),
      );
      await deleteFormulaDraft(id);
      return (select(
        formulas,
      )..where((row) => row.id.equals(formulaId))).getSingle();
    },
  );

  Future<void> updateFormula(
    String id, {
    required String name,
    String? notes,
  }) => transaction(() async {
    final normalized = _requiredName(name, '香方名称不能为空');
    final formula = await (select(
      formulas,
    )..where((row) => row.id.equals(id))).getSingle();
    if (formula.isDeleted) throw StateError('已删除的香方不能修改');
    final change = await _recordOperation(
      entityType: 'formulas',
      entityId: id,
      baseRevisionId: formula.revisionId,
      operationKind: 'update',
      payload: {'id': id, 'name': normalized, 'notes': _optionalText(notes)},
    );
    await (update(formulas)..where((row) => row.id.equals(id))).write(
      FormulasCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        name: Value(normalized),
        notes: Value(_optionalText(notes)),
      ),
    );
  });

  Future<void> updateFormulaImage(String id, String? imageHash) =>
      transaction(() async {
        final formula = await (select(
          formulas,
        )..where((row) => row.id.equals(id))).getSingle();
        if (formula.isDeleted) throw StateError('已删除的香方不能修改');
        final normalized = _optionalImageHash(imageHash);
        final change = await _recordOperation(
          entityType: 'formulas',
          entityId: id,
          baseRevisionId: formula.revisionId,
          operationKind: 'update',
          payload: {'id': id, 'imageHash': normalized},
        );
        await (update(formulas)..where((row) => row.id.equals(id))).write(
          FormulasCompanion(
            revisionId: Value(change.revisionId),
            updatedByDevice: Value(change.deviceId),
            updatedAtUtc: Value(change.now),
            imageHash: Value(normalized),
          ),
        );
      });

  Future<void> deleteFormula(String id, {bool allowRecommended = false}) =>
      transaction(() async {
        final formula = await (select(
          formulas,
        )..where((row) => row.id.equals(id))).getSingle();
        if (formula.isDeleted) return;
        if (formula.isRecommended && !allowRecommended) {
          throw StateError('推荐香方只能在“推荐香方”中删除');
        }
        final change = await _recordOperation(
          entityType: 'formulas',
          entityId: id,
          baseRevisionId: formula.revisionId,
          operationKind: 'delete',
          payload: {'id': id},
        );
        await (update(formulas)..where((row) => row.id.equals(id))).write(
          FormulasCompanion(
            revisionId: Value(change.revisionId),
            updatedByDevice: Value(change.deviceId),
            updatedAtUtc: Value(change.now),
            isDeleted: const Value(true),
            deletedAtUtc: Value(change.now),
          ),
        );
      });

  Future<void> deleteFormulaDraft(String id) => transaction(() async {
    final draft = await (select(
      formulaDrafts,
    )..where((row) => row.id.equals(id))).getSingle();
    if (draft.isDeleted) return;
    final change = await _recordOperation(
      entityType: 'formula_drafts',
      entityId: id,
      baseRevisionId: draft.revisionId,
      operationKind: 'delete',
      payload: {'id': id},
    );
    await (update(formulaDrafts)..where((row) => row.id.equals(id))).write(
      FormulaDraftsCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        isDeleted: const Value(true),
        deletedAtUtc: Value(change.now),
      ),
    );
  });

  Future<void> deleteMixingSession(String id) => transaction(() async {
    final session = await (select(
      mixingSessions,
    )..where((row) => row.id.equals(id))).getSingle();
    if (session.isDeleted) return;
    final change = await _recordOperation(
      entityType: 'mixing_sessions',
      entityId: id,
      baseRevisionId: session.revisionId,
      operationKind: 'delete',
      payload: {'id': id},
    );
    await (update(mixingSessions)..where((row) => row.id.equals(id))).write(
      MixingSessionsCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        isDeleted: const Value(true),
        deletedAtUtc: Value(change.now),
      ),
    );
  });

  Future<List<FormulaIngredientChoice>> getActiveFormulaIngredients() async {
    final rows =
        await (select(ingredients).join([
                innerJoin(
                  ingredientCategories,
                  ingredientCategories.id.equalsExp(ingredients.categoryId),
                ),
              ])
              ..where(
                ingredients.isDeleted.equals(false) &
                    ingredients.isInactive.equals(false) &
                    ingredientCategories.isDeleted.equals(false) &
                    ingredientCategories.isInactive.equals(false),
              )
              ..orderBy([
                OrderingTerm.asc(ingredientCategories.sortOrder),
                OrderingTerm.asc(ingredients.name),
              ]))
            .get();
    return [
      for (final row in rows)
        FormulaIngredientChoice(
          id: row.readTable(ingredients).id,
          categoryId: row.readTable(ingredientCategories).id,
          categoryName: row.readTable(ingredientCategories).name,
          ingredientName: row.readTable(ingredients).name,
          categorySortOrder: row.readTable(ingredientCategories).sortOrder,
          imageHash: row.readTable(ingredients).imageHash,
        ),
    ];
  }

  Future<List<FormulaDraftItemInput>> getPresetDraftItems(
    String presetId,
  ) async {
    final preset = await _activePreset(presetId);
    final groups =
        await (select(recommendationGroups)..where(
              (row) =>
                  row.presetId.equals(preset.id) & row.isDeleted.equals(false),
            ))
            .get();
    if (groups.isEmpty ||
        groups.fold<int>(0, (sum, row) => sum + row.ratio) != 10000) {
      throw StateError('推荐配置的大类比例尚未补齐');
    }
    final result = <FormulaDraftItemInput>[];
    for (final group in groups) {
      final rows =
          await (select(recommendationItems).join([
                innerJoin(
                  ingredients,
                  ingredients.id.equalsExp(recommendationItems.ingredientId),
                ),
                innerJoin(
                  ingredientCategories,
                  ingredientCategories.id.equalsExp(ingredients.categoryId),
                ),
              ])..where(
                recommendationItems.groupId.equals(group.id) &
                    recommendationItems.isDeleted.equals(false),
              ))
              .get();
      if (rows.fold<int>(
            0,
            (sum, row) => sum + row.readTable(recommendationItems).ratio,
          ) !=
          group.ratio) {
        throw StateError('推荐配置的香料比例尚未补齐');
      }
      for (final row in rows) {
        final item = row.readTable(recommendationItems);
        final ingredient = row.readTable(ingredients);
        result.add(
          FormulaDraftItemInput(
            ingredientId: ingredient.id,
            categoryName: row.readTable(ingredientCategories).name,
            ingredientName: ingredient.name,
            ratio: item.ratio,
            sortOrder: result.length,
          ),
        );
      }
    }
    return result;
  }

  Future<FormulaDraft> createFormulaDraft({
    required String productionTypeId,
    List<String>? productionTypeIds,
    Map<String, List<int>>? productionTypeRatios,
    required int targetWeight,
    required List<FormulaDraftItemInput> items,
    String formulaName = '',
    String? customerId,
    String? plaqueTypeId,
    String? notes,
    String kind = 'new',
    String? formulaId,
    String? sourceVersionId,
  }) async => transaction(() async {
    final typeIds = productionTypeIds ?? [productionTypeId];
    final ratiosByType = {
      ...?productionTypeRatios,
      for (final id in typeIds)
        if (productionTypeRatios?[id] == null)
          id: [for (final item in items) item.ratio],
    };
    await _validateProductionTypes(productionTypeId, typeIds);
    if (targetWeight <= 0) {
      throw ArgumentError.value(targetWeight, 'targetWeight', '目标总重必须大于 0');
    }
    _validateDraftItems(items);
    _validateProductionTypeRatios(typeIds, items.length, ratiosByType);
    for (final item in items) {
      await _validateDraftIngredient(item.ingredientId);
    }
    if (customerId != null) await _activeCustomer(customerId);
    if (plaqueTypeId != null) await _activePlaque(plaqueTypeId);
    final id = _newId();
    final change = await _recordOperation(
      entityType: 'formula_drafts',
      entityId: id,
      operationKind: 'create',
      payload: {'id': id, 'kind': kind},
    );
    await into(formulaDrafts).insert(
      FormulaDraftsCompanion.insert(
        id: id,
        revisionId: change.revisionId,
        updatedByDevice: change.deviceId,
        updatedAtUtc: change.now,
        kind: kind,
        formulaId: Value(formulaId),
        sourceVersionId: Value(sourceVersionId),
        customerId: Value(customerId),
        plaqueTypeId: Value(plaqueTypeId),
        formulaName: Value(formulaName.trim()),
        productionTypeId: productionTypeId,
        productionTypeIdsJson: Value(jsonEncode(typeIds)),
        productionTypeRatiosJson: Value(jsonEncode(ratiosByType)),
        targetWeight: targetWeight,
        notes: Value(_optionalText(notes)),
        itemsJson: jsonEncode([for (final item in items) item.toJson()]),
        actualWeightsJson: jsonEncode(List<Object?>.filled(items.length, null)),
        createdAtUtc: change.now,
      ),
    );
    return (select(
      formulaDrafts,
    )..where((row) => row.id.equals(id))).getSingle();
  });

  Future<FormulaDraft> createDraftFromVersion({
    required String versionId,
    String? productionTypeId,
    required int targetWeight,
    String? customerId,
    String? plaqueTypeId,
    bool adjust = false,
  }) async {
    final version = await (select(
      formulaVersions,
    )..where((row) => row.id.equals(versionId))).getSingle();
    final formula = await (select(
      formulas,
    )..where((row) => row.id.equals(version.formulaId))).getSingle();
    final productionTypeIds = formulaVersionProductionTypeIds(version);
    final selectedTypeId = productionTypeId ?? version.productionTypeId;
    if (!productionTypeIds.contains(selectedTypeId)) {
      throw StateError('该制作类型不适用于此香方');
    }
    final items = await _versionDraftItems(versionId, selectedTypeId);
    return createFormulaDraft(
      productionTypeId: selectedTypeId,
      productionTypeIds: productionTypeIds,
      productionTypeRatios: formulaVersionProductionTypeRatios(version),
      targetWeight: targetWeight,
      items: items,
      formulaName: formula.name,
      customerId: customerId,
      plaqueTypeId: plaqueTypeId,
      kind: adjust ? 'adjust' : 'repeat',
      formulaId: formula.id,
      sourceVersionId: version.id,
    );
  }

  Future<FormulaDraft> createDraftFromLastCustomerSession({
    required String customerId,
    required String formulaId,
    required int targetWeight,
  }) async {
    final session =
        await (select(mixingSessions)
              ..where(
                (row) =>
                    row.customerId.equals(customerId) &
                    row.formulaId.equals(formulaId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.completedAtUtc)])
              ..limit(1))
            .getSingle();
    final mixing =
        await (select(mixingItems)
              ..where(
                (row) =>
                    row.sessionId.equals(session.id) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    final version = await (select(
      formulaVersions,
    )..where((row) => row.id.equals(session.versionId!))).getSingle();
    return createFormulaDraft(
      productionTypeId: version.productionTypeId,
      targetWeight: targetWeight,
      customerId: customerId,
      formulaName: session.formulaName,
      kind: 'repeat',
      formulaId: formulaId,
      sourceVersionId: session.versionId,
      items: [
        for (final item in mixing)
          FormulaDraftItemInput(
            ingredientId: item.ingredientId ?? '',
            categoryName: item.categoryName,
            ingredientName: item.ingredientName,
            ratio: item.finalRatio,
            sortOrder: item.sortOrder,
          ),
      ],
    );
  }

  Stream<List<FormulaDraft>> watchOpenDrafts({bool recommendedOnly = false}) =>
      (select(formulaDrafts)
            ..where(
              (row) =>
                  row.isDeleted.equals(false) &
                  row.isRecommended.equals(recommendedOnly),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAtUtc)]))
          .watch();

  Future<MixingDraftState> getMixingDraft(String id) async {
    final draft = await (select(
      formulaDrafts,
    )..where((row) => row.id.equals(id))).getSingle();
    if (draft.isDeleted) throw StateError('草稿已删除');
    final items = _decodeDraftItems(draft.itemsJson);
    final actual = (jsonDecode(draft.actualWeightsJson) as List<Object?>)
        .map((value) => value as int?)
        .toList();
    final planned = allocatePlannedWeights(draft.targetWeight, [
      for (final item in items) item.ratio,
    ]);
    final projected = projectFinalWeights(planned, actual);
    return MixingDraftState(
      draft: draft,
      items: items,
      plannedWeights: planned,
      actualWeights: actual,
      projectedWeights: projected,
      projectedRatios: calculateFinalRatios(projected),
    );
  }

  Future<void> setDraftActualWeight(
    String draftId,
    int index,
    int? weight,
  ) async {
    if (weight != null && weight < 0) {
      throw ArgumentError.value(weight, 'weight', '实际克重不能为负');
    }
    await transaction(() async {
      final state = await getMixingDraft(draftId);
      if (index < 0 || index >= state.items.length) {
        throw RangeError.index(index, state.items);
      }
      final beforeWarnings = await _rawDraftRangeWarnings(state);
      final actual = [...state.actualWeights]..[index] = weight;
      final projected = projectFinalWeights(state.plannedWeights, actual);
      final afterWarnings = await _rawDraftRangeWarnings(
        MixingDraftState(
          draft: state.draft,
          items: state.items,
          plannedWeights: state.plannedWeights,
          actualWeights: actual,
          projectedWeights: projected,
          projectedRatios: calculateFinalRatios(projected),
        ),
      );
      final confirmed =
          (jsonDecode(state.draft.confirmedWarningsJson) as List<Object?>)
              .cast<String>()
              .toSet();
      for (final key in confirmed.toList()) {
        final before = beforeWarnings
            .where((item) => item.key == key)
            .firstOrNull;
        final after = afterWarnings
            .where((item) => item.key == key)
            .firstOrNull;
        if (before == null ||
            after == null ||
            _warningSide(before) != _warningSide(after)) {
          confirmed.remove(key);
        }
      }
      final change = await _recordOperation(
        entityType: 'formula_drafts',
        entityId: draftId,
        baseRevisionId: state.draft.revisionId,
        operationKind: 'update',
        payload: {
          'id': draftId,
          'actualWeights': actual,
          'confirmedWarnings': confirmed.toList(),
        },
      );
      await (update(
        formulaDrafts,
      )..where((row) => row.id.equals(draftId))).write(
        FormulaDraftsCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          actualWeightsJson: Value(jsonEncode(actual)),
          confirmedWarningsJson: Value(jsonEncode(confirmed.toList())),
        ),
      );
    });
  }

  Future<int> fillMissingDraftWeightsFromPlan(String draftId) async {
    final state = await getMixingDraft(draftId);
    var filled = 0;
    for (var i = 0; i < state.actualWeights.length; i++) {
      if (state.actualWeights[i] != null) continue;
      await setDraftActualWeight(draftId, i, state.plannedWeights[i]);
      filled++;
    }
    return filled;
  }

  Future<List<RatioRangeCheck>> getDraftRangeWarnings(String draftId) async {
    final state = await getMixingDraft(draftId);
    final warnings = await _rawDraftRangeWarnings(state);
    final confirmed =
        (jsonDecode(state.draft.confirmedWarningsJson) as List<Object?>)
            .cast<String>()
            .toSet();
    return warnings
        .where((warning) => !confirmed.contains(warning.key))
        .toList();
  }

  Future<List<RatioRangeCheck>> _rawDraftRangeWarnings(
    MixingDraftState state,
  ) async {
    final actual = <String, int>{};
    final ranges = <String, ({String label, int minimum, int maximum})>{};
    for (var i = 0; i < state.items.length; i++) {
      final item = state.items[i];
      actual['ingredient:${item.ingredientId}'] = state.projectedRatios[i];
      final ingredientRange = await _effectiveIngredientRange(
        item.ingredientId,
        state.draft.productionTypeId,
      );
      if (ingredientRange != null) {
        ranges['ingredient:${item.ingredientId}'] = (
          label: item.label,
          minimum: ingredientRange.$1,
          maximum: ingredientRange.$2,
        );
      }
    }
    return checkRecommendationRanges(actualRatios: actual, ranges: ranges);
  }

  Future<void> confirmDraftWarnings(
    String draftId,
    Iterable<String> keys,
  ) async {
    final draft = await (select(
      formulaDrafts,
    )..where((row) => row.id.equals(draftId))).getSingle();
    final confirmed =
        (jsonDecode(draft.confirmedWarningsJson) as List<Object?>)
            .cast<String>()
            .toSet()
          ..addAll(keys);
    final change = await _recordOperation(
      entityType: 'formula_drafts',
      entityId: draftId,
      baseRevisionId: draft.revisionId,
      operationKind: 'update',
      payload: {'id': draftId, 'confirmedWarnings': confirmed.toList()},
    );
    await (update(formulaDrafts)..where((row) => row.id.equals(draftId))).write(
      FormulaDraftsCompanion(
        revisionId: Value(change.revisionId),
        updatedByDevice: Value(change.deviceId),
        updatedAtUtc: Value(change.now),
        confirmedWarningsJson: Value(jsonEncode(confirmed.toList())),
      ),
    );
  }

  Future<MixingSession> completeDraft(String draftId) => transaction(() async {
    final warnings = await getDraftRangeWarnings(draftId);
    if (warnings.isNotEmpty) throw StateError('仍有未确认的推荐区间超限');
    final state = await getMixingDraft(draftId);
    final now = DateTime.now().toUtc();
    final finalWeights = state.projectedWeights;
    final finalRatios = state.projectedRatios;
    var formulaId = state.draft.formulaId;
    String? versionId = state.draft.sourceVersionId;
    var formulaName = state.draft.formulaName.trim();
    if (state.draft.kind == 'new' || state.draft.kind == 'adjust') {
      formulaName = await _resolveFormulaName(
        formulaName,
        state.draft.customerId,
        now,
      );
      if (state.draft.kind == 'new') {
        formulaId = _newId();
        final formulaChange = await _recordOperation(
          entityType: 'formulas',
          entityId: formulaId,
          operationKind: 'create',
          payload: {'id': formulaId, 'name': formulaName},
        );
        await into(formulas).insert(
          FormulasCompanion.insert(
            id: formulaId,
            revisionId: formulaChange.revisionId,
            updatedByDevice: formulaChange.deviceId,
            updatedAtUtc: formulaChange.now,
            name: formulaName,
            imageHash: Value(state.draft.imageHash),
            notes: Value(state.draft.notes),
            isRecommended: Value(state.draft.isRecommended),
            lastUsedAtUtc: Value(now),
          ),
        );
      }
      final previousVersions = await (select(
        formulaVersions,
      )..where((row) => row.formulaId.equals(formulaId!))).get();
      versionId = _newId();
      final versionChange = await _recordOperation(
        entityType: 'formula_versions',
        entityId: versionId,
        operationKind: 'create',
        payload: {
          'id': versionId,
          'formulaId': formulaId,
          'sourceVersionId': state.draft.sourceVersionId,
        },
      );
      final productionTypeRatios = formulaDraftProductionTypeRatios(state.draft)
        ..[state.draft.productionTypeId] = finalRatios;
      await into(formulaVersions).insert(
        FormulaVersionsCompanion.insert(
          id: versionId,
          revisionId: versionChange.revisionId,
          updatedByDevice: versionChange.deviceId,
          updatedAtUtc: versionChange.now,
          formulaId: formulaId!,
          versionNumber: previousVersions.length + 1,
          sourceVersionId: Value(state.draft.sourceVersionId),
          productionTypeId: state.draft.productionTypeId,
          productionTypeIdsJson: Value(state.draft.productionTypeIdsJson),
          productionTypeRatiosJson: Value(jsonEncode(productionTypeRatios)),
          createdAtUtc: now,
        ),
      );
      for (var i = 0; i < state.items.length; i++) {
        await _insertFormulaItem(versionId, state.items[i], finalRatios[i]);
      }
      final formula = await (select(
        formulas,
      )..where((row) => row.id.equals(formulaId!))).getSingle();
      final formulaChange = await _recordOperation(
        entityType: 'formulas',
        entityId: formulaId,
        baseRevisionId: formula.revisionId,
        operationKind: 'update',
        payload: {'id': formulaId, 'currentVersionId': versionId},
      );
      await (update(formulas)..where((row) => row.id.equals(formulaId!))).write(
        FormulasCompanion(
          revisionId: Value(formulaChange.revisionId),
          updatedByDevice: Value(formulaChange.deviceId),
          updatedAtUtc: Value(formulaChange.now),
          currentVersionId: Value(versionId),
          imageHash: Value(state.draft.imageHash),
          notes: Value(state.draft.notes),
          lastUsedAtUtc: Value(now),
        ),
      );
    } else {
      final formula = await (select(
        formulas,
      )..where((row) => row.id.equals(formulaId!))).getSingle();
      formulaName = formula.name;
      final change = await _recordOperation(
        entityType: 'formulas',
        entityId: formula.id,
        baseRevisionId: formula.revisionId,
        operationKind: 'update',
        payload: {'id': formula.id, 'lastUsedAtUtc': now.toIso8601String()},
      );
      await (update(formulas)..where((row) => row.id.equals(formula.id))).write(
        FormulasCompanion(
          revisionId: Value(change.revisionId),
          updatedByDevice: Value(change.deviceId),
          updatedAtUtc: Value(change.now),
          lastUsedAtUtc: Value(now),
        ),
      );
    }
    final productionType = await (select(
      productionTypes,
    )..where((row) => row.id.equals(state.draft.productionTypeId))).getSingle();
    final sessionId = _newId();
    final sessionChange = await _recordOperation(
      entityType: 'mixing_sessions',
      entityId: sessionId,
      operationKind: 'create',
      payload: {
        'id': sessionId,
        'formulaId': formulaId,
        'versionId': versionId,
      },
    );
    await into(mixingSessions).insert(
      MixingSessionsCompanion.insert(
        id: sessionId,
        revisionId: sessionChange.revisionId,
        updatedByDevice: sessionChange.deviceId,
        updatedAtUtc: sessionChange.now,
        formulaId: Value(formulaId),
        versionId: Value(versionId),
        customerId: Value(state.draft.customerId),
        plaqueTypeId: Value(state.draft.plaqueTypeId),
        formulaName: formulaName,
        productionTypeName: productionType.name,
        targetWeight: state.draft.targetWeight,
        finalWeight: finalWeights.fold<int>(0, (sum, value) => sum + value),
        notes: Value(state.draft.notes),
        createdAtUtc: state.draft.createdAtUtc,
        completedAtUtc: now,
      ),
    );
    for (var i = 0; i < state.items.length; i++) {
      await _insertMixingItem(
        sessionId,
        state.items[i],
        state.plannedWeights[i],
        finalWeights[i],
        state.actualWeights[i] != null,
        finalRatios[i],
      );
    }
    final draftChange = await _recordOperation(
      entityType: 'formula_drafts',
      entityId: draftId,
      baseRevisionId: state.draft.revisionId,
      operationKind: 'delete',
      payload: {'id': draftId},
    );
    await (update(formulaDrafts)..where((row) => row.id.equals(draftId))).write(
      FormulaDraftsCompanion(
        revisionId: Value(draftChange.revisionId),
        updatedByDevice: Value(draftChange.deviceId),
        updatedAtUtc: Value(draftChange.now),
        isDeleted: const Value(true),
        deletedAtUtc: Value(draftChange.now),
      ),
    );
    return (select(
      mixingSessions,
    )..where((row) => row.id.equals(sessionId))).getSingle();
  });

  Stream<List<FormulaSummary>> watchFormulas({
    String search = '',
    String? productionTypeId,
    bool recommendedOnly = false,
    bool selfBuiltOnly = false,
  }) {
    final term = search.trim().toLowerCase();
    final pattern = '%$term%';
    final kindFilter = recommendedOnly
        ? 'AND f.is_recommended = 1'
        : selfBuiltOnly
        ? 'AND f.is_recommended = 0'
        : '';
    return customSelect(
      '''SELECT f.id
           FROM formulas f
          WHERE f.is_deleted = 0
            $kindFilter
            AND (? = ''
              OR lower(f.name) LIKE ?
              OR EXISTS (
                SELECT 1
                  FROM mixing_sessions ms
                  JOIN customers c
                    ON c.id = ms.customer_id AND c.is_deleted = 0
                 WHERE ms.formula_id = f.id
                   AND ms.is_deleted = 0
                   AND (lower(c.name) LIKE ? OR c.phone LIKE ?)
              ))
       ORDER BY f.last_used_at_utc DESC''',
      variables: [
        Variable.withString(term),
        Variable.withString(pattern),
        Variable.withString(pattern),
        Variable.withString(pattern),
      ],
      readsFrom: {formulas, mixingSessions, customers},
    ).watch().asyncMap((rows) async {
      final result = <FormulaSummary>[];
      for (final row in rows) {
        final formula = await (select(
          formulas,
        )..where((item) => item.id.equals(row.read<String>('id')))).getSingle();
        if (formula.currentVersionId == null) continue;
        final version =
            await (select(formulaVersions)
                  ..where((row) => row.id.equals(formula.currentVersionId!)))
                .getSingle();
        final typeIds = formulaVersionProductionTypeIds(version);
        if (productionTypeId != null && !typeIds.contains(productionTypeId)) {
          continue;
        }
        final types =
            await (select(productionTypes)
                  ..where((row) => row.id.isIn(typeIds))
                  ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
                .get();
        final items =
            await (select(formulaItems)
                  ..where(
                    (row) =>
                        row.versionId.equals(version.id) &
                        row.isDeleted.equals(false),
                  )
                  ..orderBy([(row) => OrderingTerm.desc(row.ratio)]))
                .get();
        final linkedCustomers = await customSelect(
          '''SELECT DISTINCT c.id
                     FROM mixing_sessions ms
                     JOIN customers c
                       ON c.id = ms.customer_id AND c.is_deleted = 0
                    WHERE ms.formula_id = ? AND ms.is_deleted = 0
                 ORDER BY ms.completed_at_utc DESC''',
          variables: [Variable.withString(formula.id)],
          readsFrom: {mixingSessions, customers},
        ).get();
        result.add(
          FormulaSummary(
            formula: formula,
            productionTypes: types,
            topIngredients: items
                .map((item) => item.ingredientName)
                .toSet()
                .take(2)
                .join('、'),
            customers: [
              for (final customerRow in linkedCustomers)
                await (select(customers)..where(
                      (item) => item.id.equals(customerRow.read<String>('id')),
                    ))
                    .getSingle(),
            ],
          ),
        );
      }
      return result;
    });
  }

  Stream<List<FormulaVersionSummary>> watchFormulaVersions(String formulaId) =>
      (select(formulaVersions)
            ..where(
              (row) =>
                  row.formulaId.equals(formulaId) & row.isDeleted.equals(false),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.versionNumber)]))
          .watch()
          .asyncMap(
            (versions) async => [
              for (final version in versions)
                FormulaVersionSummary(
                  version,
                  await (select(formulaItems)
                        ..where(
                          (row) =>
                              row.versionId.equals(version.id) &
                              row.isDeleted.equals(false),
                        )
                        ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
                      .get(),
                ),
            ],
          );

  Future<List<FormulaDraftItemInput>> getVersionDraftItems(
    String versionId, {
    String? productionTypeId,
  }) => _versionDraftItems(versionId, productionTypeId);

  Future<List<FormulaIngredientSummary>> getFormulaIngredientDetails(
    String versionId, {
    String? productionTypeId,
  }) async {
    final version = await (select(
      formulaVersions,
    )..where((row) => row.id.equals(versionId))).getSingle();
    final items =
        await (select(formulaItems)
              ..where(
                (row) =>
                    row.versionId.equals(versionId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    final ratios = formulaVersionProductionTypeRatios(
      version,
    )[productionTypeId ?? version.productionTypeId];
    return [
      for (var i = 0; i < items.length; i++)
        FormulaIngredientSummary(
          item: ratios?.elementAtOrNull(i) == null
              ? items[i]
              : items[i].copyWith(ratio: ratios![i]),
          imageHash: items[i].ingredientId == null
              ? null
              : (await (select(ingredients)..where(
                          (row) => row.id.equals(items[i].ingredientId!),
                        ))
                        .getSingleOrNull())
                    ?.imageHash,
        ),
    ];
  }

  Stream<List<MixingSession>> watchFormulaSessions(String formulaId) =>
      (select(mixingSessions)
            ..where(
              (row) =>
                  row.formulaId.equals(formulaId) & row.isDeleted.equals(false),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.completedAtUtc)]))
          .watch();

  Stream<List<MixingSessionSummary>> watchAllMixingSessions({
    String search = '',
  }) {
    final term = search.trim();
    final pattern = '%$term%';
    return customSelect(
      '''SELECT ms.id
           FROM mixing_sessions ms
      LEFT JOIN customers c
             ON c.id = ms.customer_id AND c.is_deleted = 0
          WHERE ms.is_deleted = 0
            AND (? = ''
              OR ms.formula_name LIKE ?
              OR c.name LIKE ?
              OR c.phone LIKE ?)
       ORDER BY ms.completed_at_utc DESC''',
      variables: [
        Variable.withString(term),
        Variable.withString(pattern),
        Variable.withString(pattern),
        Variable.withString(pattern),
      ],
      readsFrom: {mixingSessions, customers, formulas},
    ).watch().asyncMap((rows) async {
      final result = <MixingSessionSummary>[];
      for (final row in rows) {
        final session = await (select(
          mixingSessions,
        )..where((item) => item.id.equals(row.read<String>('id')))).getSingle();
        final customer = session.customerId == null
            ? null
            : await (select(customers)
                    ..where((item) => item.id.equals(session.customerId!)))
                  .getSingleOrNull();
        final formula = session.formulaId == null
            ? null
            : await (select(formulas)
                    ..where((item) => item.id.equals(session.formulaId!)))
                  .getSingleOrNull();
        result.add(
          MixingSessionSummary(
            session: session,
            customer: customer,
            formulaImageHash: formula?.imageHash,
          ),
        );
      }
      return result;
    });
  }

  Stream<List<MixingItem>> watchMixingItems(String sessionId) =>
      (select(mixingItems)
            ..where(
              (row) =>
                  row.sessionId.equals(sessionId) & row.isDeleted.equals(false),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
          .watch();

  Stream<List<CustomerFormulaHistory>> watchCustomerFormulaHistory(
    String customerId,
  ) =>
      customSelect(
        'SELECT formula_id, formula_name, MAX(completed_at_utc) AS last_used, COUNT(*) AS use_count '
        'FROM mixing_sessions WHERE customer_id = ? AND is_deleted = 0 AND formula_id IS NOT NULL '
        'GROUP BY formula_id, formula_name ORDER BY last_used DESC',
        variables: [Variable.withString(customerId)],
        readsFrom: {mixingSessions},
      ).watch().map(
        (rows) => [
          for (final row in rows)
            CustomerFormulaHistory(
              formulaId: row.read<String>('formula_id'),
              formulaName: row.read<String>('formula_name'),
              lastUsedAtUtc: DateTime.fromMillisecondsSinceEpoch(
                row.read<int>('last_used'),
                isUtc: true,
              ),
              useCount: row.read<int>('use_count'),
            ),
        ],
      );

  Stream<List<MixingSession>> watchCustomerFormulaSessions(
    String customerId,
    String formulaId,
  ) =>
      (select(mixingSessions)
            ..where(
              (row) =>
                  row.customerId.equals(customerId) &
                  row.formulaId.equals(formulaId) &
                  row.isDeleted.equals(false),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.completedAtUtc)]))
          .watch();

  Future<void> reviseMixingSession(String sessionId, List<int> finalWeights) =>
      transaction(() async {
        final session = await (select(
          mixingSessions,
        )..where((row) => row.id.equals(sessionId))).getSingle();
        final items =
            await (select(mixingItems)
                  ..where(
                    (row) =>
                        row.sessionId.equals(sessionId) &
                        row.isDeleted.equals(false),
                  )
                  ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
                .get();
        if (items.length != finalWeights.length ||
            finalWeights.any((value) => value < 0)) {
          throw ArgumentError('最终克重数量或数值无效');
        }
        final ratios = calculateFinalRatios(finalWeights);
        final device = await localDevice();
        final revisionId = _newId();
        final revisionChange = await _recordOperation(
          entityType: 'mixing_revisions',
          entityId: revisionId,
          operationKind: 'create',
          payload: {'id': revisionId, 'sessionId': sessionId},
        );
        await into(mixingRevisions).insert(
          MixingRevisionsCompanion.insert(
            id: revisionId,
            revisionId: revisionChange.revisionId,
            updatedByDevice: revisionChange.deviceId,
            updatedAtUtc: revisionChange.now,
            sessionId: sessionId,
            previousDataJson: jsonEncode({
              'finalWeight': session.finalWeight,
              'items': [
                for (final item in items)
                  {
                    'id': item.id,
                    'finalWeight': item.finalWeight,
                    'finalRatio': item.finalRatio,
                  },
              ],
            }),
            modifiedAtUtc: revisionChange.now,
            modifiedByDevice: device.id,
          ),
        );
        for (var i = 0; i < items.length; i++) {
          final change = await _recordOperation(
            entityType: 'mixing_items',
            entityId: items[i].id,
            baseRevisionId: items[i].revisionId,
            operationKind: 'update',
            payload: {
              'id': items[i].id,
              'finalWeight': finalWeights[i],
              'finalRatio': ratios[i],
            },
          );
          await (update(
            mixingItems,
          )..where((row) => row.id.equals(items[i].id))).write(
            MixingItemsCompanion(
              revisionId: Value(change.revisionId),
              updatedByDevice: Value(change.deviceId),
              updatedAtUtc: Value(change.now),
              finalWeight: Value(finalWeights[i]),
              finalRatio: Value(ratios[i]),
              isManual: const Value(true),
            ),
          );
        }
        final change = await _recordOperation(
          entityType: 'mixing_sessions',
          entityId: session.id,
          baseRevisionId: session.revisionId,
          operationKind: 'update',
          payload: {
            'id': session.id,
            'finalWeight': finalWeights.fold<int>(
              0,
              (sum, value) => sum + value,
            ),
          },
        );
        await (update(
          mixingSessions,
        )..where((row) => row.id.equals(session.id))).write(
          MixingSessionsCompanion(
            revisionId: Value(change.revisionId),
            updatedByDevice: Value(change.deviceId),
            updatedAtUtc: Value(change.now),
            finalWeight: Value(
              finalWeights.fold<int>(0, (sum, value) => sum + value),
            ),
          ),
        );
      });

  Future<MixingSession> copyMixingSessionToCustomer(
    String sessionId,
    String customerId,
  ) => transaction(() async {
    await _activeCustomer(customerId);
    final source = await (select(
      mixingSessions,
    )..where((row) => row.id.equals(sessionId))).getSingle();
    final sourceItems =
        await (select(mixingItems)
              ..where(
                (row) =>
                    row.sessionId.equals(sessionId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    final id = _newId();
    final change = await _recordOperation(
      entityType: 'mixing_sessions',
      entityId: id,
      operationKind: 'create',
      payload: {
        'id': id,
        'copiedFromSessionId': source.id,
        'customerId': customerId,
      },
    );
    await into(mixingSessions).insert(
      MixingSessionsCompanion.insert(
        id: id,
        revisionId: change.revisionId,
        updatedByDevice: change.deviceId,
        updatedAtUtc: change.now,
        formulaId: Value(source.formulaId),
        versionId: Value(source.versionId),
        customerId: Value(customerId),
        plaqueTypeId: Value(source.plaqueTypeId),
        formulaName: source.formulaName,
        productionTypeName: source.productionTypeName,
        targetWeight: source.targetWeight,
        finalWeight: source.finalWeight,
        notes: Value(source.notes),
        createdAtUtc: change.now,
        completedAtUtc: change.now,
      ),
    );
    for (final item in sourceItems) {
      await _insertMixingItem(
        id,
        FormulaDraftItemInput(
          ingredientId: item.ingredientId ?? '',
          categoryName: item.categoryName,
          ingredientName: item.ingredientName,
          ratio: item.finalRatio,
          sortOrder: item.sortOrder,
        ),
        item.plannedWeight,
        item.finalWeight,
        item.isManual,
        item.finalRatio,
      );
    }
    return (select(
      mixingSessions,
    )..where((row) => row.id.equals(id))).getSingle();
  });

  Future<List<MixingRevision>> getMixingRevisions(String sessionId) =>
      (select(mixingRevisions)
            ..where(
              (row) =>
                  row.sessionId.equals(sessionId) & row.isDeleted.equals(false),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.modifiedAtUtc)]))
          .get();

  void _validateDraftItems(List<FormulaDraftItemInput> items) {
    if (items.isEmpty) throw ArgumentError('至少选择一个香料');
    if (items.map((item) => item.ingredientId).toSet().length != items.length) {
      throw ArgumentError('不能重复选择同一香料');
    }
    if (items.any((item) => item.ratio <= 0 || item.ratio > 10000) ||
        items.fold<int>(0, (sum, item) => sum + item.ratio) != 10000) {
      throw ArgumentError('香料比例合计必须为 100.00%');
    }
  }

  int _warningSide(RatioRangeCheck warning) =>
      warning.actual < warning.minimum ? -1 : 1;

  List<FormulaDraftItemInput> _decodeDraftItems(String value) =>
      (jsonDecode(value) as List<Object?>)
          .map(
            (item) => FormulaDraftItemInput.fromJson(
              (item! as Map).cast<String, Object?>(),
            ),
          )
          .toList();

  Future<List<FormulaDraftItemInput>> _versionDraftItems(
    String versionId,
    String? productionTypeId,
  ) async {
    final version = await (select(
      formulaVersions,
    )..where((row) => row.id.equals(versionId))).getSingle();
    final rows =
        await (select(formulaItems)
              ..where(
                (row) =>
                    row.versionId.equals(versionId) &
                    row.isDeleted.equals(false),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    final ratios = formulaVersionProductionTypeRatios(
      version,
    )[productionTypeId ?? version.productionTypeId];
    return [
      for (var i = 0; i < rows.length; i++)
        FormulaDraftItemInput(
          ingredientId: rows[i].ingredientId ?? '',
          categoryName: rows[i].categoryName,
          ingredientName: rows[i].ingredientName,
          ratio: ratios?.elementAtOrNull(i) ?? rows[i].ratio,
          sortOrder: rows[i].sortOrder,
        ),
    ];
  }

  Future<Customer> _activeCustomer(String id) async {
    final customer = await (select(
      customers,
    )..where((row) => row.id.equals(id))).getSingle();
    if (customer.isDeleted) throw StateError('请选择未删除的顾客');
    return customer;
  }

  Future<void> _validateProductionTypes(
    String productionTypeId,
    List<String> productionTypeIds,
  ) async {
    final uniqueIds = productionTypeIds.toSet();
    if (uniqueIds.isEmpty ||
        uniqueIds.length != productionTypeIds.length ||
        !uniqueIds.contains(productionTypeId)) {
      throw ArgumentError('请至少选择一种制作类型');
    }
    for (final id in productionTypeIds) {
      await _activeProductionType(id);
    }
  }

  void _validateProductionTypeRatios(
    List<String> productionTypeIds,
    int itemCount,
    Map<String, List<int>> ratiosByType,
  ) {
    for (final id in productionTypeIds) {
      final ratios = ratiosByType[id];
      if (ratios == null ||
          ratios.length != itemCount ||
          ratios.any((ratio) => ratio <= 0 || ratio > 10000) ||
          ratios.fold<int>(0, (sum, ratio) => sum + ratio) != 10000) {
        throw ArgumentError('每种制作类型的香料比例合计都必须为 100.00%');
      }
    }
  }

  Future<PlaqueType> _activePlaque(String id) async {
    final plaque = await (select(
      plaqueTypes,
    )..where((row) => row.id.equals(id))).getSingle();
    if (plaque.isDeleted || plaque.isInactive) {
      throw StateError('请选择可用的合香珠 / 香牌');
    }
    return plaque;
  }

  Future<void> _validateDraftIngredient(String id) async {
    final ingredient = await (select(
      ingredients,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (ingredient == null || ingredient.isDeleted || ingredient.isInactive) {
      throw StateError('草稿包含已停用或删除的香料');
    }
    await _activeIngredient(ingredient.id);
  }

  Future<(int, int)?> _effectiveIngredientRange(
    String ingredientId,
    String productionTypeId,
  ) async {
    final range = await customSelect(
      '''SELECT COALESCE(own.min_ratio, inherited.min_ratio) AS min_ratio,
                COALESCE(own.max_ratio, inherited.max_ratio) AS max_ratio
           FROM ingredients i
      LEFT JOIN ingredient_ratio_ranges own
             ON own.ingredient_id = i.id
            AND own.production_type_id = ?
            AND own.is_deleted = 0
      LEFT JOIN category_ratio_ranges inherited
             ON inherited.category_id = i.category_id
            AND inherited.production_type_id = ?
            AND inherited.is_deleted = 0
          WHERE i.id = ?''',
      variables: [
        Variable(productionTypeId),
        Variable(productionTypeId),
        Variable(ingredientId),
      ],
      readsFrom: {ingredients, ingredientRatioRanges, categoryRatioRanges},
    ).getSingleOrNull();
    final minimum = range?.readNullable<int>('min_ratio');
    final maximum = range?.readNullable<int>('max_ratio');
    return minimum == null || maximum == null ? null : (minimum, maximum);
  }

  Future<String> _resolveFormulaName(
    String name,
    String? customerId,
    DateTime now,
  ) async {
    var base = name.trim();
    if (base.isEmpty) {
      if (customerId == null) throw ArgumentError('未关联顾客时必须填写香方名称');
      final customer = await _activeCustomer(customerId);
      final local = now.add(const Duration(hours: 8));
      final date =
          '${(local.year % 100).toString().padLeft(2, '0')}${local.month.toString().padLeft(2, '0')}${local.day.toString().padLeft(2, '0')}';
      base = customer.name.isNotEmpty
          ? '${customer.name.substring(0, 1)}$date'
          : '${customer.phone.length <= 4 ? customer.phone : customer.phone.substring(customer.phone.length - 4)}-$date';
    }
    var candidate = base;
    var suffix = 2;
    while (await (select(formulas)..where(
              (row) => row.name.equals(candidate) & row.isDeleted.equals(false),
            ))
            .getSingleOrNull() !=
        null) {
      candidate = '$base-${suffix++}';
    }
    return candidate;
  }

  Future<void> _insertFormulaItem(
    String versionId,
    FormulaDraftItemInput item,
    int ratio,
  ) async {
    final id = _newId();
    final change = await _recordOperation(
      entityType: 'formula_items',
      entityId: id,
      operationKind: 'create',
      payload: {'id': id, 'versionId': versionId, 'ratio': ratio},
    );
    await into(formulaItems).insert(
      FormulaItemsCompanion.insert(
        id: id,
        revisionId: change.revisionId,
        updatedByDevice: change.deviceId,
        updatedAtUtc: change.now,
        versionId: versionId,
        ingredientId: Value(item.ingredientId),
        categoryName: item.categoryName,
        ingredientName: item.ingredientName,
        ratio: ratio,
        sortOrder: item.sortOrder,
      ),
    );
  }

  Future<void> _insertMixingItem(
    String sessionId,
    FormulaDraftItemInput item,
    int plannedWeight,
    int finalWeight,
    bool isManual,
    int finalRatio,
  ) async {
    final id = _newId();
    final change = await _recordOperation(
      entityType: 'mixing_items',
      entityId: id,
      operationKind: 'create',
      payload: {'id': id, 'sessionId': sessionId, 'finalWeight': finalWeight},
    );
    await into(mixingItems).insert(
      MixingItemsCompanion.insert(
        id: id,
        revisionId: change.revisionId,
        updatedByDevice: change.deviceId,
        updatedAtUtc: change.now,
        sessionId: sessionId,
        ingredientId: Value(item.ingredientId),
        categoryName: item.categoryName,
        ingredientName: item.ingredientName,
        plannedWeight: plannedWeight,
        finalWeight: finalWeight,
        isManual: isManual,
        finalRatio: finalRatio,
        sortOrder: item.sortOrder,
      ),
    );
  }
}
