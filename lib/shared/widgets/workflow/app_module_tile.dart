import 'package:flutter/material.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/ig_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../icons/app_icon.dart';

/// Ported from `.tile` / `.tile-icon` / `.tile-title` / `.tile-count` — one
/// entry in the home workspace's "All Modules" grid.
class AppModuleTile extends StatefulWidget {
  const AppModuleTile({
    super.key,
    required this.icon,
    required this.colorKey,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String colorKey;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<AppModuleTile> createState() => _AppModuleTileState();
}

class _AppModuleTileState extends State<AppModuleTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = IgColors.tileColors(widget.colorKey);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: IgColors.surface,
            borderRadius: IgRadii.rLg,
            border: Border.all(color: _hovered ? IgColors.borderStrong : IgColors.border),
            boxShadow: _hovered ? IgShadows.md : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34, height: 34, alignment: Alignment.center,
                decoration: BoxDecoration(color: bg, borderRadius: IgRadii.rMd),
                child: AppIcon(widget.icon, size: 17, color: fg),
              ),
              const SizedBox(height: 8),
              Text(widget.title, style: AppTypography.tileTitle),
              const SizedBox(height: 8),
              Text(widget.subtitle, style: AppTypography.tileCount, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
