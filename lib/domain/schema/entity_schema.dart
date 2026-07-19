import 'column_def.dart';
import 'field_def.dart';

/// Ported from one `defEntity(key, {...})` call in full — extends the
/// Phase 5 [EntityNavItem] (key/label/icon/group) with everything the
/// Phase 6 list/detail/form engine needs: columns, fields, and the
/// primary/sub/number key conventions used throughout `renderDrawer()` /
/// `renderListView()` (`rec[def.primary]`, `rec[def.sub]`, `rec[def.number]`).
class EntitySchema {
  const EntitySchema({
    required this.key,
    required this.columns,
    required this.fields,
    required this.primaryKey,
    this.subKey,
    required this.numberKey,
    this.approval = false,
    this.workflow,
    this.step,
  });

  final String key;
  final List<ColumnDef> columns;
  final List<FieldDef> fields;

  /// Ported from `def.primary` — the field used as a record's title (e.g.
  /// `code` for documents, `name` for masters).
  final String primaryKey;

  /// Ported from `def.sub` — the field shown as a record's subtitle.
  final String? subKey;

  /// Ported from `def.number` — the field used as a record's short
  /// identifier (usually `code`).
  final String numberKey;

  /// Ported from `def.approval` — whether this entity has a
  /// Draft → Pending Approval → Approved/Rejected workflow.
  final bool approval;

  /// Ported from `def.workflow` — which [Workflow] (if any) this entity is
  /// a step of.
  final String? workflow;

  /// Ported from `def.step` — this entity's step label within its workflow.
  final String? step;

  FieldDef? get statusField => fields.where((f) => f.key == 'status').firstOrNull;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
