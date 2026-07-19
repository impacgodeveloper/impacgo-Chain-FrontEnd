import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.form-field select` — same padding/border/radius/font as
/// [AppTextField] so a select reads identically to a text input in a form.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
      decoration: BoxDecoration(
        color: IgColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IgColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          isDense: true,
          hint: hintText == null
              ? null
              : Text(hintText!, style: AppTypography.formInputFaint),
          style: AppTypography.formInput,
          icon: Icon(
            FeatherIcons.chevronDown,
            size: 18,
            color: IgColors.textFaint,
          ),
          dropdownColor: IgColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
