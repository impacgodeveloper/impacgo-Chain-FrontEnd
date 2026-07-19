import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';

/// Ported from `#topnav` — the fixed 56px primary-colored top bar. Purely
/// structural; Phase 5 supplies the actual logo/switchers/search/profile
/// content as [children].
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: IgDimensions.topNavHeight,
      padding: const EdgeInsets.fromLTRB(10, 0, 14, 0),
      decoration: BoxDecoration(
        color: IgColors.surface,
        border: const Border(
          bottom: BorderSide(color: IgColors.border),
        ),
      ),
      child: Row(children: children),
    );
  }
}
