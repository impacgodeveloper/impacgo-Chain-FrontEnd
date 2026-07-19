import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ig_colors.dart';

/// Text style tokens ported from the prototype's type scale. Base body size
/// is 13.5px (`body{font-size:13.5px}`); every other size below is lifted
/// verbatim from its originating CSS rule.
abstract final class AppTypography {
  static TextStyle _base(
    double size,
    FontWeight weight, {
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color ?? IgColors.text,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// `body{font-size:13.5px}`
  static TextStyle get body => _base(13.5, FontWeight.w400);

  /// `.tn-logo{font-weight:700;font-size:15px;color:#fff}` — topnav is
  /// always the fixed navy `--ig-primary`, so its text is fixed white/light,
  /// not the reactive surface-on-light [IgColors.text].
  static TextStyle get tnLogo =>
      _base(15, FontWeight.w800, color: Colors.white, letterSpacing: 0.2);

  /// `.tn-logo .mark{font-weight:800;font-size:13px}`
  static TextStyle get tnLogoMark =>
      _base(13, FontWeight.w800, color: Colors.white);

  /// `.tn-sub{font-weight:400;font-size:11px;color:#B9C7E0}`
  static TextStyle get tnSub =>
      _base(11, FontWeight.w400, color: IgColors.tnSubText);

  /// `.tn-switch{font-size:12px;color:#EAF0FB}`
  static TextStyle get tnSwitch =>
      _base(12, FontWeight.w600, color: IgColors.tnSwitchText);

  /// `.tn-switch .lbl{font-size:10px;text-transform:uppercase;letter-spacing:.4px;color:#9FB2D2}`
  static TextStyle get tnSwitchLabel => _base(
    10,
    FontWeight.w700,
    color: IgColors.tnSwitchLabel,
    letterSpacing: 0.4,
  );

  /// `#tn-search{font-size:13px;color:#fff}`
  static TextStyle get tnSearch =>
      _base(13, FontWeight.w400, color: Colors.white);

  /// `.tn-profile-name{font-size:12px;color:#EAF0FB}`
  static TextStyle get tnProfileName =>
      _base(12, FontWeight.w700, color: IgColors.tnProfileName, height: 1.1);

  /// `.tn-profile-role{font-size:10px;color:#9FB2D2}`
  static TextStyle get tnProfileRole =>
      _base(10, FontWeight.w400, color: IgColors.tnProfileRole);

  /// `.sb-group-head{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.5px}`
  /// — sidebar is the reactive light [IgColors.surface], so this uses
  /// [IgColors.textSoft] rather than a fixed light-on-dark color.
  static TextStyle get sidebarGroupHead =>
      _base(11, FontWeight.w700, color: IgColors.textSoft, letterSpacing: 0.5);

  /// `.sb-item{font-size:12.5px;color:var(--ig-text)}`
  static TextStyle get sidebarItem =>
      _base(12.5, FontWeight.w400, color: IgColors.text);

  /// `.sb-item.active{font-weight:600;color:var(--ig-primary)}`
  static TextStyle get sidebarItemActive =>
      _base(12.5, FontWeight.w600, color: IgColors.primary);

  /// `.sb-home{font-weight:700;font-size:12.5px;color:var(--ig-primary)}`
  static TextStyle get sidebarHome =>
      _base(12.5, FontWeight.w700, color: IgColors.primary);

  /// `.sb-footer{font-size:10.5px}`
  static TextStyle get sidebarFooter =>
      _base(10.5, FontWeight.w400, color: IgColors.textFaint);

  /// `#breadcrumb-bar{font-size:12px}`
  static TextStyle get breadcrumb =>
      _base(12, FontWeight.w400, color: IgColors.textSoft);

  /// `.bc-seg.current{font-weight:600}`
  static TextStyle get breadcrumbCurrent =>
      _base(12, FontWeight.w600, color: IgColors.text);

  /// `.page-title{font-size:19px;font-weight:700}`
  static TextStyle get pageTitle => _base(19, FontWeight.w700);

  /// `.page-sub{font-size:12px}`
  static TextStyle get pageSub =>
      _base(12, FontWeight.w400, color: IgColors.textFaint);

  /// `.btn{font-size:12.5px;font-weight:600}`
  static TextStyle get button => _base(12.5, FontWeight.w600);

  /// `.btn.sm{font-size:11.5px}`
  static TextStyle get buttonSm => _base(11.5, FontWeight.w600);

  /// `.wf-title{font-size:14px;font-weight:700}`
  static TextStyle get wfTitle => _base(14, FontWeight.w700);

  /// `.wf-desc{font-size:11.5px}`
  static TextStyle get wfDesc =>
      _base(12.0, FontWeight.w400, color: IgColors.textFaint);

  /// `.wf-step .t{font-size:12.5px;font-weight:700}`
  static TextStyle get h1 => _base(24.5, FontWeight.w700);
  static TextStyle get h2 => _base(18.5, FontWeight.w700);
  static TextStyle get h3 => _base(15.5, FontWeight.w600);

  static TextStyle get bodyStrong => _base(14.0, FontWeight.w600);

  static TextStyle get navLabel =>
      _base(13.0, FontWeight.w600, color: IgColors.textSoft);
  static TextStyle get navLabelActive =>
      _base(13.0, FontWeight.w700, color: IgColors.primary);

  static TextStyle get btn => _base(13.0, FontWeight.w600);
  static TextStyle get btnSm => _base(12.0, FontWeight.w600);

  static TextStyle get wfStepTitle => _base(13.0, FontWeight.w700);

  /// `.wf-step .c{font-size:10.5px}`
  static TextStyle get wfStepCount =>
      _base(11.0, FontWeight.w400, color: IgColors.textFaint);

  /// `.wf-step .n{font-size:11px;font-weight:700}`
  static TextStyle get wfStepNumber =>
      _base(11.5, FontWeight.w700, color: Colors.white);

  /// `.tile-title{font-weight:700;font-size:13px}`
  static TextStyle get tileTitle => _base(13.5, FontWeight.w700);

  /// `.tile-count{font-size:11px}`
  static TextStyle get tileCount =>
      _base(11.5, FontWeight.w400, color: IgColors.textFaint);

  /// table header `font-size:10.8px;font-weight:700;text-transform:uppercase;letter-spacing:.3px`
  static TextStyle get tableHeader => _base(
    10.8,
    FontWeight.w700,
    color: IgColors.textSoft,
    letterSpacing: 0.3,
  );

  /// table cell `font-size:12.5px` (`table.erp-table{font-size:12.5px}`)
  static TextStyle get tableCell => _base(12.5, FontWeight.w400);

  /// `.cell-primary{font-weight:600}`
  static TextStyle get tableCellPrimary =>
      _base(12.5, FontWeight.w600, color: IgColors.primary);

  /// `.cell-secondary{font-size:11px}`
  static TextStyle get tableCellSecondary =>
      _base(11.5, FontWeight.w400, color: IgColors.textFaint);

  /// `.pagination{font-size:12px}`
  static TextStyle get pagination =>
      _base(12.5, FontWeight.w400, color: IgColors.textSoft);

  /// `.chip{font-size:11px;font-weight:700}`
  static TextStyle chip(Color fg) => _base(11.5, FontWeight.w700, color: fg);

  /// `.drawer-title{font-size:16px;font-weight:700}`
  static TextStyle get drawerTitle => _base(16.5, FontWeight.w700);

  /// `.drawer-subtitle{font-size:11.5px}`
  static TextStyle get drawerSubtitle =>
      _base(11.5, FontWeight.w400, color: IgColors.textFaint);

  /// `.drawer-tab{font-size:12px;font-weight:600}`
  static TextStyle get drawerTab =>
      _base(12, FontWeight.w600, color: IgColors.textFaint);

  /// `.drawer-tab.active{color:var(--ig-primary)}`
  static TextStyle get drawerTabActive =>
      _base(12, FontWeight.w600, color: IgColors.primary);

  /// `.dv-field label{font-size:10.5px;font-weight:700;text-transform:uppercase;letter-spacing:.3px}`
  static TextStyle get fieldLabel => _base(
    10.5,
    FontWeight.w700,
    color: IgColors.textFaint,
    letterSpacing: 0.3,
  );

  /// `.dv-field .v{font-size:13px;font-weight:600}`
  static TextStyle get fieldValue => _base(13, FontWeight.w600);

  /// `.dv-section-title{font-size:11.5px;font-weight:700;text-transform:uppercase;letter-spacing:.4px}`
  static TextStyle get sectionTitle => _base(
    11.5,
    FontWeight.w700,
    color: IgColors.textSoft,
    letterSpacing: 0.4,
  );

  /// `.tl-title{font-size:12.5px;font-weight:600}`
  static TextStyle get timelineTitle => _base(12.5, FontWeight.w600);

  /// `.tl-meta{font-size:11px}`
  static TextStyle get timelineMeta =>
      _base(11, FontWeight.w400, color: IgColors.textFaint);

  /// `.att-name{font-size:12.5px;font-weight:600}`
  static TextStyle get attachmentName => _base(12.5, FontWeight.w600);

  /// `.att-meta{font-size:11px}`
  static TextStyle get attachmentMeta =>
      _base(11, FontWeight.w400, color: IgColors.textFaint);

  /// `.cmt-author{font-size:12px;font-weight:700}`
  static TextStyle get commentAuthor => _base(12, FontWeight.w700);

  /// `.cmt-time{font-size:10.5px;font-weight:400}`
  static TextStyle get commentTime =>
      _base(10.5, FontWeight.w400, color: IgColors.textFaint);

  /// `.cmt-text{font-size:12.5px}`
  static TextStyle get commentText => _base(12.5, FontWeight.w400);

  /// `.audit-row{font-size:12px}`
  static TextStyle get auditRow => _base(12, FontWeight.w400);

  /// `.audit-row .when{font-size:11px}`
  static TextStyle get auditWhen =>
      _base(11, FontWeight.w400, color: IgColors.textFaint);

  /// `.dialog-head h3{font-size:15px}`
  static TextStyle get dialogTitle => _base(15, FontWeight.w600);

  /// Confirm-dialog message `<p style="font-size:13px;line-height:1.6">`.
  static TextStyle get confirmMessage =>
      _base(13, FontWeight.w400, color: IgColors.textSoft, height: 1.6);

  /// `.form-field label{font-size:11.5px;font-weight:700}`
  static TextStyle get formLabel =>
      _base(11.5, FontWeight.w700, color: IgColors.textSoft);

  /// `.form-field label .req{color:var(--ig-danger)}`
  static TextStyle get formLabelRequired =>
      formLabel.copyWith(color: IgColors.danger);

  /// `.form-field input{font-size:13px}`
  static TextStyle get formInput => _base(13, FontWeight.w400);

  /// `.form-field input{font-size:13px}` placeholder/disabled tint.
  static TextStyle get formInputFaint =>
      _base(13, FontWeight.w400, color: IgColors.textFaint);

  /// `.cmt-avatar{font-weight:700;font-size:11px;color:var(--ig-purple)}`
  static TextStyle get commentAvatarInitials =>
      _base(11, FontWeight.w700, color: IgColors.purple);

  /// `.tn-avatar{font-weight:700;font-size:11px;color:#fff}`
  static TextStyle get tnAvatarInitials =>
      _base(11, FontWeight.w700, color: Colors.white);

  /// `.tn-badge{font-size:9px;font-weight:700;color:#fff}`
  static TextStyle get tnBadgeCount =>
      _base(9, FontWeight.w700, color: Colors.white);

  /// The Reports sidebar sub-group label (`sub.group`), a one-off inline
  /// style distinct from `.hint`: `font-size:10px;font-weight:700;
  /// text-transform:uppercase;letter-spacing:.4px;color:var(--ig-text-faint)`.
  static TextStyle get sidebarReportGroupLabel =>
      _base(10, FontWeight.w700, color: IgColors.textFaint, letterSpacing: 0.4);

  /// `.hint{font-size:11px}`
  static TextStyle get hint =>
      _base(11, FontWeight.w400, color: IgColors.textFaint);

  /// `.kv-inline .kv{font-size:12px}`
  static TextStyle get kvInline => _base(12, FontWeight.w400);

  /// `.kv-inline .kv b{font-size:14px}`
  static TextStyle get kvInlineBold => _base(14, FontWeight.w700);

  /// `.toast{font-size:12.5px}`
  static TextStyle get toast =>
      _base(12.5, FontWeight.w400, color: Colors.white);

  /// `.tsr-item .t{font-weight:600;font-size:12.5px}`
  static TextStyle get searchResultTitle => _base(12.5, FontWeight.w600);

  /// `.tsr-item .s{font-size:11.5px}`
  static TextStyle get searchResultSub =>
      _base(11.5, FontWeight.w400, color: IgColors.textFaint);

  /// `.tsr-group{font-size:10.5px;font-weight:700;text-transform:uppercase;letter-spacing:.5px}`
  static TextStyle get searchGroupLabel => _base(
    10.5,
    FontWeight.w700,
    color: IgColors.textFaint,
    letterSpacing: 0.5,
  );

  /// `.notif-text{font-size:12px}`
  static TextStyle get notificationText =>
      _base(12, FontWeight.w400, height: 1.5);

  /// `.notif-time{font-size:10.5px}`
  static TextStyle get notificationTime =>
      _base(10.5, FontWeight.w400, color: IgColors.textFaint);

  /// `.profile-menu-item{font-size:12.5px}`
  static TextStyle get profileMenuItem => _base(12.5, FontWeight.w400);

  /// `.switch-pop-item{font-size:12.5px}` / `b{font-size:12.5px}` / `span{font-size:11px}`
  static TextStyle get switchPopItemTitle => _base(12.5, FontWeight.w700);
  static TextStyle get switchPopItemSub =>
      _base(11, FontWeight.w400, color: IgColors.textFaint);

  /// `.tn-pop-header{font-weight:700;font-size:13px}`
  static TextStyle get popHeader => _base(13, FontWeight.w700);

  /// `.empty-state .t{font-weight:700;font-size:13px}`
  static TextStyle get emptyStateTitle =>
      _base(13, FontWeight.w700, color: IgColors.textSoft);
}
