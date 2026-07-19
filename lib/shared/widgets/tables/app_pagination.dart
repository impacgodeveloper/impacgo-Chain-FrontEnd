import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.pagination` / `.pg-btn`. Text matches the prototype's
/// `Showing {from}–{to} of {total}` / `Page {page} of {totalPages}` copy.
class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalRecords,
    required this.onPageChanged,
  });

  final int page;
  final int pageSize;
  final int totalRecords;
  final ValueChanged<int> onPageChanged;

  int get totalPages => totalRecords == 0 ? 1 : ((totalRecords - 1) ~/ pageSize) + 1;

  @override
  Widget build(BuildContext context) {
    final from = totalRecords == 0 ? 0 : (page - 1) * pageSize + 1;
    final to = (page * pageSize).clamp(0, totalRecords);
    final tp = totalPages;

    final showingText = Text(
      'Showing $from–$to of $totalRecords',
      style: AppTypography.pagination,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
    final pageControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PgButton(
          label: 'Prev',
          enabled: page > 1,
          onTap: () => onPageChanged(page - 1),
        ),
        const SizedBox(width: 8),
        Text('Page $page of $tp', style: AppTypography.pagination),
        const SizedBox(width: 8),
        _PgButton(
          label: 'Next',
          enabled: page < tp,
          onTap: () => onPageChanged(page + 1),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 420) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [showingText, pageControls],
            );
          }
          return Row(
            children: [
              Expanded(child: showingText),
              pageControls,
            ],
          );
        },
      ),
    );
  }
}

class _PgButton extends StatefulWidget {
  const _PgButton({required this.label, required this.enabled, required this.onTap});

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_PgButton> createState() => _PgButtonState();
}

class _PgButtonState extends State<_PgButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1 : .4,
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.enabled ? widget.onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _hovered && widget.enabled ? IgColors.surfaceAlt : IgColors.surface,
              borderRadius: IgRadii.rSm,
              border: Border.all(color: IgColors.borderStrong),
            ),
            child: Text(widget.label, style: AppTypography.pagination),
          ),
        ),
      ),
    );
  }
}
