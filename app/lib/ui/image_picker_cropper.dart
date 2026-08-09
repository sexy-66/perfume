import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/media_store.dart';
import 'single_modal.dart';

Future<String?> pickAndCropStoredImage(
  BuildContext context,
  MediaStore mediaStore, {
  required double aspectRatio,
}) async {
  final source = await showSingleModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('拍照'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('从相册选择'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null || !context.mounted) return null;
  final picked = await ImagePicker().pickImage(
    source: source,
    maxWidth: 2400,
    imageQuality: 92,
  );
  if (picked == null || !context.mounted) return null;
  final cropped = await Navigator.of(context).push<Uint8List>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) =>
          ImageCropPage(image: picked.readAsBytes(), aspectRatio: aspectRatio),
    ),
  );
  return cropped == null ? null : mediaStore.putImage(cropped);
}

class ImageCropPage extends StatefulWidget {
  const ImageCropPage({
    super.key,
    required this.image,
    required this.aspectRatio,
  });

  final Future<Uint8List> image;
  final double aspectRatio;

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final _controller = CropController();
  late final Future<Uint8List> _image = widget.image;
  var _ready = false;
  var _cropping = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: const Text('调整图片'),
      actions: [
        TextButton(
          onPressed: _ready && !_cropping ? _crop : null,
          child: const Text('使用'),
        ),
      ],
    ),
    body: FutureBuilder<Uint8List>(
      future: _image,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('无法读取图片', style: TextStyle(color: Colors.white)),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: Crop(
                  key: const ValueKey('image-crop-editor'),
                  image: snapshot.data!,
                  controller: _controller,
                  aspectRatio: widget.aspectRatio,
                  interactive: true,
                  fixCropRect: true,
                  baseColor: Colors.black,
                  maskColor: Colors.black.withValues(alpha: 0.65),
                  radius: 12,
                  filterQuality: FilterQuality.medium,
                  progressIndicator: const CircularProgressIndicator(),
                  initialRectBuilder: InitialRectBuilder.withSizeAndRatio(
                    size: 0.88,
                    aspectRatio: widget.aspectRatio,
                  ),
                  overlayBuilder: (_, _) =>
                      CustomPaint(painter: _CropGridPainter()),
                  onStatusChanged: (status) {
                    final ready = status == CropStatus.ready;
                    if (_ready != ready && mounted) {
                      setState(() => _ready = ready);
                    }
                  },
                  onCropped: (result) {
                    if (!mounted) return;
                    switch (result) {
                      case CropSuccess(:final croppedImage):
                        Navigator.pop(context, croppedImage);
                      case CropFailure():
                        setState(() => _cropping = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('裁切失败，请重试')),
                        );
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.open_with, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '拖动图片调整位置，双指缩放取景',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  void _crop() {
    setState(() => _cropping = true);
    _controller.crop();
  }
}

class _CropGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    for (final fraction in const [1 / 3, 2 / 3]) {
      canvas.drawLine(
        Offset(size.width * fraction, 0),
        Offset(size.width * fraction, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height * fraction),
        Offset(size.width, size.height * fraction),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
