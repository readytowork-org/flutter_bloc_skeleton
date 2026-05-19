// ignore_for_file: avoid_print

import 'dart:io';

void main() {
  final assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    print('Assets directory not found');
    return;
  }

  final buffer = StringBuffer();
  buffer.writeln('class Assets {');
  buffer.writeln('  static const String _assets = "assets";');
  buffer.writeln();
  buffer.writeln(
    '  static const String translations = "\$_assets/translations";',
  );
  buffer.writeln('  static const String icons = "\$_assets/icons";');
  buffer.writeln('  static const String images = "\$_assets/images";');
  buffer.writeln();

  final files = assetsDir.listSync(recursive: true).whereType<File>().where((
    file,
  ) {
    final path = file.path.toLowerCase();
    return path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.svg') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp');
  }).toList();

  // Sort files for consistent output
  files.sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final pathSegments = file.path.split(Platform.pathSeparator);
    final fileName = pathSegments.last;
    final parentDir = pathSegments[pathSegments.length - 2];

    final nameWithoutExt = fileName.split('.').first;

    String prefix = '';
    if (parentDir == 'icons') {
      prefix = 'ic';
    } else if (parentDir == 'images') {
      prefix = 'img';
    }

    final varName = _toCamelCase(nameWithoutExt, prefix);

    // Ensure path uses forward slashes regardless of OS
    String relativePath = file.path.replaceAll(Platform.pathSeparator, '/');
    if (relativePath.startsWith('assets/icons/')) {
      relativePath = relativePath.replaceFirst('assets/icons/', '\$icons/');
    } else if (relativePath.startsWith('assets/images/')) {
      relativePath = relativePath.replaceFirst('assets/images/', '\$images/');
    } else {
      relativePath = relativePath.replaceFirst('assets/', '\$_assets/');
    }

    buffer.writeln('  static const String $varName = "$relativePath";');
  }

  buffer.writeln('}');

  final outputFile = File('lib/core/utils/assets/index.dart');
  outputFile.writeAsStringSync(buffer.toString());

  // Format the generated file
  Process.runSync('dart', ['format', outputFile.path]);

  print('✅ Assets generated successfully at ${outputFile.path}');
}

String _toCamelCase(String str, String prefix) {
  // Replace both dashes and underscores with spaces to split
  final parts = str.replaceAll('-', '_').split('_');
  var result = '';

  if (prefix.isNotEmpty) {
    result = prefix;
    for (final part in parts) {
      if (part.isEmpty) continue;
      result += part[0].toUpperCase() + part.substring(1).toLowerCase();
    }
  } else {
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isEmpty) continue;
      if (i == 0) {
        result += part.toLowerCase();
      } else {
        result += part[0].toUpperCase() + part.substring(1).toLowerCase();
      }
    }
  }
  return result;
}
