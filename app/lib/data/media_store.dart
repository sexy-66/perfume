import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaStore {
  MediaStore(this.directory);

  final Directory directory;
  final Map<String, Future<String>> _writes = {};

  static Future<MediaStore> defaults() async => MediaStore(
    Directory(p.join((await getApplicationSupportDirectory()).path, 'media')),
  );

  Future<void> initialize() => directory.create(recursive: true);

  Future<String> putImage(Uint8List bytes) async {
    if (bytes.isEmpty) throw ArgumentError.value(bytes, 'bytes');
    final jpeg = await Isolate.run(() {
      var decoded = image.decodeImage(bytes);
      if (decoded == null) throw const FormatException('无法读取图片');
      decoded = image.bakeOrientation(decoded);
      final longest = decoded.width > decoded.height
          ? decoded.width
          : decoded.height;
      if (longest > 1600) {
        decoded = decoded.width > decoded.height
            ? image.copyResize(decoded, width: 1600)
            : image.copyResize(decoded, height: 1600);
      }
      return image.encodeJpg(decoded, quality: 85);
    });
    return putJpeg(jpeg);
  }

  Future<String> putJpeg(Uint8List bytes) async {
    if (bytes.isEmpty) throw ArgumentError.value(bytes, 'bytes');
    await initialize();
    final digest = await Sha256().hash(bytes);
    final hash = digest.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    // ponytail: coalesces one app process; use file locks if media gets multi-process writers.
    return _writes[hash] ??= _writeJpeg(hash, bytes).whenComplete(() {
      _writes.remove(hash);
    });
  }

  Future<String> _writeJpeg(String hash, Uint8List bytes) async {
    final file = File(p.join(directory.path, '$hash.jpg'));
    if (await file.exists()) return hash;
    final temporary = File(p.join(directory.path, '.$hash.tmp'));
    try {
      await temporary.writeAsBytes(bytes, flush: true);
      if (!await file.exists()) await temporary.rename(file.path);
    } finally {
      if (await temporary.exists()) await temporary.delete();
    }
    return hash;
  }

  File fileFor(String hash) {
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
      throw ArgumentError.value(hash, 'hash', '图片标识无效');
    }
    return File(p.join(directory.path, '$hash.jpg'));
  }
}
