import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.select-mini` — the compact dropdown used for page-size and
/// list-filter selects.
class AppDropdownCompact<T> extends StatelessWidget {
  const AppDropdownCompact({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: IgColors.surface,
        borderRadius: IgRadii.rMd,
        border: Border.all(color: IgColors.borderStrong),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isDense: true,
          style: AppTypography.formInput.copyWith(fontSize: 12, color: IgColors.text),
          icon: Icon(FeatherIcons.chevronDown, size: 16, color: IgColors.textFaint),
          dropdownColor: IgColors.surface,
          borderRadius: IgRadii.rMd,
        ),
      ),
    );
  }
}
