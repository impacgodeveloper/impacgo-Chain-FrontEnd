import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.form-field` — a labeled dialog form field, optionally
/// required (`label .req` renders in danger red) and optionally spanning
/// both columns of the parent [IgFormGrid] (`.form-field.full`).
class IgFormField extends StatelessWidget {
  const IgFormField({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.full = false,
  });

  final String label;
  final Widget child;
  final bool required;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.formLabel,
            children: [
              TextSpan(text: label),
              if (required)
                TextSpan(text: ' *', style: AppTypography.formLabelRequired),
            ],
          ),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
    return full ? SizedBox(width: double.infinity, child: field) : field;
  }
}

/// Ported from `.form-grid` — a 2-column grid, 12px row gap / 16px column
/// gap. `.form-field.full` items span both columns.
class IgFormGrid extends StatelessWidget {
  const IgFormGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final narrow = constraints.maxWidth < 500;
        final colWidth = narrow ? constraints.maxWidth : (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: 12,
          children: [
            for (final child in children)
              SizedBox(
                width: child is IgFormField && child.full ? constraints.maxWidth : colWidth,
                child: child,
              ),
          ],
        );
      },
    );
  }
}
