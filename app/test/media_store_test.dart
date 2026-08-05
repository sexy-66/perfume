import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/data/media_store.dart';

void main() {
  test('stores JPEG bytes by SHA-256 and de-duplicates them', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-media-');
    addTearDown(() => directory.delete(recursive: true));
    final store = MediaStore(directory);
    final bytes = Uint8List.fromList([1, 2, 3, 4]);

    final first = await store.putJpeg(bytes);
    final second = await store.putJpeg(bytes);

    expect(second, first);
    expect(await store.fileFor(first).readAsBytes(), bytes);
    expect(await directory.list().length, 1);
  });
}
