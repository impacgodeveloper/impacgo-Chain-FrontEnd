import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers/mock_database_provider.dart';
import '../../application/providers/record_extra_provider.dart';
import '../../core/theme/ig_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utilities/formatters.dart';
import '../../domain/entities/entity_record.dart';
import '../../domain/entities/record_extra.dart';
import '../../domain/schema/column_def.dart';
import '../../domain/schema/entity_schema.dart';
import '../../domain/schema/field_def.dart';
import '../../domain/schema/nav_registry.dart';
import '../../domain/schema/schema_registry.dart';
import '../../shared/widgets/buttons/app_button.dart';
import '../../shared/widgets/cards/app_section_header.dart';
import '../../shared/widgets/chips/app_status_chip.dart';
import '../../shared/widgets/dialogs/app_confirm_dialog.dart';
import '../../shared/widgets/drawers/app_drawer.dart';
import '../../shared/widgets/layout/ig_toast.dart';
import 'entity_form_dialog.dart';

/// Ported from `renderDrawer()` — opens the record detail drawer for
/// `entityKey`/`recordId`.
Future<void> showEntityDetailDrawer(
  BuildContext context, {
  required String entityKey,
  required int recordId,
}) {
  return showAppDrawer(
    context,
    builder: (context) => EntityDetailDrawerBody(entityKey: entityKey, recordId: recordId),
  );
}

class EntityDetailDrawerBody extends ConsumerStatefulWidget {
  const EntityDetailDrawerBody({super.key, required this.entityKey, required this.recordId});

  final String entityKey;
  final int recordId;

  @override
  ConsumerState<EntityDetailDrawerBody> createState() => _EntityDetailDrawerBodyState();
}

class _EntityDetailDrawerBodyState extends ConsumerState<EntityDetailDrawerBody> {
  String _tab = 'overview';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const _tabs = [
    ('overview', 'Overview', FeatherIcons.info),
    ('timeline', 'Activity Timeline', FeatherIcons.activity),
    ('attachments', 'Attachments', FeatherIcons.paperclip),
    ('comments', 'Comments', FeatherIcons.messageCircle),
    ('audit', 'Audit Log', FeatherIcons.checkSquare),
  ];

  @override
  Widget build(BuildContext context) {
    ref.watch(mockDatabaseRevisionProvider);
    final db = ref.watch(mockDatabaseProvider);
    final rec = db.findById(widget.entityKey, widget.recordId);

    if (rec == null) {
      return const SizedBox.shrink();
    }

    final schema = SchemaRegistry.of(widget.entityKey);
    final navItem = NavRegistry.entitiesByKey[widget.entityKey];
    final title = (rec[schema.primaryKey] ?? rec[schema.numberKey] ?? 'Record #${rec.id}').toString();
    final sub = schema.subKey != null ? rec[schema.subKey!]?.toString() : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: IgColors.border))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.drawerTitle),
                    const SizedBox(height: 2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          [navItem?.label, sub].whereType<String>().join(' · '),
                          style: AppTypography.drawerSubtitle,
                        ),
                        if (rec.status != null) ...[
                          Text('·', style: AppTypography.drawerSubtitle),
                          AppStatusChip.forStatus(rec.status),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppSecondaryButton(
                          label: 'Edit', icon: FeatherIcons.edit2, size: AppButtonSize.sm,
                          onPressed: () async {
                            await showEntityFormDialog(context, entityKey: widget.entityKey, recordId: widget.recordId);
                          },
                        ),
                        ..._approvalButtons(schema, rec),
                        AppButton(
                          label: 'Delete', icon: FeatherIcons.trash2, size: AppButtonSize.sm,
                          variant: AppButtonVariant.danger,
                          onPressed: () => _delete(schema, navItem?.label ?? widget.entityKey, title),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(
                    color: IgColors.surfaceAlt,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(FeatherIcons.x, size: 16, color: IgColors.textSoft),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: IgColors.surface,
            border: Border(bottom: BorderSide(color: IgColors.border)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (key, label, _) in _tabs)
                  InkWell(
                    onTap: () => setState(() => _tab = key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: _tab == key ? IgColors.primary : Colors.transparent, width: 2),
                        ),
                      ),
                      child: Text(label, style: _tab == key ? AppTypography.drawerTabActive : AppTypography.drawerTab),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: switch (_tab) {
                'overview' => _OverviewTab(schema: schema, rec: rec),
                'timeline' => _TimelineTab(entityKey: widget.entityKey, schema: schema, rec: rec),
                'attachments' => _AttachmentsTab(entityKey: widget.entityKey, rec: rec),
                'comments' => _CommentsTab(entityKey: widget.entityKey, rec: rec),
                'audit' => _AuditTab(entityKey: widget.entityKey, rec: rec),
                _ => const SizedBox.shrink(),
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _approvalButtons(EntitySchema schema, EntityRecord rec) {
    if (!schema.approval) return const [];
    if (rec.status == 'Pending Approval') {
      return [
        AppButton(
          label: 'Approve', icon: FeatherIcons.check, size: AppButtonSize.sm, variant: AppButtonVariant.accent,
          onPressed: () => _approve(schema, rec),
        ),
        AppButton(
          label: 'Reject', icon: FeatherIcons.x, size: AppButtonSize.sm, variant: AppButtonVariant.danger,
          onPressed: () => _reject(schema, rec),
        ),
      ];
    }
    if (rec.status == 'Draft') {
      return [
        AppButton(
          label: 'Submit for Approval', icon: FeatherIcons.check, size: AppButtonSize.sm,
          onPressed: () => _submit(rec),
        ),
      ];
    }
    return const [];
  }

  void _approve(EntitySchema schema, EntityRecord rec) {
    final opts = schema.statusField?.options ?? const [];
    rec['status'] = opts.contains('Approved') ? 'Approved' : (opts.isNotEmpty ? opts[opts.length >= 3 ? 2 : opts.length - 1] : 'Approved');
    ref.read(recordExtraProvider.notifier).addTimelineEvent(widget.entityKey, rec.id, 'Record approved', icon: 'check');
    bumpMockDatabaseRevision(ref);
    ref.read(toastQueueProvider.notifier).show('Record approved.', variant: IgToastVariant.success);
  }

  void _reject(EntitySchema schema, EntityRecord rec) {
    final opts = schema.statusField?.options ?? const [];
    rec['status'] = opts.contains('Rejected') ? 'Rejected' : 'Draft';
    ref.read(recordExtraProvider.notifier).addTimelineEvent(widget.entityKey, rec.id, 'Record rejected', icon: 'x');
    bumpMockDatabaseRevision(ref);
    ref.read(toastQueueProvider.notifier).show('Record rejected.', variant: IgToastVariant.danger);
  }

  void _submit(EntityRecord rec) {
    rec['status'] = 'Pending Approval';
    ref.read(recordExtraProvider.notifier).addTimelineEvent(widget.entityKey, rec.id, 'Submitted for approval', icon: 'clock');
    bumpMockDatabaseRevision(ref);
    ref.read(toastQueueProvider.notifier).show('Submitted for approval.', variant: IgToastVariant.success);
  }

  Future<void> _delete(EntitySchema schema, String label, String title) async {
    if (!mounted) return;
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Delete "$title"?',
      message: 'This will permanently remove this ${label.toLowerCase()} record. This action cannot be undone in this session.',
    );
    if (!confirmed) return;
    if (!mounted) return;
    ref.read(mockDatabaseProvider).deleteById(widget.entityKey, widget.recordId);
    bumpMockDatabaseRevision(ref);
    if (mounted) Navigator.of(context).pop();
    ref.read(toastQueueProvider.notifier).show('Record deleted.', variant: IgToastVariant.danger);
  }
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.schema, required this.rec});
  final EntitySchema schema;
  final EntityRecord rec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = rec['lines'] as List<dynamic>?;
    final links = <(String, String, String)>[
      if (rec['quotationRef'] != null) ('Quotation', rec['quotationRef'] as String, 'quotations'),
      if (rec['salesOrderRef'] != null) ('Sales Order', rec['salesOrderRef'] as String, 'salesOrders'),
      if (rec['deliveryRef'] != null) ('Delivery Note', rec['deliveryRef'] as String, 'deliveryNotes'),
      if (rec['invoiceRef'] != null) ('Invoice', rec['invoiceRef'] as String, 'salesInvoices'),
      if (rec['rfqRef'] != null) ('RFQ', rec['rfqRef'] as String, 'rfqs'),
      if (rec['poRef'] != null) ('Purchase Order', rec['poRef'] as String, 'purchaseOrders'),
      if (rec['grnRef'] != null) ('Purchase Receipt', rec['grnRef'] as String, 'purchaseReceipts'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Record Details', first: true),
        _FieldGrid(schema: schema, rec: rec),
        if (lines != null && lines.isNotEmpty) ...[
          const AppSectionHeader('Line Items'),
          _LineItemsTable(lines: lines),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: AppTypography.kvInline,
              children: [
                const TextSpan(text: 'Total\n'),
                TextSpan(text: Formatters.money(rec['amount'] as num?), style: AppTypography.kvInlineBold),
              ],
            ),
          ),
        ],
        if (links.isNotEmpty) ...[
          const AppSectionHeader('Related Documents'),
          for (final (label, code, targetKey) in links)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label.toUpperCase(), style: AppTypography.fieldLabel),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: () => _openRelated(context, ref, targetKey, code),
                    child: Text(
                      code,
                      style: AppTypography.fieldValue.copyWith(color: IgColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  void _openRelated(BuildContext context, WidgetRef ref, String targetKey, String code) {
    final db = ref.read(mockDatabaseProvider);
    final target = db[targetKey].where((r) => r[SchemaRegistry.of(targetKey).numberKey] == code).firstOrNull;
    Navigator.of(context).pop();
    context.go('/entity/$targetKey');
    if (target != null) {
      Future.delayed(const Duration(milliseconds: 80), () {
        final rootContext = context.mounted ? context : null;
        if (rootContext != null) {
          showEntityDetailDrawer(rootContext, entityKey: targetKey, recordId: target.id);
        }
      });
    }
  }
}

extension _FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.schema, required this.rec});
  final EntitySchema schema;
  final EntityRecord rec;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 8,
      children: [
        for (final f in schema.fields)
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.label.toUpperCase(), style: AppTypography.fieldLabel),
                const SizedBox(height: 3),
                f.key == 'status'
                    ? AppStatusChip.forStatus(rec.status)
                    : Text(_displayValue(f), style: AppTypography.fieldValue),
              ],
            ),
          ),
      ],
    );
  }

  String _displayValue(FieldDef f) {
    final v = rec[f.key];
    if (f.type == FieldType.number) return Formatters.money(v as num?);
    if (f.type == FieldType.date) return Formatters.date(v as DateTime?);
    if (v == null || v == '') return '—';
    return '$v';
  }
}

class _LineItemsTable extends StatelessWidget {
  const _LineItemsTable({required this.lines});
  final List<dynamic> lines;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: IgColors.border),
        bottom: BorderSide(color: IgColors.border),
      ),
      columnWidths: const {
        0: FlexColumnWidth(3), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5), 4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: IgColors.surfaceAlt),
          children: [
            for (final h in const ['Item', 'UOM', 'Qty', 'Rate', 'Amount'])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(h.toUpperCase(), style: AppTypography.fieldLabel),
              ),
          ],
        ),
        for (final l in lines)
          TableRow(
            children: [
              _cell('${l['item']}'),
              _cell('${l['uom']}'),
              _cell('${l['qty']}'),
              _cell(Formatters.money(l['rate'] as num?)),
              _cell(Formatters.money(l['amount'] as num?)),
            ],
          ),
      ],
    );
  }

  Widget _cell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(text, style: AppTypography.tableCell),
      );
}

class _TimelineTab extends ConsumerWidget {
  const _TimelineTab({required this.entityKey, required this.schema, required this.rec});
  final String entityKey;
  final EntitySchema schema;
  final EntityRecord rec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extraMap = ref.watch(recordExtraProvider);
    final extra = extraMap['$entityKey:${rec.id}'] ?? ref.read(recordExtraProvider.notifier).of(entityKey, rec.id);
    final navItem = NavRegistry.entitiesByKey[entityKey];
    final events = <TimelineEvent>[
      TimelineEvent(
        title: '${navItem?.singularLabel ?? entityKey} created',
        who: (rec['salesPerson'] ?? rec['requestedBy'] ?? 'System').toString(),
        date: rec.createdAt,
        icon: 'plus',
      ),
      if (rec.status != null && rec.status != 'Draft' && rec.status != 'New')
        TimelineEvent(
          title: 'Status set to "${rec.status}"',
          who: 'Sarah Alvarez',
          date: rec.createdAt.add(const Duration(days: 1)),
          icon: 'activity',
        ),
      ...extra.timelineExtra,
    ]..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Activity Timeline', first: true),
        for (var i = 0; i < events.length; i++) _TimelineItem(event: events[i], isLast: i == events.length - 1),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});
  final TimelineEvent event;
  final bool isLast;

  IconData get _icon => switch (event.icon) {
        'plus' => FeatherIcons.plus,
        'check' => FeatherIcons.check,
        'x' => FeatherIcons.x,
        'clock' => FeatherIcons.clock,
        _ => FeatherIcons.zap,
      };

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 23, height: 23, alignment: Alignment.center,
                decoration: BoxDecoration(color: IgColors.primarySoft, shape: BoxShape.circle),
                child: Icon(_icon, size: 13, color: IgColors.primary),
              ),
              if (!isLast) Expanded(child: Container(width: 1, color: IgColors.border)),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: AppTypography.timelineTitle),
                  Text('${event.who} · ${Formatters.dateTime(event.date)}', style: AppTypography.timelineMeta),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentsTab extends ConsumerStatefulWidget {
  const _AttachmentsTab({required this.entityKey, required this.rec});
  final String entityKey;
  final EntityRecord rec;

  @override
  ConsumerState<_AttachmentsTab> createState() => _AttachmentsTabState();
}

class _AttachmentsTabState extends ConsumerState<_AttachmentsTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extraMap = ref.watch(recordExtraProvider);
    final extra = extraMap['${widget.entityKey}:${widget.rec.id}'] ?? ref.read(recordExtraProvider.notifier).of(widget.entityKey, widget.rec.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Attachments', first: true),
        if (extra.attachments.isEmpty) Text('No attachments yet.', style: AppTypography.hint),
        for (final a in extra.attachments)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: IgColors.border))),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32, alignment: Alignment.center,
                  decoration: BoxDecoration(color: IgColors.infoSoft, borderRadius: BorderRadius.circular(6)),
                  child: Icon(FeatherIcons.fileText, size: 16, color: IgColors.info),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.name, style: AppTypography.attachmentName),
                      Text('${a.size} · uploaded by ${a.uploadedBy} · ${Formatters.date(a.date)}', style: AppTypography.attachmentMeta),
                    ],
                  ),
                ),
                AppButton(
                  label: '', icon: FeatherIcons.trash, size: AppButtonSize.sm, variant: AppButtonVariant.ghost,
                  onPressed: () => ref.read(recordExtraProvider.notifier).removeAttachment(widget.entityKey, widget.rec.id, a.id),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autocorrect: false,
                enableSuggestions: false,
                spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
                decoration: const InputDecoration(hintText: 'File name, e.g. Contract_Signed.pdf'),
              ),
            ),
            const SizedBox(width: 8),
            AppButton(
              label: 'Add', icon: FeatherIcons.paperclip, variant: AppButtonVariant.primary, size: AppButtonSize.sm,
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;
                ref.read(recordExtraProvider.notifier).addAttachment(widget.entityKey, widget.rec.id, _controller.text.trim());
                _controller.clear();
                ref.read(toastQueueProvider.notifier).show('Attachment added.', variant: IgToastVariant.success);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentsTab extends ConsumerStatefulWidget {
  const _CommentsTab({required this.entityKey, required this.rec});
  final String entityKey;
  final EntityRecord rec;

  @override
  ConsumerState<_CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends ConsumerState<_CommentsTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extraMap = ref.watch(recordExtraProvider);
    final extra = extraMap['${widget.entityKey}:${widget.rec.id}'] ?? ref.read(recordExtraProvider.notifier).of(widget.entityKey, widget.rec.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Comments', first: true),
        if (extra.comments.isEmpty) Text('No comments yet — start the discussion below.', style: AppTypography.hint),
        for (final c in extra.comments)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28, height: 28, alignment: Alignment.center,
                  decoration: BoxDecoration(color: IgColors.purpleSoft, shape: BoxShape.circle),
                  child: Text(Formatters.initials(c.author), style: AppTypography.commentAvatarInitials),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(text: c.author, style: AppTypography.commentAuthor),
                        TextSpan(text: '  ${Formatters.dateTime(c.date)}', style: AppTypography.commentTime),
                      ])),
                      Text(c.text, style: AppTypography.commentText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 2, maxLines: 4,
                autocorrect: false,
                enableSuggestions: false,
                spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
                decoration: const InputDecoration(hintText: 'Add a comment for the team…'),
              ),
            ),
            const SizedBox(width: 8),
            AppButton(
              label: 'Post', icon: FeatherIcons.send, variant: AppButtonVariant.primary, size: AppButtonSize.sm,
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;
                ref.read(recordExtraProvider.notifier).addComment(widget.entityKey, widget.rec.id, _controller.text.trim());
                _controller.clear();
                ref.read(toastQueueProvider.notifier).show('Comment posted.', variant: IgToastVariant.success);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _AuditTab extends ConsumerWidget {
  const _AuditTab({required this.entityKey, required this.rec});
  final String entityKey;
  final EntityRecord rec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extraMap = ref.watch(recordExtraProvider);
    final extra = extraMap['$entityKey:${rec.id}'] ?? ref.read(recordExtraProvider.notifier).of(entityKey, rec.id);
    final rows = <(String, DateTime, String)>[
      ((rec['salesPerson'] ?? rec['requestedBy'] ?? 'System Import').toString(), rec.createdAt, 'Created record'),
      ('Sarah Alvarez', rec.createdAt.add(const Duration(days: 2)), 'Modified field values'),
      for (final e in extra.timelineExtra) (e.who, e.date, e.title),
    ]..sort((a, b) => b.$2.compareTo(a.$2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Audit Log', first: true),
        for (final (who, whenDate, action) in rows)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: IgColors.border))),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    who,
                    style: AppTypography.auditRow.copyWith(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(action, style: AppTypography.auditRow)),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    Formatters.dateTime(whenDate),
                    style: AppTypography.auditWhen,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
