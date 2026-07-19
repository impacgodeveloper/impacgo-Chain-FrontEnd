import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../core/theme/ig_colors.dart';
import '../buttons/app_button.dart';
import '../forms/app_search_bar.dart';
import '../forms/app_dropdown_compact.dart';

/// Ported from `.toolbar` — the search + filter-toggle + page-size row at
/// the top of every list card.
class IgListToolbar extends StatelessWidget {
  const IgListToolbar({
    super.key,
    required this.searchHint,
    required this.searchValue,
    required this.onSearchChanged,
    required this.onToggleFilters,
    required this.pageSize,
    required this.pageSizeOptions,
    required this.onPageSizeChanged,
    this.extraActions = const [],
  });

  final String searchHint;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleFilters;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int?> onPageSizeChanged;
  final List<Widget> extraActions;

  @override
  Widget build(BuildContext context) {
    final leadingControls = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppSearchBar(
          hintText: searchHint,
          value: searchValue,
          onChanged: onSearchChanged,
        ),
        AppButton(
          label: 'Filters',
          icon: FeatherIcons.filter,
          size: AppButtonSize.sm,
          onPressed: onToggleFilters,
        ),
        ...extraActions,
      ],
    );
    final pageSizeSelect = AppDropdownCompact<int>(
      value: pageSize,
      onChanged: onPageSizeChanged,
      items: pageSizeOptions
          .map((n) => DropdownMenuItem(value: n, child: Text('$n / page')))
          .toList(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: IgColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 480) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [leadingControls, pageSizeSelect],
            );
          }
          return Row(
            children: [
              Expanded(child: leadingControls),
              const SizedBox(width: 8),
              pageSizeSelect,
            ],
          );
        },
      ),
    );
  }
}
