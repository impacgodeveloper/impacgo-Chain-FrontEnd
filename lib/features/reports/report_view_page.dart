import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/mock_database_provider.dart';
import '../../domain/schema/nav_registry.dart';
import '../../domain/schema/report_registry.dart';
import '../../infrastructure/services/csv_export_service.dart';
import '../../shared/widgets/buttons/app_button.dart';
import '../../shared/widgets/cards/app_card.dart';
import '../../shared/widgets/layout/app_page_header.dart';
import '../../shared/widgets/layout/app_page_scaffold.dart';
import '../../shared/widgets/tables/app_empty_state.dart';
import '../../shared/widgets/tables/app_data_table.dart';

/// Ported from `renderReportView(key)` — a read-only, computed table with
/// no toolbar/filters/pagination, just an Export action.
class ReportViewPage extends ConsumerWidget {
  const ReportViewPage({super.key, required this.reportKey});

  final String reportKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mockDatabaseRevisionProvider);
    final db = ref.watch(mockDatabaseProvider);
    final report = ReportRegistry.of(reportKey);
    final navItem = NavRegistry.reportsByKey[reportKey]!;
    final data = report.compute(db);

    return AppPageScaffold(
      header: AppPageHeader(
        icon: navItem.icon,
        title: navItem.label,
        subtitle:
            '${navItem.reportGroup} · ${data.length} record${data.length != 1 ? 's' : ''} · read-only report',
        actions: [
          AppButton(
            label: 'Export', icon: FeatherIcons.download, variant: AppButtonVariant.primary,
            onPressed: () => CsvExportService.export(reportKey, report.columns, data),
          ),
        ],
      ),
      body: AppCard(
        child: data.isEmpty
            ? AppEmptyState(icon: navItem.icon, title: 'No data available for this report')
            : AppDataTable(columns: report.columns, rows: data),
      ),
    );
  }
}
