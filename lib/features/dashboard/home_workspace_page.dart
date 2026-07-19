import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers/mock_database_provider.dart';
import '../../application/providers/topnav_providers.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/ig_colors.dart';
import '../../domain/schema/entity_nav_item.dart';
import '../../domain/schema/nav_registry.dart';
import '../../domain/schema/workflow_registry.dart';
import '../../shared/widgets/cards/app_card.dart';
import '../../shared/widgets/workflow/app_module_tile.dart';
import '../../shared/widgets/workflow/ig_workflow_diagram.dart';

/// Ported from `renderHome()` — the SCM Workspace home page: one card per
/// [WorkflowRegistry] process diagram, then an "All Modules" tile grid
/// covering every entity in [NavRegistry.moduleTree].
class HomeWorkspacePage extends ConsumerWidget {
  const HomeWorkspacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mockDatabaseRevisionProvider);
    final db = ref.watch(mockDatabaseProvider);
    final company = ref.watch(selectedCompanyProvider);
    final branch = ref.watch(selectedBranchProvider);

    final allEntities = <(String, EntityNavItem)>[
      for (final group in NavRegistry.moduleTree)
        for (final item in group.items) (group.label, item),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(FeatherIcons.grid, size: 24, color: IgColors.text),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'SCM Workspace',
                style: AppTypography.pageTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          '${company.name} · $branch — business process overview for IMPACGO Chain',
          style: AppTypography.pageSub,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
        ),
        const SizedBox(height: 14),
        for (final wf in WorkflowRegistry.all) ...[
          AppCard(
            child: IgWorkflowDiagram(
              title: wf.title,
              description: wf.description,
              steps: wf.steps,
              stepCount: (key) => db[key].length,
              onStepTap: (key) => context.go('/entity/$key'),
            ),
          ),
          const SizedBox(height: 14),
        ],
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All Modules', style: AppTypography.wfTitle),
              const SizedBox(height: 4),
              Text(
                'Every sub-module in IMPACGO Chain, grouped by business area.',
                style: AppTypography.wfDesc,
              ),
              const SizedBox(height: 20),
              AlignedGridView.extent(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                itemCount: allEntities.length,
                itemBuilder: (context, index) {
                  final (groupLabel, item) = allEntities[index];
                  return AppModuleTile(
                    icon: item.icon,
                    colorKey: NavRegistry.tileColorKey(item.key),
                    title: item.label,
                    subtitle: '$groupLabel · ${db[item.key].length} records',
                    onTap: () => context.go('/entity/${item.key}'),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
