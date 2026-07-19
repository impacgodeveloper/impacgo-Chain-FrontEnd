/// Ported from the prototype's loose per-entity JS objects (e.g. a row in
/// `DB.customers`). Since the whole engine is schema-driven — every screen
/// reads fields dynamically via `schema.columns`/`schema.fields` rather than
/// through typed properties — a `Map`-backed record mirrors that
/// architecture 1:1 instead of forcing 49 separate generated model classes
/// onto a system that is deliberately dynamic.
class EntityRecord {
  EntityRecord(Map<String, dynamic> data) : _data = Map<String, dynamic>.from(data);

  final Map<String, dynamic> _data;

  int get id => _data['id'] as int;
  DateTime get createdAt => _data['createdAt'] as DateTime;
  String? get status => _data['status'] as String?;

  dynamic operator [](String key) => _data[key];
  void operator []=(String key, dynamic value) => _data[key] = value;

  bool containsKey(String key) => _data.containsKey(key);

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(_data);

  EntityRecord copyWith(Map<String, dynamic> patch) =>
      EntityRecord({..._data, ...patch});
}
