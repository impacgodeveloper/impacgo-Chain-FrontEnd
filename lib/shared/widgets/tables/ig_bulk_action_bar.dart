import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.bulkbar` — appears above the table once one or more rows
/// are selected, e.g. `{n} selected` + Export/Delete Selected actions.
class IgBulkActionBar extends StatelessWidget {
  const IgBulkActionBar({
    super.key,
    required this.selectedCount,
    required this.actions,
  });

  final int selectedCount;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: IgColors.surfaceAlt,
        border: Border(bottom: BorderSide(color: IgColors.border)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: AppTypography.pagination,
              children: [
                TextSpan(
                  text: '$selectedCount',
                  style: AppTypography.pagination.copyWith(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' selected'),
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
