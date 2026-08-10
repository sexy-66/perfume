import 'dart:io';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaStore extends ChangeNotifier {
  MediaStore(this.directory);

  final Directory directory;
  final Map<String, Future<String>> _writes = {};
  final Map<String, DateTime> _recentWrites = {};
  int _revision = 0;

  int get revision => _revision;

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
    if (await file.exists()) {
      _protectWrite(hash);
      return hash;
    }
    final temporary = File(p.join(directory.path, '.$hash.tmp'));
    var created = false;
    try {
      await temporary.writeAsBytes(bytes, flush: true);
      if (!await file.exists()) {
        await temporary.rename(file.path);
        created = true;
      }
    } finally {
      if (await temporary.exists()) await temporary.delete();
    }
    if (created) {
      _protectWrite(hash);
      try {
        PaintingBinding.instance.imageCache.evict(FileImage(file));
      } on FlutterError {
        // Plain unit tests do not initialize Flutter's painting binding.
      }
      _revision++;
      notifyListeners();
    }
    return hash;
  }

  File fileFor(String hash) {
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
      throw ArgumentError.value(hash, 'hash', '图片标识无效');
    }
    return File(p.join(directory.path, '$hash.jpg'));
  }

  Future<int> deleteUnreferenced(Set<String> retainedHashes) async {
    await initialize();
    final now = DateTime.now();
    _recentWrites.removeWhere((_, until) => !until.isAfter(now));
    var deleted = 0;
    await for (final entity in directory.list()) {
      if (entity is! File) continue;
      final name = p.basename(entity.path);
      final temporary = RegExp(r'^\.([0-9a-f]{64})\.tmp$').firstMatch(name);
      if (temporary != null) {
        if (_writes.containsKey(temporary.group(1))) continue;
        await entity.delete();
        deleted++;
        continue;
      }
      final match = RegExp(r'^([0-9a-f]{64})\.jpg$').firstMatch(name);
      final hash = match?.group(1);
      if (hash == null ||
          retainedHashes.contains(hash) ||
          _writes.containsKey(hash) ||
          _recentWrites.containsKey(hash)) {
        continue;
      }
      if (await _deleteFile(entity)) deleted++;
    }
    if (deleted > 0) _markChanged();
    return deleted;
  }

  Future<bool> _deleteFile(File file) async {
    if (!await file.exists()) return false;
    _evict(file);
    await file.delete();
    return true;
  }

  void _markChanged() {
    _revision++;
    notifyListeners();
  }

  void _protectWrite(String hash) {
    _recentWrites[hash] = DateTime.now().add(const Duration(minutes: 5));
  }

  void _evict(File file) {
    try {
      PaintingBinding.instance.imageCache.evict(FileImage(file));
    } on FlutterError {
      // Plain unit tests do not initialize Flutter's painting binding.
    }
  }
}
