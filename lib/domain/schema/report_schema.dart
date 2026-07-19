import '../entities/entity_record.dart';
import '../../infrastructure/mock/mock_database.dart';
import 'column_def.dart';

/// Ported from one `REPORTS[key]` entry — a read-only, computed view (no
/// toolbar/filters/pagination, unlike [EntitySchema]).
class ReportSchema {
  const ReportSchema({required this.key, required this.columns, required this.compute});

  final String key;
  final List<ColumnDef> columns;

  /// Ported from `def.compute()` — derives the report's rows from the live
  /// mock DB rather than reading a table directly.
  final List<EntityRecord> Function(MockDatabase db) compute;
}
