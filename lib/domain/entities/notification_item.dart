/// Ported from `App.notifications` entries — `{text, kind, time}`. `kind`
/// drives the notif-dot color (`amber`/`blue`/`red`/`green`/`purple`,
/// default `info`), matching `popNotifHtml()`.
class NotificationItem {
  const NotificationItem({required this.id, required this.text, required this.kind, required this.time});

  final int id;
  final String text;
  final String kind;
  final DateTime time;
}

/// Static placeholder seed mirroring `seedNotifications()`'s pool of
/// message templates. Phase 6+ replaces this with notifications generated
/// from the live mock DB once transactional data exists.
List<NotificationItem> seedPlaceholderNotifications() {
  final now = DateTime.now();
  return [
    NotificationItem(id: 1, text: 'Sales Order SO-10234 is pending approval', kind: 'amber', time: now.subtract(const Duration(hours: 2))),
    NotificationItem(id: 2, text: 'Purchase Order PO-10112 was sent to supplier', kind: 'blue', time: now.subtract(const Duration(hours: 5))),
    NotificationItem(id: 3, text: 'Batch BAT-1042-017 is expiring soon', kind: 'red', time: now.subtract(const Duration(hours: 9))),
    NotificationItem(id: 4, text: 'Delivery Note DN-10087 has been dispatched', kind: 'green', time: now.subtract(const Duration(hours: 14))),
    NotificationItem(id: 5, text: 'Invoice SINV-10099 is overdue', kind: 'red', time: now.subtract(const Duration(days: 1))),
    NotificationItem(id: 6, text: 'New lead captured: Falcon Ridge Supermarkets', kind: 'purple', time: now.subtract(const Duration(days: 1, hours: 6))),
    NotificationItem(id: 7, text: 'Sales Order SO-10241 is pending approval', kind: 'amber', time: now.subtract(const Duration(days: 2))),
    NotificationItem(id: 8, text: 'Delivery Note DN-10091 has been dispatched', kind: 'green', time: now.subtract(const Duration(days: 3))),
  ];
}
