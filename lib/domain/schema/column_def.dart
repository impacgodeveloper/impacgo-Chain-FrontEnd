import '../entities/entity_record.dart';

/// Ported from a column entry in `defEntity(...).columns` — `{k, l, t,
/// compute}`. `type` mirrors `fieldDisplay(col, rec)`'s formatting switch.
enum ColumnType { text, money, date, status, pct, numraw }

class ColumnDef {
  const ColumnDef({
    required this.key,
    required this.label,
    this.type = ColumnType.text,
    this.compute,
  });

  final String key;
  final String label;
  final ColumnType type;

  /// Ported from `col.compute` — derives a display value from the whole
  /// record instead of reading `rec[col.k]` directly (e.g. computed stock
  /// totals).
  final dynamic Function(EntityRecord rec)? compute;

  dynamic rawValue(EntityRecord rec) => compute != null ? compute!(rec) : rec[key];
}
