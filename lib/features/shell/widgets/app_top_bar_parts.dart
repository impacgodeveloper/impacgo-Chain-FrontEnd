import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/sidebar_providers.dart';
import '../../../application/providers/topnav_providers.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_dimensions.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.tn-btn` — a transparent icon button with a hover tint,
/// used for the sidebar-toggle and notification-bell buttons.
class AppTopBarIconButton extends StatefulWidget {
  const AppTopBarIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.badgeCount,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final int? badgeCount;

  @override
  State<AppTopBarIconButton> createState() => _AppTopBarIconButtonState();
}

class _AppTopBarIconButtonState extends State<AppTopBarIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hovered ? IgColors.primarySoft : Colors.transparent,
            borderRadius: IgRadii.rSm,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: _hovered ? IgColors.primary : IgColors.textSoft,
              ),
              if (widget.badgeCount != null && widget.badgeCount! > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    constraints: const BoxConstraints(
                      minWidth: 15,
                      minHeight: 15,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: IgColors.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${widget.badgeCount}',
                      style: AppTypography.tnBadgeCount,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    return widget.tooltip == null
        ? button
        : Tooltip(message: widget.tooltip!, child: button);
  }
}

/// Ported from `.tn-logo` — the "IG" mark, "IMPACGO Chain" wordmark, and
/// "Supply Chain Management" subtitle.
class AppTopBarLogo extends StatelessWidget {
  const AppTopBarLogo({super.key, required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Align(
        alignment: const Alignment(-0.35, 0),
        child: ClipRect(
          child: IntrinsicHeight(
            child: OverflowBox(
              minWidth: 0,
              maxWidth: 240,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2F6FED),
                    ),
                    child: Text('IC', style: AppTypography.tnLogoMark),
                  ),
                  if (!collapsed) ...[
                    const SizedBox(width: 8),
                    Text('IMPACGO CHAIN', style: AppTypography.tnLogo),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ported from `.tn-switch` — the company/branch pill buttons that open the
/// respective popover.
class AppTopBarSwitchButton extends ConsumerWidget {
  const AppTopBarSwitchButton({
    super.key,
    required this.label,
    required this.value,
    required this.popoverKey,
  });

  final String label;
  final String value;
  final String popoverKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: IgRadii.rSm,
      onTap: () {
        final current = ref.read(activePopoverProvider);
        ref.read(activePopoverProvider.notifier).state = current == popoverKey
            ? null
            : popoverKey;
      },
      child: Container(
        height: 40,
        constraints: const BoxConstraints(minWidth: 80, maxWidth: 260),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        decoration: BoxDecoration(
          color: IgColors.surfaceAlt,
          borderRadius: IgRadii.rSm,
          border: Border.all(color: IgColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: AppTypography.tnSwitchLabel.copyWith(
                      color: IgColors.textFaint,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: AppTypography.tnSwitch.copyWith(
                      color: IgColors.text,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              FeatherIcons.chevronDown,
              size: 14,
              color: IgColors.textSoft,
            ),
          ],
        ),
      ),
    );
  }
}

/// Ported from `.tn-profile` — avatar initials + name/role + chevron,
/// opening the profile popover.
class AppTopBarProfileButton extends ConsumerWidget {
  const AppTopBarProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final narrow = MediaQuery.of(context).size.width < IgDimensions.breakpointTablet;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        final current = ref.read(activePopoverProvider);
        ref.read(activePopoverProvider.notifier).state = current == 'profile'
            ? null
            : 'profile';
      },
      child: Container(
        height: 40,
        constraints: narrow
            ? const BoxConstraints()
            : const BoxConstraints(minWidth: 140, maxWidth: 180),
        padding: narrow
            ? const EdgeInsets.symmetric(horizontal: 6)
            : const EdgeInsets.fromLTRB(8, 0, 12, 0),
        decoration: BoxDecoration(
          color: IgColors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: IgColors.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showDetails = !narrow && constraints.maxWidth >= 110;
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F6FED),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'SA',
                    style: AppTypography.tnAvatarInitials.copyWith(fontSize: 12),
                  ),
                ),
                if (showDetails) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sarah Alvarez',
                          style: AppTypography.tnProfileName.copyWith(
                            color: IgColors.text,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        Text(
                          'SCM Administrator',
                          style: AppTypography.tnProfileRole.copyWith(
                            color: IgColors.textSoft,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    FeatherIcons.chevronDown,
                    size: 14,
                    color: IgColors.textSoft,
                  ),
                ],
              ],
            );
          }
        ),
      ),
    );
  }
}

/// Ported from `#tn-sidebar-toggle` — toggles the persistent sidebar collapse.
/// On narrow screens (< breakpointTablet) the sidebar is a [Drawer], so
/// the button opens the Scaffold drawer instead of toggling collapse.
class AppSidebarToggleButton extends ConsumerWidget {
  const AppSidebarToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTopBarIconButton(
      icon: FeatherIcons.menu,
      tooltip: 'Toggle Sidebar',
      onTap: () {
        final narrow = MediaQuery.of(context).size.width < IgDimensions.breakpointTablet;
        if (narrow) {
          Scaffold.of(context).openDrawer();
        } else {
          ref.read(sidebarCollapsedProvider.notifier).toggle();
        }
      },
    );
  }
}
