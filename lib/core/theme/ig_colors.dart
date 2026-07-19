import 'package:flutter/material.dart';

/// Design tokens ported 1:1 from the prototype's `:root{ --ig-* }` CSS
/// custom properties in `IMPACGO-Chain (3).html`. This is the prototype's
/// actual palette — light surface, white sidebar, dark-navy top bar — not a
/// reskin.
class IgColors {
  IgColors._();

  static bool isDark = false;

  // --ig-bg / --ig-surface / --ig-surface-alt / --ig-border(-strong)
  static const bg = Color(0xFFEEF2F7);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF6F8FB);
  static const border = Color(0xFFE1E7EF);
  static const borderStrong = Color(0xFFCBD5E1);

  // --ig-text / --ig-text-soft / --ig-text-faint
  static const text = Color(0xFF182233);
  static const textSoft = Color(0xFF5B6577);
  static const textFaint = Color(0xFF8B95A7);

  // --ig-primary(-dark|-soft)
  static const primary = Color(0xFF1E3A6E);
  static const primaryDark = Color(0xFF142A52);
  static const primarySoft = Color(0xFFE8EDF6);

  // --ig-accent(-soft) — `.tn-logo .mark` gradient's second stop / `.chip.c-teal` text
  static const accent = Color(0xFF0EA5A0);
  static const accentSoft = Color(0xFFE1F6F4);
  static const accentDark = Color(0xFF0B7A76);

  // --ig-success(-soft)
  static const success = Color(0xFF1F9254);
  static const successSoft = Color(0xFFE6F6ED);

  // --ig-warning(-soft)
  static const warning = Color(0xFFC4841D);
  static const warningSoft = Color(0xFFFCF1DE);

  // --ig-danger(-soft) / `.btn.danger:hover` background
  static const danger = Color(0xFFC4383B);
  static const dangerSoft = Color(0xFFFBE9E9);
  static const dangerDark = Color(0xFFA52D30);

  // --ig-info(-soft)
  static const info = Color(0xFF2F6FED);
  static const infoSoft = Color(0xFFE8F0FE);

  // --ig-purple(-soft)
  static const purple = Color(0xFF6D4AFF);
  static const purpleSoft = Color(0xFFEEEAFF);

  // Card/table alternating tint used for the `.chip.c-gray` free color.
  static const chipGrayBg = Color(0xFFEEF1F5);
  static Color get chipGrayFg => textSoft;

  // --- Top-nav-specific tokens ---------------------------------------
  // `#topnav` is always the fixed navy `--ig-primary`, so its children use
  // fixed white-on-navy overlays rather than the reactive surface tokens.
  static const tnIconColor = Color(0xFFDCE6F5);
  static const tnOverlayBg = Color(0x14FFFFFF); // rgba(255,255,255,.08)
  static const tnOverlayBgHover = Color(0x29FFFFFF); // rgba(255,255,255,.16)
  static const tnOverlayBorder = Color(0x24FFFFFF); // rgba(255,255,255,.14)
  static const tnSearchBg = Color(0x1AFFFFFF); // rgba(255,255,255,.1)
  static const tnSearchBorder = Color(0x29FFFFFF); // rgba(255,255,255,.16)
  static const tnSearchFocusBg = Color(0x2EFFFFFF); // rgba(255,255,255,.18)
  static const tnSearchFocusBorder = Color(0x59FFFFFF); // rgba(255,255,255,.35)
  static const tnSearchPlaceholder = Color(0xFFB6C4DD);
  static const tnSubText = Color(0xFFB9C7E0);
  static const tnSwitchText = Color(0xFFEAF0FB);
  static const tnSwitchLabel = Color(0xFF9FB2D2);
  static const tnProfileName = Color(0xFFEAF0FB);
  static const tnProfileRole = Color(0xFF9FB2D2);

  static Color get scrollbarThumb => const Color(0xFFC7D1DE);
  static Color get scrollbarThumbHover => const Color(0xFFAEB9C9);

  static (Color bg, Color fg) chipColors(String key) {
    switch (key) {
      case 'green':
        return (successSoft, success);
      case 'amber':
        return (warningSoft, warning);
      case 'red':
        return (dangerSoft, danger);
      case 'blue':
        return (infoSoft, info);
      case 'teal':
        return (accentSoft, accentDark);
      case 'purple':
        return (purpleSoft, purple);
      case 'gray':
      default:
        return (chipGrayBg, chipGrayFg);
    }
  }

  /// Ported from `colorVarMap` in `renderHome()`: blue->info, amber->warning,
  /// teal->accent, red->danger, purple->purple, info->info, else->primary.
  static (Color bg, Color fg) tileColors(String key) {
    switch (key) {
      case 'blue':
        return (infoSoft, info);
      case 'amber':
        return (warningSoft, warning);
      case 'teal':
        return (accentSoft, accent);
      case 'red':
        return (dangerSoft, danger);
      case 'purple':
        return (purpleSoft, purple);
      case 'info':
        return (infoSoft, info);
      default:
        return (primarySoft, primary);
    }
  }
}
