import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Date picker field styled to match `.form-field input`, used everywhere
/// the prototype uses `<input type="date">` (delivery dates, due dates,
/// valid-till, etc).
class IgDateField extends StatelessWidget {
  const IgDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
        decoration: BoxDecoration(
          color: IgColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: IgColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value == null
                    ? 'Select date'
                    : DateFormat('MMM dd, yyyy').format(value!),
                style: value == null
                    ? AppTypography.formInputFaint
                    : AppTypography.formInput,
              ),
            ),
            Icon(FeatherIcons.calendar, size: 15, color: IgColors.textFaint),
          ],
        ),
      ),
    );
  }
}
