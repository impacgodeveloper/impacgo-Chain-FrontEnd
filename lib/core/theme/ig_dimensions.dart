/// Layout dimension tokens ported from the prototype's CSS custom properties
/// and hard-coded shell measurements (`#topnav`, `#sidebar`, `#breadcrumb-bar`).
abstract final class IgDimensions {
  static const topNavHeight = 56.0;
  static const sidebarWidth = 264.0;
  static const sidebarWidthCollapsed = 64.0;
  static const breadcrumbBarHeight = 42.0;

  static const drawerWidth = 560.0;

  static const dialogWidth = 640.0;
  static const dialogWidthWide = 820.0;
  static const dialogWidthNarrow = 420.0;

  // Responsive breakpoints (Responsive Framework).
  static const breakpointMobile = 480.0;
  static const breakpointTablet = 800.0;
  static const breakpointDesktop = 1280.0;
}
