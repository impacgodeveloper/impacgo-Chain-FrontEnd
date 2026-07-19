import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_typography.dart';
import '../../core/theme/ig_colors.dart';
import '../../application/providers/topnav_providers.dart';
import '../../application/providers/sidebar_providers.dart';
import '../../shared/widgets/layout/ig_app_shell.dart';
import '../../shared/widgets/layout/ig_workspace.dart';
import 'widgets/app_sidebar.dart';
import 'widgets/ig_app_breadcrumb.dart';
import 'widgets/ig_global_search_field.dart';
import 'widgets/app_top_bar_parts.dart';
import 'widgets/ig_topnav_popover_layer.dart';

import '../../core/theme/ig_dimensions.dart';

/// Ported from `#app` as a whole — wires the real navigation content
/// (topnav/sidebar/breadcrumb) built in Phase 5 into the structural
/// [IgAppShell] built in Phase 4. This is what [GoRouter]'s `ShellRoute`
/// renders around every routed page.
class MainShellScaffold extends ConsumerWidget {
  const MainShellScaffold({
    super.key,
    required this.currentPath,
    required this.child,
  });

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final company = ref.watch(selectedCompanyProvider);
    final branch = ref.watch(selectedBranchProvider);
    final collapsed = ref.watch(sidebarCollapsedProvider);
    
    final width = MediaQuery.of(context).size.width;
    final narrow = width < IgDimensions.breakpointTablet;
    final logoCollapsed = !narrow && collapsed;

    return IgAppShell(
      sidebarLogoHeader: AppTopBarLogo(collapsed: logoCollapsed),
      topNavChildren: [
        const SizedBox(width: 8),
        AppSidebarToggleButton(),
        const SizedBox(width: 12),
        // On narrow screens: brand name fills available space (Expanded so it
        // compresses via ellipsis instead of causing a RenderFlex overflow).
        // On very narrow (<400px) there's no room for search, show Spacer instead.
        if (narrow) ...[
          Expanded(child: const _TopNavBrand()),
          const SizedBox(width: 8),
        ],
        // Search — only shown on wider narrow screens or on desktop
        if (!narrow || width >= 400)
          Expanded(
            flex: narrow ? 1 : 5,
            child: const IgGlobalSearchField(),
          ),
        if (!narrow) ...[
          const SizedBox(width: 16), // small fixed gap
          Expanded(
            flex: 3,
            child: AppTopBarSwitchButton(
              label: 'Company',
              value: company.name,
              popoverKey: 'company',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: AppTopBarSwitchButton(
              label: 'Branch',
              value: branch,
              popoverKey: 'branch',
            ),
          ),
          const SizedBox(width: 12),
        ] else
          const SizedBox(width: 8), // gap before bell on mobile
        AppTopBarIconButton(
          icon: FeatherIcons.bell,
          tooltip: 'Notifications',
          badgeCount: notifications.length,
          onTap: () {
            final current = ref.read(activePopoverProvider);
            ref.read(activePopoverProvider.notifier).state = current == 'notif'
                ? null
                : 'notif';
          },
        ),
        const SizedBox(width: 8),
        const AppTopBarProfileButton(),
      ],
      sidebarBody: AppSidebar(currentPath: currentPath),
      sidebarFooterText: 'IMPACGO CHAIN v2.4 · Flutter Port',
      breadcrumbChildren: buildBreadcrumbChildren(context, currentPath),
      workspace: IgWorkspace(child: child),
      overlayChildren: const [AppTopBarPopoverLayer()],
    );
  }
}

/// Compact brand badge shown in the top nav bar on narrow (mobile) screens
/// so the app name is always visible even when the sidebar is a Drawer.
class _TopNavBrand extends StatelessWidget {
  const _TopNavBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2F6FED),
          ),
          child: Text(
            'IC',
            style: AppTypography.tnLogoMark,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'IMPACGO CHAIN',
            style: AppTypography.tnLogo.copyWith(color: IgColors.text),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
