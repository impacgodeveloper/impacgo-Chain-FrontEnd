import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/ig_shadows.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.tn-pop` / `.tn-pop-header` / `.tn-pop-body` — the shared
/// 340px popover frame used for the company/branch/notifications/profile
/// dropdowns beneath the top nav.
class AppTopBarPopFrame extends StatefulWidget {
  const AppTopBarPopFrame({
    super.key,
    required this.title,
    required this.onClose,
    required this.children,
  });

  final String title;
  final VoidCallback onClose;
  final List<Widget> children;

  @override
  State<AppTopBarPopFrame> createState() => _AppTopBarPopFrameState();
}

class _AppTopBarPopFrameState extends State<AppTopBarPopFrame> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 340,
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: IgColors.surface,
          borderRadius: IgRadii.rMd,
          boxShadow: IgShadows.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: IgColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(widget.title, style: AppTypography.popHeader)),
                  InkWell(
                    onTap: widget.onClose,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: IgColors.surfaceAlt,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(FeatherIcons.x, size: 15, color: IgColors.textSoft),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(mainAxisSize: MainAxisSize.min, children: widget.children),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
