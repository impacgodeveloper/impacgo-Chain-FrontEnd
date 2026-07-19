import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/sidebar_providers.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';
import 'ig_breadcrumb_bar.dart';
import 'app_sidebar_container.dart';
import 'ig_toast.dart';
import 'app_top_bar.dart';

/// Ported from `#app` (`#topnav` + `#main` [`#sidebar` + `#content-area`
/// [`#breadcrumb-bar` + `#workspace`]]).
///
/// Below [IgDimensions.breakpointTablet] the persistent sidebar becomes a
/// Material [Drawer] opened from the top nav, since the prototype itself
/// targets desktop and doesn't define a narrow-viewport sidebar behavior —
/// this is the standard enterprise-app equivalent ("Sidebar responsive").
class IgAppShell extends ConsumerWidget {
  const IgAppShell({
    super.key,
    required this.topNavChildren,
    required this.sidebarBody,
    required this.breadcrumbChildren,
    required this.workspace,
    this.sidebarFooterText,
    this.sidebarLogoHeader,
    this.overlayChildren = const [],
  });

  final List<Widget> topNavChildren;
  final Widget sidebarBody;
  final String? sidebarFooterText;
  final Widget? sidebarLogoHeader;
  final List<Widget> breadcrumbChildren;
  final Widget workspace;

  /// Extra widgets stacked above everything else, screen-positioned
  /// (typically via [Positioned]) — used for the topnav popovers
  /// (`.tn-pop` is `position:absolute` on `#app`, not scoped to the topnav).
  final List<Widget> overlayChildren;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final narrow = screenWidth < IgDimensions.breakpointTablet;

    final breadcrumbBar = IgBreadcrumbBar(children: breadcrumbChildren);
    final content = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          breadcrumbBar,
          Expanded(child: workspace),
        ],
      ),
    );

    final mainBody = narrow
        ? Scaffold(
            backgroundColor: IgColors.bg,
            drawer: Drawer(
              width: IgDimensions.sidebarWidth,
              child: SafeArea(
                child: AppSidebarContainer(
                  collapsed: false,
                  body: sidebarBody,
                  footerText: sidebarFooterText,
                  logoHeader: sidebarLogoHeader,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TapRegion(
                  groupId: 'topnav_popovers',
                  child: AppTopBar(children: topNavChildren),
                ),
                content,
              ],
            ),
          )
        : Material(
            color: IgColors.bg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSidebarContainer(
                  collapsed: collapsed,
                  body: sidebarBody,
                  footerText: sidebarFooterText,
                  logoHeader: sidebarLogoHeader,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TapRegion(
                        groupId: 'topnav_popovers',
                        child: AppTopBar(children: topNavChildren),
                      ),
                      content,
                    ],
                  ),
                ),
              ],
            ),
          );

    return Stack(
      fit: StackFit.expand,
      children: [
        mainBody,
        ...overlayChildren,
        const IgToastStack(),
      ],
    );
  }
}
