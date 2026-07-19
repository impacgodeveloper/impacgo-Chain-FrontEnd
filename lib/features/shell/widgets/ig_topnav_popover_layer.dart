import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/topnav_providers.dart';
import '../../../core/theme/ig_dimensions.dart';
import 'ig_topnav_popovers.dart';

/// Ported from `.tn-pop{position:absolute;top:var(--topnav-h);right:10px}`
/// plus `closeAllPops()` on outside click — a screen-positioned popover
/// layer shared by the company/branch/notifications/profile dropdowns, with
/// a transparent tap-outside-to-dismiss barrier.
class AppTopBarPopoverLayer extends ConsumerWidget {
  const AppTopBarPopoverLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activePopoverProvider);
    if (active == null) return const SizedBox.shrink();

    final body = switch (active) {
      'company' => const CompanyPopoverBody(),
      'branch' => const BranchPopoverBody(),
      'notif' => const NotificationsPopoverBody(),
      'profile' => const ProfilePopoverBody(),
      _ => const SizedBox.shrink(),
    };

    return Stack(
      children: [
        Positioned(
          top: IgDimensions.topNavHeight,
          right: 10,
          child: TapRegion(
            groupId: 'topnav_popovers',
            onTapOutside: (event) {
              ref.read(activePopoverProvider.notifier).state = null;
            },
            child: body,
          ),
        ),
      ],
    );
  }
}
