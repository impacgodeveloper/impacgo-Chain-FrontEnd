import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/ig_shadows.dart';

/// Panel container ported from `.card`.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: IgColors.surface,
        borderRadius: IgRadii.rLg,
        border: Border.all(color: IgColors.border),
        boxShadow: IgShadows.sm,
      ),
      child: child,
    );
  }
}
