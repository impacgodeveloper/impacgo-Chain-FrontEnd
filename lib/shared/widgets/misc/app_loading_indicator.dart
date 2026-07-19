import 'package:flutter/material.dart';

import '../../../core/theme/ig_colors.dart';

/// Small inline spinner for async actions (CSV import, etc.) that don't
/// have a prototype equivalent since the mock data layer is synchronous —
/// used only where a real `Future` is actually awaited.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.size = 14, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? IgColors.primary),
      ),
    );
  }
}
