import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as p;
import 'package:xiangfangbu/data/media_store.dart';

void main() {
  test('stores JPEG bytes by SHA-256 and de-duplicates them', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-media-');
    addTearDown(() => directory.delete(recursive: true));
    final store = MediaStore(directory);
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    var changes = 0;
    store.addListener(() => changes++);

    final first = await store.putJpeg(bytes);
    final second = await store.putJpeg(bytes);

    expect(second, first);
    expect(store.revision, 1);
    expect(changes, 1);
    expect(await store.fileFor(first).readAsBytes(), bytes);
    expect(await directory.list().length, 1);
  });

  test('coalesces concurrent writes and rejects unsafe hashes', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-media-');
    addTearDown(() => directory.delete(recursive: true));
    final store = MediaStore(directory);
    final bytes = Uint8List.fromList(
      List.generate(4096, (index) => index % 256),
    );

    final hashes = await Future.wait(
      List.generate(20, (_) => store.putJpeg(bytes)),
    );

    expect(hashes.toSet(), hasLength(1));
    expect(await directory.list().length, 1);
    expect(() => store.fileFor('../outside'), throwsArgumentError);
  });

  test('preserves aspect ratio, resizes and encodes images as JPEG', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-media-');
    addTearDown(() => directory.delete(recursive: true));
    final store = MediaStore(directory);
    final source = image.Image(width: 2400, height: 2000);
    image.fill(source, color: image.ColorRgb8(120, 80, 40));

    final hash = await store.putImage(
      Uint8List.fromList(image.encodeJpg(source)),
    );
    final decoded = image.decodeJpg(await store.fileFor(hash).readAsBytes());

    expect(decoded, isNotNull);
    expect((decoded!.width, decoded.height), (1600, 1333));
  });

  test('removes only stale media and interrupted temporary writes', () async {
    final directory = await Directory.systemTemp.createTemp('xiang-media-');
    addTearDown(() => directory.delete(recursive: true));
    final store = MediaStore(directory);
    final retained = await store.putJpeg(Uint8List.fromList([1]));
    const stale =
        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
    const interrupted =
        'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc';
    await File(p.join(directory.path, '$stale.jpg')).writeAsBytes([2]);
    await File(
      p.join(directory.path, '.$interrupted.tmp'),
    ).writeAsBytes([3]);
    await File(p.join(directory.path, 'keep.txt')).writeAsString('unmanaged');

    final deleted = await store.deleteUnreferenced({retained});

    expect(deleted, 2);
    expect(await store.fileFor(retained).exists(), isTrue);
    expect(await store.fileFor(stale).exists(), isFalse);
    expect(await File(p.join(directory.path, 'keep.txt')).exists(), isTrue);
  });

  test(
    'protects a new file until its database reference is committed',
    () async {
      final directory = await Directory.systemTemp.createTemp('xiang-media-');
      addTearDown(() => directory.delete(recursive: true));
      final store = MediaStore(directory);
      final hash = await store.putJpeg(Uint8List.fromList([1, 2, 3]));

      expect(await store.deleteUnreferenced({}), 0);
      expect(await store.fileFor(hash).exists(), isTrue);
    },
  );
}
