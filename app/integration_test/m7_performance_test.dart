import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:integration_test/integration_test.dart';
import 'package:xiangfangbu/data/app_database.dart';
import 'package:xiangfangbu/data/media_store.dart';
import 'package:xiangfangbu/features/ingredients/ingredient_library_page.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('M7 ingredient image grid scrolls within the frame budget', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final mediaDirectory = await Directory.systemTemp.createTemp('m7-perf-');
    final mediaStore = MediaStore(mediaDirectory);
    addTearDown(() async {
      await database.close();
      await mediaDirectory.delete(recursive: true);
    });
    await database.initialize();
    final category = await database.createIngredientCategory('M7性能样本');
    final hashes = <String>[];
    for (var i = 0; i < 12; i++) {
      final source = image.Image(width: 800, height: 800);
      image.fill(
        source,
        color: image.ColorRgb8(40 + i * 15, 70 + i * 8, 110 + i * 5),
      );
      hashes.add(
        await mediaStore.putJpeg(
          Uint8List.fromList(image.encodeJpg(source, quality: 88)),
        ),
      );
    }
    for (var i = 0; i < 60; i++) {
      await database.createIngredient(
        categoryId: category.id,
        name: '性能香料 ${i + 1}',
        imageHash: hashes[i % hashes.length],
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        home: IngredientLibraryPage(database: database, mediaStore: mediaStore),
      ),
    );
    await tester.pumpAndSettle();
    final grid = find.byType(GridView);
    expect(grid, findsOneWidget);

    await binding.watchPerformance(() async {
      for (var i = 0; i < 6; i++) {
        await tester.fling(grid, const Offset(0, -1800), 5000);
        await tester.pumpAndSettle();
      }
      for (var i = 0; i < 6; i++) {
        await tester.fling(grid, const Offset(0, 1800), 5000);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'm7_ingredient_scroll');

    final summary = Map<String, dynamic>.from(
      binding.reportData!['m7_ingredient_scroll'] as Map,
    );
    expect(summary['frame_count'] as int, greaterThan(20));
    expect(tester.takeException(), isNull);
  });
}
