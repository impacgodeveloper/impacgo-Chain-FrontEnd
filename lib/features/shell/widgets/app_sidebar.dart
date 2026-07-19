import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers/sidebar_providers.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/schema/nav_registry.dart';
import '../../../shared/widgets/icons/app_icon.dart';
import 'app_top_bar_parts.dart';

/// Ported from `renderSidebar()` — the "SCM Workspace" home item, the
/// [NavRegistry.moduleTree] groups, and the "Reports" group with its
/// [NavRegistry.reportTree] sub-sections.
///
/// When collapsed, sub-items are hidden entirely (`.sb-group-items{display:
/// none !important}` in the prototype) — this is a 1:1 port of that
/// behavior, not a simplification.
class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key, required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final expandedGroups = ref.watch(sidebarExpandedGroupsProvider);
    final notifier = ref.read(sidebarExpandedGroupsProvider.notifier);

    final activeEntityKey = currentPath.startsWith('/entity/')
        ? currentPath.substring('/entity/'.length)
        : null;
    final activeReportKey = currentPath.startsWith('/reports/')
        ? currentPath.substring('/reports/'.length)
        : null;
    final isHome = currentPath == '/';

    // Auto-expand active group post frame
    String? activeGroup;
    for (final group in NavRegistry.moduleTree) {
      if (group.items.any((item) => item.key == activeEntityKey)) {
        activeGroup = group.label;
        break;
      }
    }
    if (activeGroup != null && !expandedGroups.contains(activeGroup)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sidebarExpandedGroupsProvider.notifier).expandGroup(activeGroup!);
      });
    }

    final hasActiveReport = NavRegistry.reportTree.any(
      (section) => section.items.any((report) => report.key == activeReportKey),
    );
    if (hasActiveReport && !expandedGroups.contains('Reports')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sidebarExpandedGroupsProvider.notifier).expandGroup('Reports');
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HomeItem(
          collapsed: collapsed,
          active: isHome,
          onTap: () => context.go('/'),
        ),
        for (final group in NavRegistry.moduleTree)
          _GroupSection(
            label: group.label,
            icon: group.icon,
            collapsed: collapsed,
            open: expandedGroups.contains(group.label),
            onToggle: () {
              if (collapsed) {
                ref.read(sidebarCollapsedProvider.notifier).toggle();
              }
              notifier.toggleGroup(group.label);
              final isCurrentlyOpen = expandedGroups.contains(group.label);
              final containsActive = group.items.any((item) => item.key == activeEntityKey);
              if (isCurrentlyOpen && containsActive) {
                context.go('/');
              }
            },
            children: [
              for (final item in group.items)
                _NavItem(
                  label: item.label,
                  icon: item.icon,
                  active: item.key == activeEntityKey,
                  onTap: () => context.go('/entity/${item.key}'),
                ),
            ],
          ),
        _GroupSection(
          label: 'Reports',
          icon: 'barChart2',
          collapsed: collapsed,
          open: expandedGroups.contains('Reports'),
          onToggle: () {
            if (collapsed) {
              ref.read(sidebarCollapsedProvider.notifier).toggle();
            }
            notifier.toggleGroup('Reports');
            final isCurrentlyOpen = expandedGroups.contains('Reports');
            if (isCurrentlyOpen && hasActiveReport) {
              context.go('/');
            }
          },
          children: [
            for (final section in NavRegistry.reportTree) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 6, 10, 2),
                child: Text(
                  section.group.toUpperCase(),
                  style: AppTypography.sidebarReportGroupLabel.copyWith(
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
              for (final report in section.items)
                _NavItem(
                  label: report.label,
                  icon: report.icon,
                  active: report.key == activeReportKey,
                  onTap: () => context.go('/reports/${report.key}'),
                ),
            ],
          ],
        ),
      ],
    );
  }
}

/// `.sb-home` has no `.active` variant in the prototype CSS — it always
/// renders with the `--ig-primary-soft`/`--ig-primary` highlight regardless
/// of the current route.
class _HomeItem extends StatelessWidget {
  const _HomeItem({
    required this.collapsed,
    required this.active,
    required this.onTap,
  });

  final bool collapsed;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
      child: InkWell(
        borderRadius: IgRadii.rMd,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 9 : 10,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
            borderRadius: IgRadii.rMd,
          ),
          child: ClipRect(
            child: IntrinsicHeight(
              child: OverflowBox(
                minWidth: 0,
                maxWidth: 240,
                alignment: collapsed ? Alignment.center : Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: collapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      FeatherIcons.grid,
                      size: 20,
                      color: active ? Colors.white : const Color(0xFF60A5FA),
                    ),
                    if (!collapsed) ...[
                      const SizedBox(width: 10),
                      Text(
                        'SCM Workspace',
                        style: AppTypography.sidebarHome.copyWith(
                          color: active ? Colors.white : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.label,
    required this.icon,
    required this.collapsed,
    required this.open,
    required this.onToggle,
    required this.children,
  });

  final String label;
  final String icon;
  final bool collapsed;
  final bool open;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: IgRadii.rSm,
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 9 : 10,
              vertical: 8,
            ),
            child: ClipRect(
              child: IntrinsicHeight(
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: 240,
                  alignment: collapsed ? Alignment.center : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: collapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      AppIcon(icon, size: 16, color: const Color(0xFF64748B)),
                      if (!collapsed) ...[
                        const SizedBox(width: 8),
                        // Keep explicit width or constraints to prevent Expanded in horizontal ScrollView/OverflowBox issues
                        SizedBox(
                          width: 190,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  label.toUpperCase(),
                                  style: AppTypography.sidebarGroupHead.copyWith(
                                    color: const Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Transform.rotate(
                                angle: open ? 1.5708 : 0, // 90 degrees in radians
                                child: const Icon(
                                  FeatherIcons.chevronRight,
                                  size: 16,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (!collapsed && open)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: IgRadii.rSm,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.fromLTRB(26, 7, 10, 7),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: IgRadii.rSm,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (active)
              Positioned(
                left: -18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF60A5FA),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ClipRect(
              child: IntrinsicHeight(
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: 240,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 220,
                    child: Row(
                      children: [
                        AppIcon(
                          icon,
                          size: 16,
                          color: active ? Colors.white : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.sidebarItem.copyWith(
                              color: active ? Colors.white : const Color(0xFF94A3B8),
                              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
