import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/ig_theme.dart';

void main() {
  runApp(const ProviderScope(child: ImpacgoChainApp()));
}

class ImpacgoChainApp extends ConsumerWidget {
  const ImpacgoChainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'IMPACGO Chain',
      debugShowCheckedModeBanner: false,
      theme: IgTheme.light,
      routerConfig: router,
    );
  }
}
