import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/home_workspace_page.dart';
import '../../features/entities/entity_list_page.dart';
import '../../features/profile/my_profile_page.dart';
import '../../features/reports/report_view_page.dart';
import '../../features/shell/main_shell_scaffold.dart';

/// Ported from `navigate(route)` / `App.route` (`{type:'home'}` |
/// `{type:'entity', key}` | `{type:'report', key}`) — GoRouter replaces the
/// prototype's manual route object + re-render dispatch. No auth gate:
/// the prototype is single-persona and always "signed in".
import 'package:flutter/widgets.dart';

import '../../application/providers/topnav_providers.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Ported from `navigate(route)` / `App.route` (`{type:'home'}` |
/// `{type:'entity', key}` | `{type:'report', key}`) — GoRouter replaces the
/// prototype's manual route object + re-render dispatch. No auth gate:
/// the prototype is single-persona and always "signed in".
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MainShellScaffold(currentPath: state.uri.path, child: child),
          );
        },
        routes: [
          GoRoute(
            path: '/', 
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeWorkspacePage()),
          ),
          GoRoute(
            path: '/entity/:key',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: EntityListPage(entityKey: state.pathParameters['key']!)),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyProfilePage()),
          ),
          GoRoute(
            path: '/reports/:key',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ReportViewPage(reportKey: state.pathParameters['key']!)),
          ),
        ],
      ),
    ],
  );

  router.routerDelegate.addListener(() {
    ref.read(activePopoverProvider.notifier).state = null;
  });

  return router;
});
