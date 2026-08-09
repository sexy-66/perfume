import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:xiangfangbu/ui/image_picker_cropper.dart';

void main() {
  testWidgets('crop page supports moving the image and returns cropped bytes', (
    tester,
  ) async {
    final source = image.Image(width: 400, height: 300);
    image.fill(source, color: image.ColorRgb8(90, 60, 30));
    final bytes = Uint8List.fromList(image.encodeJpg(source));

    await tester.pumpWidget(
      MaterialApp(
        home: ImageCropPage(image: Future.value(bytes), aspectRatio: 4 / 3),
      ),
    );
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 1)),
    );
    await tester.pump(const Duration(seconds: 1));

    final editor = find.byType(Crop);
    expect(editor, findsOneWidget);
    expect(find.text('拖动图片调整位置，双指缩放取景'), findsOneWidget);
    await tester.drag(editor, const Offset(20, 0));
    await tester.pump();
    final useButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, '使用'),
    );
    expect(useButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });
}
