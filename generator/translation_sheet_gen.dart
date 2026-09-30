// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:gsheets/gsheets.dart';

void main() async {
  final file = File('./google_sheet.json');

  if (!file.existsSync()) {
    throw Exception("❌ Service account JSON not found!");
  }

  final contents = await file.readAsString();

  print("✅ Service account key loaded");
  print('🔐 Connecting to Google Sheets...');

  final translationSheet = GSheets(contents);

  final ss = await translationSheet.spreadsheet(
    '1x8Tk20ZheNAmvG6HJu3qzqxK5IgtcyacHe0HMetqBbE',
  );

  print('📒 Spreadsheet loaded');

  final Map<String, dynamic> enJson = {"@@locale": "en"};

  final Map<String, dynamic> jaJson = {"@@locale": "ja"};

  for (final sheet in ss.sheets) {
    final sheetTitle = sheet.title.trim();

    print('📄 Processing sheet: $sheetTitle');

    final rows = await sheet.values.allRows();

    if (rows.length < 2) {
      print('⚠️ Skipping "$sheetTitle": no data or only header');
      continue;
    }

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      /// Expected:
      /// Column B => key
      /// Column C => en
      /// Column D => ja
      if (row.length < 4) continue;

      final key = row[1].trim();
      final en = row[2].trim();
      final ja = row[3].trim();

      if (key.isEmpty) continue;

      /// Example:
      /// sheet = auth
      /// key = email_address
      /// result = authEmailAddress
      final generatedKey = '${_toCamelCase(sheetTitle)}${_toPascalCase(key)}';

      enJson[generatedKey] = en;
      jaJson[generatedKey] = ja;
    }

    print('✅ Completed: $sheetTitle');
  }

  final dir = Directory('./lib/l10n');

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final enPath = '${dir.path}/app_en.arb';
  final jaPath = '${dir.path}/app_ja.arb';

  await File(enPath).writeAsString(
    const JsonEncoder.withIndent('  ').convert(enJson),
    flush: true,
  );

  await File(jaPath).writeAsString(
    const JsonEncoder.withIndent('  ').convert(jaJson),
    flush: true,
  );

  print('🎉 Translations exported successfully!');
  print('📤 EN: $enPath');
  print('📤 JA: $jaPath');
}

String _toCamelCase(String value) {
  final words = value.trim().split('_').where((e) => e.isNotEmpty).toList();

  if (words.isEmpty) return '';

  return words.first.toLowerCase() +
      words
          .skip(1)
          .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
          .join();
}

String _toPascalCase(String value) {
  return value
      .trim()
      .split('_')
      .where((e) => e.isNotEmpty)
      .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
      .join();
}
