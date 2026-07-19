import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../icons/app_icon.dart';

/// Ported from `.empty-state` — shown by list/table views and report views
/// when there is no data to display.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final String icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: .5,
            child: AppIcon(icon, size: 44, color: IgColors.textFaint),
          ),
          const SizedBox(height: 10),
          Text(title, style: AppTypography.emptyStateTitle),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.hint,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
