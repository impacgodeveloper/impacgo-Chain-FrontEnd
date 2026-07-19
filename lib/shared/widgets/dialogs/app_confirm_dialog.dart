import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../core/theme/app_typography.dart';
import '../buttons/app_button.dart';
import 'app_dialog.dart';

/// Ported from `openConfirmDialog(title, msg, onConfirm)`.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
}) async {
  final result = await showAppDialog<bool>(
    context,
    size: AppDialogSize.narrow,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDialogHead(title: title, onClose: () => Navigator.of(context).pop(false)),
        AppDialogBody(
          child: Text(
            message,
            style: AppTypography.confirmMessage,
          ),
        ),
        AppDialogFoot(
          actions: [
            AppButton(label: 'Cancel', onPressed: () => Navigator.of(context).pop(false)),
            AppButton(
              label: confirmLabel,
              variant: AppButtonVariant.danger,
              icon: FeatherIcons.trash,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}
