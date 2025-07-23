import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

const assetPath = 'assets/images';
const scales = [1.5, 2.0, 3.0, 4.0];

void resizeAndSave(File imageFile, double scale) {
  final baseDir = imageFile.parent.path;
  final filename = imageFile.uri.pathSegments.last;
  final scaleDir = '${scale}x';
  final outputDir = Directory('$baseDir/$scaleDir');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }
  final outputPath = '${outputDir.path}/$filename';

  final img = decodeImage(imageFile.readAsBytesSync());
  if (img == null) return;
  final newWidth = (img.width * scale).round();
  final newHeight = (img.height * scale).round();
  final resized = copyResize(
    img,
    width: newWidth,
    height: newHeight,
    interpolation: Interpolation.average,
  );
  File(outputPath).writeAsBytesSync(encodePng(resized));
  debugPrint('Saved: $outputPath');
}

void main() {
  final dir = Directory(assetPath);
  if (!dir.existsSync()) {
    debugPrint('assets/images folder not found!');
    return;
  }
  for (final entity in dir.listSync()) {
    if (entity is File &&
        (entity.path.endsWith('.png') ||
            entity.path.endsWith('.jpg') ||
            entity.path.endsWith('.jpeg') ||
            entity.path.endsWith('.webp'))) {
      for (final scale in scales) {
        resizeAndSave(entity, scale);
      }
    }
  }
}
