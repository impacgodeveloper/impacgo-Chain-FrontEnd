import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `#sidebar` / `#sidebar.collapsed` — animates between 264px
/// and 64px (`transition:width .18s ease`), with a scrollable body and a
/// footer that hides while collapsed.
class AppSidebarContainer extends StatelessWidget {
  const AppSidebarContainer({
    super.key,
    required this.collapsed,
    required this.body,
    this.footerText,
    this.logoHeader,
  });

  final bool collapsed;
  final Widget body;
  final String? footerText;
  /// Optional widget shown at the top of the sidebar (e.g. brand logo).
  final Widget? logoHeader;

  @override
  Widget build(BuildContext context) {
    final width = collapsed
        ? IgDimensions.sidebarWidthCollapsed
        : IgDimensions.sidebarWidth;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Dark slate/navy background
        border: Border(right: BorderSide(color: Color(0xFF1E293B))),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          if (logoHeader != null) logoHeader!,
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                primary: true,
                padding: const EdgeInsets.fromLTRB(8, 24, 8, 20),
                child: body,
              ),
            ),
          ),
          if (!collapsed && footerText != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Text(
                footerText!,
                textAlign: TextAlign.center,
                style: AppTypography.sidebarFooter.copyWith(
                  color: const Color(0xFF475569),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
