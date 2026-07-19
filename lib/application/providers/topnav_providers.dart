import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company.dart';
import '../../domain/entities/notification_item.dart';

/// Which top-nav popover is currently open (`company` | `branch` | `notif` |
/// `profile`), ported from `togglePop(id)` / `closeAllPops()` — only one
/// `.tn-pop` is ever visible at a time.
final activePopoverProvider = StateProvider<String?>((ref) => null);

/// Ported from `STATE_COMPANY`.
class SelectedCompanyNotifier extends Notifier<Company> {
  @override
  Company build() => kCompanies.first;

  void select(Company company) {
    state = company;
    ref.read(selectedBranchProvider.notifier).state = company.branches.first;
  }
}

final selectedCompanyProvider = NotifierProvider<SelectedCompanyNotifier, Company>(
  SelectedCompanyNotifier.new,
);

/// Ported from `STATE_BRANCH`.
final selectedBranchProvider = StateProvider<String>((ref) => kCompanies.first.branches.first);

/// Ported from `App.notifications`.
final notificationsProvider = StateProvider<List<NotificationItem>>(
  (ref) => seedPlaceholderNotifications(),
);

/// Ported from the `#tn-search` input's live value, driving `globalSearch(q)`.
final globalSearchQueryProvider = StateProvider<String>((ref) => '');
