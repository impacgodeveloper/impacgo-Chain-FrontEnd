import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import '../../domain/entities/entity_record.dart';
import '../mock/mock_database.dart';

/// Ported from `triggerImport(key)` — picks a `.csv` file and inserts one
/// record per row, matching the prototype's naive comma-split parser
/// (no quoted-comma handling, same as the original).
abstract final class CsvImportService {
  static Future<int?> pickAndImport(MockDatabase db, String entityKey) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final bytes = result.files.first.bytes;
    if (bytes == null) return null;

    final content = utf8.decode(bytes);
    final lines = content.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.length < 2) return 0;

    final headers = lines.first.split(',').map((h) => h.replaceAll('"', '').trim()).toList();
    var count = 0;
    for (var i = 1; i < lines.length; i++) {
      final cells = lines[i].split(',').map((c) => c.replaceAll('"', '').trim()).toList();
      final row = <String, dynamic>{'id': db.nextRuntimeId(), 'createdAt': DateTime.now()};
      for (var h = 0; h < headers.length && h < cells.length; h++) {
        row[headers[h]] = cells[h];
      }
      db.insert(entityKey, EntityRecord(row));
      count++;
    }
    return count;
  }
}
