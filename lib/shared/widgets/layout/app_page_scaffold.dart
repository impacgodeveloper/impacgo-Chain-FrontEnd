import 'package:flutter/material.dart';

/// Ported from the `.page-head{margin-bottom:14px}` + body pattern repeated
/// on every entity/report page: an [AppPageHeader] followed by a 14px gap
/// and the page's main content (usually an [AppCard]).
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({super.key, required this.header, required this.body});

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: header,
        ),
        const SizedBox(height: 14),
        body,
      ],
    );
  }
}
