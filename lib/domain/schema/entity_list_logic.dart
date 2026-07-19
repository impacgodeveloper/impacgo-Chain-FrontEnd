import '../entities/entity_list_state.dart';
import '../entities/entity_record.dart';
import 'entity_schema.dart';

/// Ported from `filterAndSort(key)` — search across all columns, apply
/// active filters, then sort by the active column/direction.
List<EntityRecord> filterAndSortRecords(
  List<EntityRecord> data,
  EntitySchema schema,
  EntityListState state,
) {
  var out = List<EntityRecord>.from(data);

  if (state.search.isNotEmpty) {
    final q = state.search.toLowerCase();
    out = out.where((r) {
      return schema.columns.any((c) {
        final v = c.rawValue(r);
        if (v == null) return false;
        return '$v'.toLowerCase().contains(q);
      });
    }).toList();
  }

  state.filters.forEach((field, value) {
    if (value.isEmpty) return;
    out = out.where((r) => '${r[field]}' == value).toList();
  });

  if (state.sortKey != null) {
    final col = schema.columns.where((c) => c.key == state.sortKey).firstOrNull;
    out.sort((a, b) {
      final av = col != null ? col.rawValue(a) : a[state.sortKey!];
      final bv = col != null ? col.rawValue(b) : b[state.sortKey!];
      final cmp = _compare(av, bv);
      return cmp * state.sortDir;
    });
  }

  return out;
}

int _compare(dynamic a, dynamic b) {
  if (a == null && b == null) return 0;
  if (a == null) return -1;
  if (b == null) return 1;
  if (a is DateTime && b is DateTime) return a.compareTo(b);
  if (a is num && b is num) return a.compareTo(b);
  return a.toString().compareTo(b.toString());
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
