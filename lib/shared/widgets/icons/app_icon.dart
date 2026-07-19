import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_icon_paths.dart';
import '../../../core/theme/ig_colors.dart';

/// Ported from the prototype's `svg.icon` rule
/// (`width:18px;height:18px;stroke:currentColor;stroke-width:1.8;fill:none;
/// stroke-linecap:round;stroke-linejoin:round`) and `iconSvg(name)` —
/// renders the exact hand-drawn path for [name] from [AppIconPaths],
/// pixel-for-pixel, rather than a Material/Feather icon-font approximation.
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 18, this.color, this.strokeWidth = 1.8});

  final String name;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? IconTheme.of(context).color ?? IgColors.text;
    final hex = '#${resolvedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    final path = (AppIconPaths.paths[name] ?? AppIconPaths.paths['folder']!)
        .replaceAll('currentColor', hex);
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" '
        'stroke="$hex" stroke-width="$strokeWidth" stroke-linecap="round" '
        'stroke-linejoin="round">$path</svg>';
    return SvgPicture.string(svg, width: size, height: size);
  }
}
