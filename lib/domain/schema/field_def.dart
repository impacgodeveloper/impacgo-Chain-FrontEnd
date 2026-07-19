import '../../infrastructure/mock/mock_database.dart';

/// Ported from a field entry in `defEntity(...).fields` — `{k, l, t, req,
/// opts, optsFn}`.
enum FieldType { text, select, number, date, textarea }

class FieldDef {
  const FieldDef({
    required this.key,
    required this.label,
    this.type = FieldType.text,
    this.required = false,
    this.options = const [],
    this.optionsFn,
  });

  final String key;
  final String label;
  final FieldType type;
  final bool required;

  /// Static option list, ported from `f.opts`.
  final List<String> options;

  /// Dynamic option list derived from the mock DB at render time, ported
  /// from `f.optsFn` (e.g. `()=>DB.customers.map(c=>c.name)`).
  final List<String> Function(MockDatabase db)? optionsFn;

  List<String> resolveOptions(MockDatabase db) {
    if (optionsFn != null) return optionsFn!(db);
    return options;
  }
}
