import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/media_store.dart';
import '../formulas/formulas_page.dart';

/// 推荐香方与普通香方使用同一套数据和编辑流程，但只在本页管理。
class RecommendationPresetsPage extends StatelessWidget {
  const RecommendationPresetsPage({
    super.key,
    required this.database,
    required this.mediaStore,
  });

  final AppDatabase database;
  final MediaStore mediaStore;

  @override
  Widget build(BuildContext context) => FormulasPage(
    database: database,
    mediaStore: mediaStore,
    recommendedOnly: true,
  );
}
