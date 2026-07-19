import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKeyCollapsed = 'ig_sidebar_collapsed';
const _prefsKeyExpandedGroups = 'ig_sidebar_expanded_groups';

/// Whether the sidebar is collapsed to icon-only rail width
/// (`#sidebar.collapsed`). Persisted via `shared_preferences` so the choice
/// survives a reload, matching the prototype's "remember expanded state".
class SidebarCollapsedNotifier extends Notifier<bool> {
  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_prefsKeyCollapsed) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyCollapsed, state);
  }
}

final sidebarCollapsedProvider =
    NotifierProvider<SidebarCollapsedNotifier, bool>(SidebarCollapsedNotifier.new);

/// Which sidebar groups (`.sb-group.open`) are expanded, keyed by group
/// label. Persisted the same way as [sidebarCollapsedProvider].
class SidebarExpandedGroupsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    _restore();
    return <String>{};
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getStringList(_prefsKeyExpandedGroups) ?? const []).toSet();
  }

  Future<void> toggleGroup(String group) async {
    final next = {...state};
    if (!next.remove(group)) next.add(group);
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKeyExpandedGroups, next.toList());
  }

  Future<void> expandGroup(String group) async {
    if (state.contains(group)) return;
    final next = {...state, group};
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKeyExpandedGroups, next.toList());
  }

  bool isOpen(String group) => state.contains(group);
}

final sidebarExpandedGroupsProvider =
    NotifierProvider<SidebarExpandedGroupsNotifier, Set<String>>(
  SidebarExpandedGroupsNotifier.new,
);
