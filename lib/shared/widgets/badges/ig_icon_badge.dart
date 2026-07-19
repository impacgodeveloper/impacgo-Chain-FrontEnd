import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../icons/app_icon.dart';

/// Icon badge ported from `.page-title .icon-badge` / `.tile .tile-icon`:
/// a 34x34 rounded-square icon tile with a soft background tint.
class IgIconBadge extends StatelessWidget {
  const IgIconBadge({
    super.key,
    required this.icon,
    this.background,
    this.foreground,
    this.size = 34,
  });

  final String icon;
  final Color? background;
  final Color? foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? IgColors.primarySoft,
        borderRadius: IgRadii.rMd,
      ),
      child: AppIcon(icon, size: size * 0.5, color: foreground ?? IgColors.primary),
    );
  }
}
