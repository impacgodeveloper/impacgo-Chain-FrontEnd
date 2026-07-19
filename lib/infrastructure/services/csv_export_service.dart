import '../../core/utilities/formatters.dart';
import '../../domain/entities/entity_record.dart';
import '../../domain/schema/column_def.dart';
import 'csv_export_stub.dart' if (dart.library.html) 'csv_export_web.dart';

/// Ported from `doExport(key,rows)` — builds a CSV from the entity's
/// columns and triggers a browser download.
abstract final class CsvExportService {
  static void export(String entityKey, List<ColumnDef> columns, List<EntityRecord> rows) {
    final header = columns.map((c) => c.label).join(',');
    final lines = rows.map((r) {
      return columns.map((c) {
        final v = c.rawValue(r);
        final text = switch (v) {
          null => '',
          DateTime d => Formatters.date(d),
          _ => '$v',
        };
        return '"${text.replaceAll('"', '""')}"';
      }).join(',');
    });
    final csv = [header, ...lines].join('\n');

    saveCsv(csv, '${entityKey}_export.csv');
  }
}
