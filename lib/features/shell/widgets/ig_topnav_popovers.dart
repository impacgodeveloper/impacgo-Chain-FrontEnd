import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/topnav_providers.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/company.dart';
import '../../../shared/widgets/layout/ig_toast.dart';
import 'ig_topnav_pop_frame.dart';

/// Ported from `popCompanyHtml()` — `.switch-pop-item` rows, one per
/// [kCompanies] entry.
class CompanyPopoverBody extends ConsumerWidget {
  const CompanyPopoverBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCompanyProvider);
    return AppTopBarPopFrame(
      title: 'Switch Company',
      onClose: () => ref.read(activePopoverProvider.notifier).state = null,
      children: [
        for (final company in kCompanies)
          _SwitchPopItem(
            title: company.name,
            subtitle: '${company.branches.length} branches',
            active: company.id == selected.id,
            onTap: () {
              ref.read(selectedCompanyProvider.notifier).select(company);
              ref.read(activePopoverProvider.notifier).state = null;
              ref.read(toastQueueProvider.notifier).show(
                    'Switched company to ${company.name}',
                    variant: IgToastVariant.success,
                  );
            },
          ),
      ],
    );
  }
}

/// Ported from `popBranchHtml()`.
class BranchPopoverBody extends ConsumerWidget {
  const BranchPopoverBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(selectedCompanyProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);
    return AppTopBarPopFrame(
      title: 'Switch Branch',
      onClose: () => ref.read(activePopoverProvider.notifier).state = null,
      children: [
        for (final branch in company.branches)
          _SwitchPopItem(
            title: branch,
            active: branch == selectedBranch,
            onTap: () {
              ref.read(selectedBranchProvider.notifier).state = branch;
              ref.read(activePopoverProvider.notifier).state = null;
              ref.read(toastQueueProvider.notifier).show(
                    'Switched branch to $branch',
                    variant: IgToastVariant.success,
                  );
            },
          ),
      ],
    );
  }
}

class _SwitchPopItem extends StatefulWidget {
  const _SwitchPopItem({
    required this.title,
    this.subtitle,
    required this.active,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SwitchPopItem> createState() => _SwitchPopItemState();
}

class _SwitchPopItemState extends State<_SwitchPopItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: widget.active
                ? IgColors.primarySoft
                : (_hovered ? IgColors.surfaceAlt : Colors.transparent),
            border: Border(bottom: BorderSide(color: IgColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: AppTypography.switchPopItemTitle),
              if (widget.subtitle != null)
                Text(widget.subtitle!, style: AppTypography.switchPopItemSub),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ported from `popNotifHtml()` — `.notif-item` rows with a colored dot.
class NotificationsPopoverBody extends ConsumerWidget {
  const NotificationsPopoverBody({super.key});

  Color _dotColor(String kind) {
    switch (kind) {
      case 'amber':
        return IgColors.warning;
      case 'red':
        return IgColors.danger;
      case 'green':
        return IgColors.success;
      case 'purple':
        return IgColors.purple;
      default:
        return IgColors.info;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    return AppTopBarPopFrame(
      title: 'Notifications',
      onClose: () => ref.read(activePopoverProvider.notifier).state = null,
      children: [
        for (final n in notifications)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: IgColors.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: _dotColor(n.kind), shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.text, style: AppTypography.notificationText),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM dd, yyyy · h:mm a').format(n.time),
                        style: AppTypography.notificationTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Ported from `popProfileHtml()` — `.profile-menu-item` rows.
class ProfilePopoverBody extends ConsumerWidget {
  const ProfilePopoverBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTopBarPopFrame(
      title: 'Sarah Alvarez',
      onClose: () => ref.read(activePopoverProvider.notifier).state = null,
      children: [
        _ProfileMenuItem(
          icon: FeatherIcons.user,
          label: 'My Profile',
          onTap: () {
            ref.read(activePopoverProvider.notifier).state = null;
            context.go('/profile');
          },
        ),
        _ProfileMenuItem(icon: FeatherIcons.sliders, label: 'Preferences', onTap: () {}),
        _ProfileMenuItem(icon: FeatherIcons.briefcase, label: 'Switch Organization', onTap: () {}),
        _ProfileMenuItem(icon: FeatherIcons.logOut, label: 'Sign Out', onTap: () {}),
      ],
    );
  }
}

class _ProfileMenuItem extends StatefulWidget {
  const _ProfileMenuItem({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<_ProfileMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? IgColors.surfaceAlt : Colors.transparent,
            border: Border(bottom: BorderSide(color: IgColors.border)),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 16, color: IgColors.textSoft),
              const SizedBox(width: 10),
              Text(widget.label, style: AppTypography.profileMenuItem),
            ],
          ),
        ),
      ),
    );
  }
}
