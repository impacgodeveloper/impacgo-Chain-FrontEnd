import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/schema/nav_registry.dart';

class _Crumb {
  const _Crumb(this.label, {this.route});
  final String label;
  final String? route;
}

/// Ported from `renderBreadcrumb()`.
List<Widget> buildBreadcrumbChildren(BuildContext context, String currentPath) {
  final List<_Crumb> segs;

  if (currentPath == '/') {
    segs = const [_Crumb('SCM Workspace')];
  } else if (currentPath.startsWith('/entity/')) {
    final key = currentPath.substring('/entity/'.length);
    final def = NavRegistry.entitiesByKey[key];
    segs = [
      const _Crumb('SCM Workspace', route: '/'),
      _Crumb(def?.group ?? ''),
      _Crumb(def?.label ?? key),
    ];
  } else if (currentPath.startsWith('/reports/')) {
    final key = currentPath.substring('/reports/'.length);
    final def = NavRegistry.reportsByKey[key];
    segs = [
      const _Crumb('SCM Workspace', route: '/'),
      const _Crumb('Reports'),
      _Crumb(def?.reportGroup ?? ''),
      _Crumb(def?.label ?? key),
    ];
  } else {
    segs = const [_Crumb('SCM Workspace')];
  }

  final children = <Widget>[];
  for (var i = 0; i < segs.length; i++) {
    if (i > 0) {
      children.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Icon(FeatherIcons.chevronRight, size: 14, color: IgColors.textFaint),
      ));
    }
    final seg = segs[i];
    final isCurrent = i == segs.length - 1;
    final text = Text(
      seg.label,
      style: isCurrent ? AppTypography.breadcrumbCurrent : AppTypography.breadcrumb,
    );
    children.add(
      seg.route == null
          ? text
          : InkWell(onTap: () => context.go(seg.route!), child: text),
    );
  }
  return children;
}
