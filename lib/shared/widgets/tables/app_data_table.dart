import 'package:flutter/material.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utilities/formatters.dart';
import '../../../domain/entities/entity_record.dart';
import '../../../domain/schema/column_def.dart';
import '../chips/app_status_chip.dart';

/// Ported from `renderTable(key,def,pageData,st)` — the sortable, checkbox-
/// selectable, `.erp-table`-styled data grid. Rows all render on one page
/// at a time (pagination caps `pageData` at 10/20/50), matching the
/// prototype's "whole page scrolls, not the table" behavior — hence a
/// plain [DataTable] rather than a virtualized grid.
///
/// Selection/sort callbacks are optional so the same widget also serves
/// Phase 14's read-only report tables (`renderReportView`), which have
/// neither.
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.selected,
    this.onToggleRow,
    this.onToggleAll,
    this.onRowTap,
    this.sortKey,
    this.sortAscending = true,
    this.onSort,
  });

  final List<ColumnDef> columns;
  final List<EntityRecord> rows;
  final Set<int>? selected;
  final void Function(int id, bool checked)? onToggleRow;
  final void Function(bool checked)? onToggleAll;
  final void Function(EntityRecord rec)? onRowTap;
  final String? sortKey;
  final bool sortAscending;
  final void Function(String columnKey)? onSort;

  bool get _selectable => onToggleRow != null;

  @override
  Widget build(BuildContext context) {
    // Removed sortColumnIndex calculation as we no longer pass it to DataTable

    final bool allSelected =
        selected != null && selected!.length == rows.length && rows.isNotEmpty;

    return Theme(
      data: Theme.of(context).copyWith(visualDensity: VisualDensity.compact),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int getFlex(ColumnDef col) {
            final k = col.key.toLowerCase();
            // Invited suppliers / multi-value text needs lots of space
            if (k.contains('invited') || k.contains('suppliers')) return 7;
            // Group columns need extra width
            if (k.contains('group')) return 6;
            // Large text fields: customer, warehouse, name, description, item names, etc.
            if (k.contains('customer') ||
                k.contains('company') ||
                k.contains('supplier') ||
                k.contains('description') ||
                k.contains('warehouse') ||
                k.contains('location') ||
                k.contains('item') ||
                k.contains('product') ||
                k.contains('part') ||
                k.contains('title'))
              return 7;
            // Emails get wide space
            if (k.contains('email')) return 6;
            // Contacts / Persons names get 5
            if (k.contains('contact') || k.contains('name')) return 5;
            // Short text fields get 3
            if (k.contains('territory') ||
                k.contains('city') ||
                k.contains('category') ||
                k.contains('source'))
              return 3;
            // Codes get 3
            if (k.contains('code') || k.contains('id')) return 3;
            // Short fixed-width columns: dates, money, status, codes, numbers
            if (col.type == ColumnType.date) return 3;
            if (col.type == ColumnType.status) return 3;
            if (col.type == ColumnType.money) return 3;
            if (col.type == ColumnType.pct) return 3;
            if (col.type == ColumnType.numraw) return 3;
            // All other text columns get medium width
            return 4;
          }

          final int totalFlex = columns.fold(
            0,
            (sum, col) => sum + getFlex(col),
          );
          final double checkboxWidth = _selectable ? 32.0 : 0.0;
          const double horizontalMargin = 12.0;
          const double columnSpacing = 16.0;
          final int spacingCount = _selectable
              ? columns.length
              : (columns.isNotEmpty ? columns.length - 1 : 0);

          // The table must be at least wide enough for every column to have
          // a readable minimum width; on narrow viewports this exceeds
          // constraints.maxWidth and the table scrolls horizontally instead
          // of squeezing (and ellipsis-truncating) every column's text.
          final double minTableWidth = columns.length * 120.0 + checkboxWidth;
          final double layoutWidth = minTableWidth > constraints.maxWidth
              ? minTableWidth
              : constraints.maxWidth;

          final double availableWidth = layoutWidth -
              (horizontalMargin * 2) -
              (columnSpacing * spacingCount) -
              checkboxWidth;

          double? getColumnWidth(ColumnDef col) {
            if (totalFlex <= 0) return null;
            return ((availableWidth / totalFlex) * getFlex(col)).clamp(
              40.0,
              double.infinity,
            );
          }

          final table = DataTable(
            headingTextStyle: AppTypography.tableHeader,
            headingRowColor: const WidgetStatePropertyAll(IgColors.surfaceAlt),
            dataTextStyle: AppTypography.tableCell,
            dividerThickness: 1,
            columnSpacing: 16,
            horizontalMargin: 12,
            headingRowHeight: 37,
            dataRowMinHeight: 40,
            dataRowMaxHeight: double.infinity,
            showCheckboxColumn: false,
            columns: [
              if (_selectable)
                DataColumn(
                  label: SizedBox(
                    width: 32,
                    child: Transform.scale(
                      scale: 13.0 / 18.0,
                      child: Checkbox(
                        value: allSelected,
                        onChanged: onToggleAll != null
                            ? (v) => onToggleAll!(v ?? false)
                            : null,
                        splashRadius: 0,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(
                          color: IgColors.textSoft.withOpacity(0.5),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              for (final col in columns)
                DataColumn(
                  numeric: false,
                  label: Container(
                    width: getColumnWidth(col),
                    alignment:
                        (col.type == ColumnType.money ||
                            col.type == ColumnType.pct ||
                            col.type == ColumnType.numraw)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onSort == null ? null : () => onSort!(col.key),
                      child: Text(
                        col.label.toUpperCase(),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.tableHeader,
                      ),
                    ),
                  ),
                ),
            ],
            rows: [
              for (var i = 0; i < rows.length; i++)
                DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return IgColors.surfaceAlt;
                    }
                    return null;
                  }),
                  selected: selected?.contains(rows[i].id) ?? false,
                  onSelectChanged: onRowTap == null
                      ? null
                      : (v) {
                          onRowTap!(rows[i]);
                        },
                  cells: [
                    if (_selectable)
                      DataCell(
                        SizedBox(
                          width: 32,
                          child: Transform.scale(
                            scale: 13.0 / 18.0,
                            child: Checkbox(
                              value: selected?.contains(rows[i].id) ?? false,
                              onChanged: onToggleRow != null
                                  ? (v) => onToggleRow!(rows[i].id, v ?? false)
                                  : null,
                              splashRadius: 0,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              side: BorderSide(
                                color: IgColors.textSoft.withOpacity(0.5),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    for (var ci = 0; ci < columns.length; ci++)
                      DataCell(
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onRowTap != null
                              ? () => onRowTap!(rows[i])
                              : null,
                          child: Container(
                            width: getColumnWidth(columns[ci]),
                            alignment:
                                (columns[ci].type == ColumnType.money ||
                                    columns[ci].type == ColumnType.pct ||
                                    columns[ci].type == ColumnType.numraw)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: _buildCell(
                              columns[ci],
                              rows[i],
                              primary: ci == 0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          );

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: layoutWidth,
              child: table,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCell(ColumnDef col, EntityRecord rec, {required bool primary}) {
    final value = col.rawValue(rec);

    switch (col.type) {
      case ColumnType.status:
        return AppStatusChip.forStatus(value as String?);
      case ColumnType.money:
        return _numericCell(Formatters.money(value as num?));
      case ColumnType.date:
        return Text(
          Formatters.date(value as DateTime?),
          style: AppTypography.tableCell,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      case ColumnType.pct:
        return _numericCell(Formatters.percent(value as num?));
      case ColumnType.numraw:
        return _numericCell(Formatters.number(value as num?));
      case ColumnType.text:
        final text = (value == null || value == '') ? '—' : '$value';
        final isCode = primary && (
          RegExp(r'^[A-Z0-9]+-\d+$').hasMatch(text) ||
          col.key.toLowerCase().contains('code') ||
          col.key.toLowerCase().contains('number') ||
          col.key.toLowerCase().contains('id')
        );
        return Text(
          text,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isCode
              ? AppTypography.tableCellPrimary
              : AppTypography.tableCell,
        );
    }
  }

  /// Ported from `table.erp-table td.num{text-align:right}`.
  Widget _numericCell(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: AppTypography.tableCell,
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
