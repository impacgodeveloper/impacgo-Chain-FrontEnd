import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Status chip ported from `.chip` / `.chip.c-*`.
///
/// Colors: gray, green, amber, red, blue, teal, purple — matching
/// `chipColor(status)` in the prototype's status→color heuristic.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({super.key, required this.label, this.colorKey = 'gray'});

  final String label;
  final String colorKey;

  /// Ports `chipColor(status)`: maps a free-text status string to one of the
  /// seven chip color keys via keyword matching.
  factory AppStatusChip.forStatus(String? status) {
    if (status == null || status.isEmpty) {
      return const AppStatusChip(label: '—', colorKey: 'gray');
    }
    return AppStatusChip(label: status, colorKey: _resolveColorKey(status));
  }

  static String _resolveColorKey(String status) {
    final s = status.toLowerCase();
    bool any(List<String> keys) => keys.any(s.contains);

    if (any(const [
      'approved', 'active', 'completed', 'delivered', 'paid', 'cleared',
      'won', 'closed', 'received', 'accepted', 'confirmed', 'converted',
      'putaway complete', 'picked', 'packed', 'ready to ship', 'allocated',
      'in stock', 'dispatched',
    ])) return 'green';

    if (any(const [
      'pending', 'draft', 'scheduled', 'new', 'contacted', 'in progress',
      'under review', 'loading', 'planned', 'requested',
    ])) return 'gray';

    if (any(const [
      'pending approval', 'partially', 'review', 'proposal', 'negotiation',
      'out for delivery', 'picked up',
    ])) return 'amber';

    if (any(const [
      'rejected', 'cancelled', 'overdue', 'on hold', 'delayed', 'lost',
      'unqualified', 'bounced', 'short picked', 'quarantine',
      'under repair', 'variance',
    ])) return 'red';

    if (any(const ['transit', 'sent', 'dispatched', 'route', 'allocated'])) {
      return 'blue';
    }

    if (any(const ['quotation', 'expiring'])) return 'purple';

    return 'teal';
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = IgColors.chipColors(colorKey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          Flexible(
            child: Text(
              label,
              style: AppTypography.chip(fg),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
