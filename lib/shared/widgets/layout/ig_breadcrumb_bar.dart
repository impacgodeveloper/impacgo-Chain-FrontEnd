import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';

/// Ported from `#breadcrumb-bar` — fixed 42px bar above the workspace.
class IgBreadcrumbBar extends StatelessWidget {
  const IgBreadcrumbBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: IgDimensions.breadcrumbBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: IgColors.surface,
        border: Border(bottom: BorderSide(color: IgColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      ),
    );
  }
}
