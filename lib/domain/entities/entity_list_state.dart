/// Ported from `getListState(key)`'s `{page, pageSize, sort, sortDir,
/// search, filters, selected}` shape.
class EntityListState {
  const EntityListState({
    this.page = 1,
    this.pageSize = 10,
    this.sortKey,
    this.sortDir = 1,
    this.search = '',
    this.filters = const {},
    this.selected = const {},
  });

  final int page;
  final int pageSize;
  final String? sortKey;
  final int sortDir;
  final String search;
  final Map<String, String> filters;
  final Set<int> selected;

  EntityListState copyWith({
    int? page,
    int? pageSize,
    String? sortKey,
    bool clearSortKey = false,
    int? sortDir,
    String? search,
    Map<String, String>? filters,
    Set<int>? selected,
  }) {
    return EntityListState(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortKey: clearSortKey ? null : (sortKey ?? this.sortKey),
      sortDir: sortDir ?? this.sortDir,
      search: search ?? this.search,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
    );
  }
}
