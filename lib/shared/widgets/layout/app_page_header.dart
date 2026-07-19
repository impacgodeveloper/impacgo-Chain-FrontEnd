import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import '../badges/ig_icon_badge.dart';

/// Ported from `.page-head` — icon badge + title + subtitle on the left,
/// action buttons on the right. `.page-head{display:flex;flex-wrap:wrap}`
/// means the title and actions each drop to their own full-width row under
/// space pressure rather than squeezing the title; the breakpoint below
/// reproduces that since Flutter's `Row` has no native flex-wrap.
///
/// Shared by every entity list page and the read-only report pages so the
/// header behaves identically everywhere.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actions,
  });

  final String title;
  final String subtitle;
  final String icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IgIconBadge(icon: icon),
            const SizedBox(width: 10),
            Flexible(child: Text(title, style: AppTypography.pageTitle)),
          ],
        ),
        const SizedBox(height: 3),
        Text(subtitle, style: AppTypography.pageSub),
      ],
    );

    final actionsBlock = Wrap(spacing: 8, runSpacing: 8, children: actions);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleBlock, const SizedBox(height: 12), actionsBlock],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: titleBlock), actionsBlock],
        );
      },
    );
  }
}
