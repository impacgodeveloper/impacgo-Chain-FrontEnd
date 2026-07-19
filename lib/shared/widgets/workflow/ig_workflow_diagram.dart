import 'package:flutter/material.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/schema/workflow_registry.dart';
import '../icons/app_icon.dart';

/// Ported from `.wf-row` / `.wf-step` / `.wf-arrow` — a horizontal,
/// numbered process diagram (Order to Cash, Procure to Pay, Inventory Flow)
/// where each step is clickable through to that entity's worklist.
class IgWorkflowDiagram extends StatefulWidget {
  const IgWorkflowDiagram({
    super.key,
    required this.title,
    required this.description,
    required this.steps,
    required this.stepCount,
    required this.onStepTap,
  });

  final String title;
  final String description;
  final List<WorkflowStep> steps;
  final int Function(String entityKey) stepCount;
  final void Function(String entityKey) onStepTap;

  @override
  State<IgWorkflowDiagram> createState() => _IgWorkflowDiagramState();
}

class _IgWorkflowDiagramState extends State<IgWorkflowDiagram> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: AppTypography.wfTitle),
              const SizedBox(height: 2),
              Text(widget.description, style: AppTypography.wfDesc),
            ],
          ),
        ),
        Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.steps.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Center(
                          child: AppIcon(
                            'chevronRight',
                            size: 18,
                            color: IgColors.textFaint,
                          ),
                        ),
                      ),
                    _WorkflowStepTile(
                      index: i + 1,
                      step: widget.steps[i],
                      count: widget.stepCount(widget.steps[i].entityKey),
                      onTap: () => widget.onStepTap(widget.steps[i].entityKey),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkflowStepTile extends StatefulWidget {
  const _WorkflowStepTile({
    required this.index,
    required this.step,
    required this.count,
    required this.onTap,
  });

  final int index;
  final WorkflowStep step;
  final int count;
  final VoidCallback onTap;

  @override
  State<_WorkflowStepTile> createState() => _WorkflowStepTileState();
}

class _WorkflowStepTileState extends State<_WorkflowStepTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 156,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: IgColors.surfaceAlt,
            borderRadius: IgRadii.rMd,
            border: Border.all(
              color: _hovered ? IgColors.primary : IgColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: IgColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.index}',
                  style: AppTypography.wfStepNumber,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.step.title,
                style: AppTypography.wfStepTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text('${widget.count} records', style: AppTypography.wfStepCount),
            ],
          ),
        ),
      ),
    );
  }
}
