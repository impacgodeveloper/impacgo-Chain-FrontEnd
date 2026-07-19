import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/ig_shadows.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.dialog.wide` / `.dialog` / `.dialog.narrow` widths.
enum AppDialogSize { narrow, standard, wide }

/// Ported from `#dialog-overlay` + `.dialog` — a top-aligned modal
/// (`align-items:flex-start` with 40px top padding) over a translucent
/// backdrop, with width variants matching `.dialog(.wide|.narrow)`.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  AppDialogSize size = AppDialogSize.standard,
}) {
  final width = switch (size) {
    AppDialogSize.narrow => IgDimensions.dialogWidthNarrow,
    AppDialogSize.standard => IgDimensions.dialogWidth,
    AppDialogSize.wide => IgDimensions.dialogWidthWide,
  };

  return showGeneralDialog<T>(
    context: rootNavigatorKey.currentContext ?? context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: const Color(0x660F172A), // rgba(15,23,42,.4)
    transitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Container(
                decoration: const BoxDecoration(
                  color: IgColors.surface,
                  borderRadius: IgRadii.rLg,
                  boxShadow: IgShadows.lg,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: IgRadii.rLg,
                  clipBehavior: Clip.antiAlias,
                  child: builder(context),
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Ported from `.dialog-head` — title + close button, border-bottom.
class AppDialogHead extends StatelessWidget {
  const AppDialogHead({super.key, required this.title, this.onClose});

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: IgColors.border)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTypography.dialogTitle)),
          IconButton(
            onPressed: onClose ?? () => Navigator.of(context).pop(),
            icon: const Icon(FeatherIcons.x, size: 18),
            color: IgColors.textSoft,
            style: IconButton.styleFrom(
              backgroundColor: IgColors.surfaceAlt,
              minimumSize: const Size(28, 28),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ported from `.dialog-body` — scrollable content area, `max-height:70vh`.
class AppDialogBody extends StatelessWidget {
  const AppDialogBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: child,
      ),
    );
  }
}

/// Ported from `.dialog-foot` — right-aligned action row, border-top.
class AppDialogFoot extends StatelessWidget {
  const AppDialogFoot({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: IgColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            actions[i],
          ],
        ],
      ),
    );
  }
}
