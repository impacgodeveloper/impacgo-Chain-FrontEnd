import 'package:flutter/material.dart';
import '../../../core/theme/ig_colors.dart';

/// Ported from `#workspace` — the scrollable page content region,
/// `padding:18px 22px 40px`, on the `--ig-bg` canvas.
class IgWorkspace extends StatefulWidget {
  const IgWorkspace({super.key, required this.child});

  final Widget child;

  @override
  State<IgWorkspace> createState() => _IgWorkspaceState();
}

class _IgWorkspaceState extends State<IgWorkspace> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IgWorkspace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: IgColors.bg,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;
          final hPad = isNarrow ? 12.0 : 22.0;
          return Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 40),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
