import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../misc/app_loading_indicator.dart';

/// Button variant, ported from `.btn.primary` / `.btn.accent` / `.btn.danger`
/// / `.btn.ghost` / the bare `.btn` default.
enum AppButtonVariant { standard, primary, accent, danger, ghost }

/// Button size, ported from the bare `.btn` and `.btn.sm` rules.
enum AppButtonSize { normal, sm }

/// Generic action button ported from `.btn`. All 49 entity list/detail
/// screens route their actions through this single widget rather than
/// ad-hoc `ElevatedButton`s, matching the prototype's one-CSS-class-many-uses
/// pattern.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.standard,
    this.size = AppButtonSize.normal,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Shows a small spinner in place of [icon] and disables the button —
  /// for buttons that trigger a real awaited `Future` (e.g. CSV import).
  final bool loading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  ({Color bg, Color border, Color fg, Color bgHover}) get _palette {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return (
          bg: const Color(0xFF2F6FED),
          border: const Color(0xFF2F6FED),
          fg: Colors.white,
          bgHover: const Color(0xFF1D4ED8),
        );
      case AppButtonVariant.accent:
        return (
          bg: IgColors.accent,
          border: IgColors.accent,
          fg: Colors.white,
          bgHover: IgColors.accent,
        );
      case AppButtonVariant.danger:
        return (
          bg: IgColors.danger,
          border: IgColors.danger,
          fg: Colors.white,
          bgHover: IgColors.dangerDark,
        );
      case AppButtonVariant.ghost:
        return (
          bg: Colors.transparent,
          border: Colors.transparent,
          fg: IgColors.text,
          bgHover: IgColors.surfaceAlt,
        );
      case AppButtonVariant.standard:
        return (
          bg: IgColors.surface,
          border: IgColors.borderStrong,
          fg: IgColors.text,
          bgHover: IgColors.surfaceAlt,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;
    final disabled = widget.onPressed == null || widget.loading;
    final sm = widget.size == AppButtonSize.sm;
    final textStyle = (sm ? AppTypography.buttonSm : AppTypography.button)
        .copyWith(color: palette.fg);

    return MouseRegion(
      cursor: disabled ? MouseCursor.defer : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Opacity(
        opacity: disabled ? .45 : 1,
        child: GestureDetector(
          onTap: widget.loading ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: EdgeInsets.symmetric(
              horizontal: sm ? 16 : 14,
              vertical: sm ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: _hovered && !disabled ? palette.bgHover : palette.bg,
              borderRadius: sm ? BorderRadius.circular(20) : IgRadii.rMd,
              border: Border.all(color: palette.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.loading) ...[
                  AppLoadingIndicator(size: sm ? 12 : 13, color: palette.fg),
                  const SizedBox(width: 6),
                ] else if (widget.icon != null) ...[
                  Icon(widget.icon, size: sm ? 14 : 15, color: palette.fg),
                  const SizedBox(width: 6),
                ],
                Text(widget.label, style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary/outlined counterpart to [AppButton] — the bare `.btn` styling
/// (standard variant) rather than `.btn.primary`. Same widget under the
/// hood; a distinct name reads more clearly at call sites that pair a
/// primary action with a secondary one (e.g. dialog Cancel/Save).
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = AppButtonSize.normal,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      size: size,
      variant: AppButtonVariant.standard,
    );
  }
}
