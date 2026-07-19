import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entity_list_state.dart';

/// Ported from `getListState(key)` / `setSearch` / `setSort` / `setPage` /
/// `setPageSize` / `setFilter` / `toggleSelectRow` / `toggleSelectAll` — one
/// independent list-view state per entity key.
class EntityListStateNotifier extends FamilyNotifier<EntityListState, String> {
  @override
  EntityListState build(String arg) => const EntityListState();

  void setSearch(String value) => state = state.copyWith(search: value, page: 1);

  void setSort(String columnKey) {
    if (state.sortKey == columnKey) {
      state = state.copyWith(sortDir: state.sortDir * -1);
    } else {
      state = state.copyWith(sortKey: columnKey, sortDir: 1);
    }
  }

  void setPage(int page) => state = state.copyWith(page: page);

  void setPageSize(int size) => state = state.copyWith(pageSize: size, page: 1);

  void setFilter(String field, String value) {
    final next = {...state.filters};
    if (value.isEmpty) {
      next.remove(field);
    } else {
      next[field] = value;
    }
    state = state.copyWith(filters: next, page: 1);
  }

  void toggleSelectRow(int id, bool checked) {
    final next = {...state.selected};
    if (checked) {
      next.add(id);
    } else {
      next.remove(id);
    }
    state = state.copyWith(selected: next);
  }

  void setSelectedIds(Iterable<int> ids, bool checked) {
    final next = {...state.selected};
    if (checked) {
      next.addAll(ids);
    } else {
      next.removeAll(ids);
    }
    state = state.copyWith(selected: next);
  }

  void clearSelection() => state = state.copyWith(selected: {});
}

final entityListStateProvider =
    NotifierProvider.family<EntityListStateNotifier, EntityListState, String>(
  EntityListStateNotifier.new,
);
