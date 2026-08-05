import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class MediaStore {
  MediaStore(this.directory);

  final Directory directory;

  static Future<MediaStore> defaults() async => MediaStore(
        Directory(p.join((await getApplicationSupportDirectory()).path, 'media')),
      );

  Future<void> initialize() => directory.create(recursive: true);

  Future<String> putJpeg(Uint8List bytes) async {
    if (bytes.isEmpty) throw ArgumentError.value(bytes, 'bytes');
    await initialize();
    final digest = await Sha256().hash(bytes);
    final hash = digest.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
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

  File fileFor(String hash) => File(p.join(directory.path, '$hash.jpg'));
}
