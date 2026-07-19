import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.filters-panel` — a collapsible row of filter fields shown
/// under the toolbar when "Filters" is toggled.
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({super.key, required this.visible, required this.fields});

  final bool visible;
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: !visible
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: IgColors.surfaceAlt,
                border: Border(bottom: BorderSide(color: IgColors.border)),
              ),
              child: Wrap(spacing: 10, runSpacing: 10, children: fields),
            ),
    );
  }
}

/// Ported from `.filter-field` — a labeled filter control (typically an
/// [AppDropdownCompact]).
class AppFilterField extends StatelessWidget {
  const AppFilterField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppTypography.fieldLabel),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
