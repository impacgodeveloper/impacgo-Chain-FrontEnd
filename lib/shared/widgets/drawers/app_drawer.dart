import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';
import '../../../core/theme/ig_shadows.dart';

/// Ported from `#drawer-overlay` + `#drawer` — a right-edge sliding panel
/// (560px, capped at 94% viewport width) over a translucent backdrop,
/// `right .22s ease` in CSS becomes a 220ms slide transition here.
///
/// Content is supplied by the caller via [builder] so Phase 6's detail
/// drawer (head / tabs / overview / timeline / attachments / comments /
/// audit) can be layered on top of this purely structural shell.
Future<T?> showAppDrawer<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: rootNavigatorKey.currentContext ?? context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: const Color(0x590F172A), // rgba(15,23,42,.35)
    transitionDuration: const Duration(milliseconds: 120),
    pageBuilder: (context, animation, secondaryAnimation) {
      final screenWidth = MediaQuery.of(context).size.width;
      final width = screenWidth * 0.94 < IgDimensions.drawerWidth
          ? screenWidth * 0.94
          : IgDimensions.drawerWidth;
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: IgColors.surface,
                boxShadow: IgShadows.lg,
              ),
              child: builder(context),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
        child: child,
      );
    },
  );
}

/// Ported from `.drawer-head` / `.drawer-tabs` / `.drawer-body` — the
/// structural regions inside [showAppDrawer]'s panel.
class AppDrawerScaffold extends StatelessWidget {
  const AppDrawerScaffold({super.key, required this.head, this.tabBar, required this.body});

  final Widget head;
  final Widget? tabBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        head,
        if (tabBar != null) tabBar!,
        Expanded(child: body),
      ],
    );
  }
}
