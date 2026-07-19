import 'package:flutter/material.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.dv-section-title` — an uppercase divider label used to
/// break a card's content into sections (detail drawer overview, etc).
/// `first` drops the top border/margin (`.dv-section-title:first-child`).
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader(this.text, {super.key, this.first = false});

  final String text;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: first ? 0 : 18, bottom: 8),
      padding: EdgeInsets.only(top: first ? 0 : 12),
      decoration: BoxDecoration(
        border: first ? null : Border(top: BorderSide(color: IgColors.border)),
      ),
      child: Text(text.toUpperCase(), style: AppTypography.sectionTitle),
    );
  }
}
