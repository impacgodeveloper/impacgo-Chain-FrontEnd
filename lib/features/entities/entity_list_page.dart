import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/entity_list_state_provider.dart';
import '../../application/providers/mock_database_provider.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/entity_list_state.dart';
import '../../domain/schema/entity_list_logic.dart';
import '../../domain/schema/entity_schema.dart';
import '../../domain/schema/nav_registry.dart';
import '../../domain/schema/schema_registry.dart';
import '../../infrastructure/mock/mock_database.dart';
import '../../infrastructure/services/csv_export_service.dart';
import '../../infrastructure/services/csv_import_service.dart';
import '../../shared/widgets/buttons/app_button.dart';
import '../../shared/widgets/cards/app_card.dart';
import '../../shared/widgets/dialogs/app_confirm_dialog.dart';
import '../../shared/widgets/forms/app_dropdown_compact.dart';
import '../../shared/widgets/layout/app_page_header.dart';
import '../../shared/widgets/layout/app_page_scaffold.dart';
import '../../shared/widgets/layout/ig_toast.dart';
import '../../shared/widgets/tables/ig_bulk_action_bar.dart';
import '../../shared/widgets/tables/app_empty_state.dart';
import '../../shared/widgets/tables/app_data_table.dart';
import '../../shared/widgets/tables/app_filter_bar.dart';
import '../../shared/widgets/tables/ig_list_toolbar.dart';
import '../../shared/widgets/tables/app_pagination.dart';
import 'entity_detail_drawer.dart';
import 'entity_form_dialog.dart';

/// Ported from `renderListView(key)` — the generic, schema-driven list page
/// used by all 49 entities: page header + toolbar/filters/bulk-bar/table/
/// pagination inside one card.
class EntityListPage extends ConsumerStatefulWidget {
  const EntityListPage({super.key, required this.entityKey});

  final String entityKey;

  @override
  ConsumerState<EntityListPage> createState() => _EntityListPageState();
}

class _EntityListPageState extends ConsumerState<EntityListPage> {
  bool _filtersOpen = false;
  bool _importing = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(mockDatabaseRevisionProvider);
    final db = ref.watch(mockDatabaseProvider);
    final schema = SchemaRegistry.of(widget.entityKey);
    final navItem = NavRegistry.entitiesByKey[widget.entityKey]!;

    final listState = ref.watch(entityListStateProvider(widget.entityKey));
    final notifier = ref.read(
      entityListStateProvider(widget.entityKey).notifier,
    );

    final all = filterAndSortRecords(db[widget.entityKey], schema, listState);
    final totalPages = all.isEmpty
        ? 1
        : ((all.length - 1) ~/ listState.pageSize) + 1;
    final page = listState.page > totalPages ? totalPages : listState.page;
    final pageData = all
        .skip((page - 1) * listState.pageSize)
        .take(listState.pageSize)
        .toList();

    return AppPageScaffold(
      header: AppPageHeader(
        icon: navItem.icon,
        title: navItem.label,
        subtitle:
            '${navItem.group} · ${all.length} record${all.length != 1 ? 's' : ''}',
        actions: [
          AppButton(
            label: 'Import',
            icon: FeatherIcons.upload,
            loading: _importing,
            onPressed: () => _import(db),
          ),
          AppButton(
            label: 'Export',
            icon: FeatherIcons.download,
            onPressed: () =>
                CsvExportService.export(widget.entityKey, schema.columns, all),
          ),
          AppButton(
            label: 'New ${navItem.singularLabel}',
            icon: FeatherIcons.plus,
            variant: AppButtonVariant.primary,
            onPressed: () async {
              final saved = await showEntityFormDialog(
                context,
                entityKey: widget.entityKey,
              );
              if (saved) setState(() {});
            },
          ),
        ],
      ),
      body: AppCard(
        child: Column(
          children: [
            IgListToolbar(
              searchHint: 'Search ${navItem.label.toLowerCase()}…',
              searchValue: listState.search,
              onSearchChanged: notifier.setSearch,
              onToggleFilters: () =>
                  setState(() => _filtersOpen = !_filtersOpen),
              pageSize: listState.pageSize,
              pageSizeOptions: const [10, 20, 50],
              onPageSizeChanged: (v) =>
                  notifier.setPageSize(v ?? listState.pageSize),
            ),
            AppFilterBar(
              visible: _filtersOpen,
              fields: _buildFilterFields(schema, db, notifier, listState),
            ),
            IgBulkActionBar(
              selectedCount: listState.selected.length,
              actions: [
                AppButton(
                  label: 'Export Selected',
                  icon: FeatherIcons.download,
                  size: AppButtonSize.sm,
                  onPressed: () {
                    final selectedRows = all
                        .where((r) => listState.selected.contains(r.id))
                        .toList();
                    CsvExportService.export(
                      widget.entityKey,
                      schema.columns,
                      selectedRows,
                    );
                  },
                ),
                AppButton(
                  label: 'Delete Selected',
                  icon: FeatherIcons.trash,
                  size: AppButtonSize.sm,
                  variant: AppButtonVariant.danger,
                  onPressed: () =>
                      _bulkDelete(db, navItem.label, listState.selected),
                ),
              ],
            ),
            pageData.isEmpty
                ? AppEmptyState(
                    icon: navItem.icon,
                    title: 'No ${navItem.label.toLowerCase()} found',
                    subtitle: 'Try adjusting your search or filters.',
                  )
                : AppDataTable(
                    columns: schema.columns,
                    rows: pageData,
                    selected: listState.selected,
                    onToggleRow: notifier.toggleSelectRow,
                    onToggleAll: (checked) => notifier.setSelectedIds(
                      pageData.map((r) => r.id),
                      checked,
                    ),
                    onRowTap: (rec) => showEntityDetailDrawer(
                      context,
                      entityKey: widget.entityKey,
                      recordId: rec.id,
                    ),
                    sortKey: listState.sortKey,
                    sortAscending: listState.sortDir == 1,
                    onSort: notifier.setSort,
                  ),
            AppPagination(
              page: page,
              pageSize: listState.pageSize,
              totalRecords: all.length,
              onPageChanged: notifier.setPage,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFilterFields(
    EntitySchema schema,
    MockDatabase db,
    EntityListStateNotifier notifier,
    EntityListState listState,
  ) {
    final fields = <Widget>[];
    final statusField = schema.fields
        .where((f) => f.key == 'status')
        .firstOrNull;
    if (statusField != null) {
      var opts = statusField.options;
      if (opts.isEmpty) {
        opts = db[widget.entityKey]
            .map((r) => r.status)
            .whereType<String>()
            .toSet()
            .toList();
      }
      fields.add(
        _filterDropdown('Status', 'status', opts, notifier, listState),
      );
    }

    final refField =
        schema.fields.where((f) => f.key == 'territory').firstOrNull ??
        schema.fields.where((f) => f.key == 'group').firstOrNull ??
        schema.fields.where((f) => f.key == 'warehouse').firstOrNull;
    if (refField != null) {
      final opts = refField.resolveOptions(db).toSet().toList();
      fields.add(
        _filterDropdown(
          refField.label,
          refField.key,
          opts,
          notifier,
          listState,
        ),
      );
    }

    if (fields.isEmpty) {
      fields.add(
        AppFilterField(
          label: '',
          child: Text(
            'No additional filters for this list.',
            style: AppTypography.hint,
          ),
        ),
      );
    }
    return fields;
  }

  Widget _filterDropdown(
    String label,
    String fieldKey,
    List<String> options,
    EntityListStateNotifier notifier,
    EntityListState listState,
  ) {
    final current = listState.filters[fieldKey] ?? '';
    return AppFilterField(
      label: label,
      child: AppDropdownCompact<String>(
        value: current.isEmpty ? '' : current,
        items: [
          const DropdownMenuItem(value: '', child: Text('All')),
          for (final o in options) DropdownMenuItem(value: o, child: Text(o)),
        ],
        onChanged: (v) => notifier.setFilter(fieldKey, v ?? ''),
      ),
    );
  }

  Future<void> _import(MockDatabase db) async {
    setState(() => _importing = true);
    final count = await CsvImportService.pickAndImport(db, widget.entityKey);
    setState(() => _importing = false);
    if (count == null) return;
    bumpMockDatabaseRevision(ref);
    ref
        .read(toastQueueProvider.notifier)
        .show(
          'Imported $count record(s) into ${NavRegistry.entitiesByKey[widget.entityKey]!.label}.',
          variant: IgToastVariant.success,
        );
  }

  Future<void> _bulkDelete(
    MockDatabase db,
    String label,
    Set<int> selected,
  ) async {
    if (selected.isEmpty) return;
    if (!mounted) return;
    final ctx = context;
    final confirmed = await showAppConfirmDialog(
      ctx,
      title: 'Delete ${selected.length} record(s)?',
      message:
          'This will permanently remove the selected ${label.toLowerCase()} records. This action cannot be undone in this session.',
    );
    if (!confirmed) return;
    if (!mounted) return;
    for (final id in selected) {
      db.deleteById(widget.entityKey, id);
    }
    ref
        .read(entityListStateProvider(widget.entityKey).notifier)
        .clearSelection();
    bumpMockDatabaseRevision(ref);
    ref
        .read(toastQueueProvider.notifier)
        .show('Selected records deleted.', variant: IgToastVariant.danger);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
