import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/mock_database_provider.dart';
import '../../domain/entities/entity_record.dart';
import '../../domain/schema/entity_schema.dart';
import '../../domain/schema/field_def.dart';
import '../../domain/schema/nav_registry.dart';
import '../../domain/schema/schema_registry.dart';
import '../../infrastructure/mock/mock_database.dart';
import '../../shared/widgets/buttons/app_button.dart';
import '../../shared/widgets/dialogs/app_dialog.dart';
import '../../shared/widgets/forms/ig_date_field.dart';
import '../../shared/widgets/forms/ig_form_field.dart';
import '../../shared/widgets/forms/app_dropdown.dart';
import '../../shared/widgets/forms/app_text_field.dart';
import '../../shared/widgets/layout/ig_toast.dart';

/// Ported from `openFormDialog(key,id)` — the create/edit dialog whose
/// fields are entirely driven by `EntitySchema.fields`.
Future<bool> showEntityFormDialog(
  BuildContext context, {
  required String entityKey,
  int? recordId,
}) async {
  final result = await showAppDialog<bool>(
    context,
    builder: (context) => EntityFormDialogBody(entityKey: entityKey, recordId: recordId),
  );
  return result ?? false;
}

class EntityFormDialogBody extends ConsumerStatefulWidget {
  const EntityFormDialogBody({super.key, required this.entityKey, this.recordId});

  final String entityKey;
  final int? recordId;

  @override
  ConsumerState<EntityFormDialogBody> createState() => _EntityFormDialogBodyState();
}

class _EntityFormDialogBodyState extends ConsumerState<EntityFormDialogBody> {
  late final EntitySchema _schema;
  late final Map<String, dynamic> _values;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _schema = SchemaRegistry.of(widget.entityKey);
    final db = ref.read(mockDatabaseProvider);
    final rec = widget.recordId != null ? db.findById(widget.entityKey, widget.recordId!) : null;
    _values = {for (final f in _schema.fields) f.key: rec?[f.key]};
    for (final f in _schema.fields) {
      if (f.type == FieldType.text || f.type == FieldType.number || f.type == FieldType.textarea) {
        _controllers[f.key] = TextEditingController(text: _values[f.key]?.toString() ?? '');
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildInput(FieldDef f, MockDatabase db) {
    switch (f.type) {
      case FieldType.select:
        final options = f.resolveOptions(db);
        return AppDropdown<String>(
          value: options.contains(_values[f.key]) ? _values[f.key] as String? : null,
          items: [for (final o in options) DropdownMenuItem(value: o, child: Text(o))],
          onChanged: (v) => setState(() => _values[f.key] = v),
        );
      case FieldType.date:
        return IgDateField(
          value: _values[f.key] as DateTime?,
          onChanged: (d) => setState(() => _values[f.key] = d),
        );
      case FieldType.number:
        return AppTextField(
          controller: _controllers[f.key],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) => _values[f.key] = double.tryParse(v) ?? 0,
        );
      case FieldType.textarea:
        return IgTextArea(controller: _controllers[f.key], onChanged: (v) => _values[f.key] = v);
      case FieldType.text:
        return AppTextField(controller: _controllers[f.key], onChanged: (v) => _values[f.key] = v);
    }
  }

  void _save() {
    final db = ref.read(mockDatabaseProvider);
    for (final f in _schema.fields) {
      if (f.required) {
        final v = _values[f.key];
        if (v == null || (v is String && v.trim().isEmpty)) {
          ref.read(toastQueueProvider.notifier).show('"${f.label}" is required.', variant: IgToastVariant.danger);
          return;
        }
      }
    }

    if (widget.recordId != null) {
      final rec = db.findById(widget.entityKey, widget.recordId!)!;
      for (final entry in _values.entries) {
        rec[entry.key] = entry.value;
      }
      ref.read(toastQueueProvider.notifier).show('Changes saved.', variant: IgToastVariant.success);
    } else {
      final id = db.nextRuntimeId();
      final data = <String, dynamic>{'id': id, 'createdAt': DateTime.now(), ..._values};
      if ((data[_schema.numberKey] == null || '${data[_schema.numberKey]}'.isEmpty)) {
        final prefix = widget.entityKey.length >= 4
            ? widget.entityKey.substring(0, 4).toUpperCase()
            : widget.entityKey.toUpperCase();
        data[_schema.numberKey] = '$prefix-${id.toString().padLeft(5, '0')}';
      }
      db.insert(widget.entityKey, EntityRecord(data));
      ref.read(toastQueueProvider.notifier).show('New record created.', variant: IgToastVariant.success);
    }
    bumpMockDatabaseRevision(ref);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(mockDatabaseProvider);
    final isEdit = widget.recordId != null;
    final navItem = NavRegistry.entitiesByKey[widget.entityKey];
    final label = navItem?.singularLabel ?? widget.entityKey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDialogHead(title: '${isEdit ? 'Edit' : 'Create New'} $label'),
        AppDialogBody(
          child: IgFormGrid(
            children: [
              for (final f in _schema.fields)
                IgFormField(
                  label: f.label,
                  required: f.required,
                  full: f.type == FieldType.textarea,
                  child: _buildInput(f, db),
                ),
            ],
          ),
        ),
        AppDialogFoot(
          actions: [
            AppButton(label: 'Cancel', onPressed: () => Navigator.of(context).pop(false)),
            AppButton(
              label: 'Save $label',
              variant: AppButtonVariant.primary,
              icon: FeatherIcons.check,
              onPressed: _save,
            ),
          ],
        ),
      ],
    );
  }
}

