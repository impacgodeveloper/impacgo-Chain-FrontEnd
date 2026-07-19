/// A single sidebar/route entry for a transactional entity, ported from one
/// `defEntity(key, {label, icon, group, ...})` call plus its membership in
/// `MODULE_TREE`.
///
/// [icon] is the exact `ICON_PATHS` key from the prototype (see
/// `AppIconPaths`) — not a Material/Feather icon name — so every glyph
/// renders as the prototype's literal hand-drawn SVG path.
class EntityNavItem {
  const EntityNavItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.group,
  });

  final String key;
  final String label;
  final String icon;
  final String group;

  /// Singularized label for "New {X}" actions, ported from
  /// `def.label.replace(/s$/,'')`.
  String get singularLabel => label.endsWith('s') ? label.substring(0, label.length - 1) : label;
}

/// A sidebar module group, ported from one `MODULE_TREE` entry.
class NavGroup {
  const NavGroup({required this.label, required this.icon, required this.items});

  final String label;
  final String icon;
  final List<EntityNavItem> items;
}

/// A single report entry, ported from one `REPORTS` definition plus its
/// membership in `REPORT_TREE`.
class ReportNavItem {
  const ReportNavItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.reportGroup,
  });

  final String key;
  final String label;
  final String icon;
  final String reportGroup;
}

/// A report sub-section header under the sidebar's "Reports" group, ported
/// from one `REPORT_TREE` entry.
class ReportNavSection {
  const ReportNavSection({required this.group, required this.items});

  final String group;
  final List<ReportNavItem> items;
}
