import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/ig_shadows.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.toast` / `.toast.success` / `.toast.danger`.
enum IgToastVariant { standard, success, danger }

class IgToastEntry {
  const IgToastEntry({required this.id, required this.message, required this.variant});

  final int id;
  final String message;
  final IgToastVariant variant;
}

class ToastQueueNotifier extends Notifier<List<IgToastEntry>> {
  int _nextId = 0;

  @override
  List<IgToastEntry> build() => const [];

  void show(String message, {IgToastVariant variant = IgToastVariant.standard}) {
    final entry = IgToastEntry(id: _nextId++, message: message, variant: variant);
    state = [...state, entry];
    Future.delayed(const Duration(seconds: 3), () {
      state = state.where((e) => e.id != entry.id).toList();
    });
  }

  void dismiss(int id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final toastQueueProvider = NotifierProvider<ToastQueueNotifier, List<IgToastEntry>>(
  ToastQueueNotifier.new,
);

/// Ported from `#toast-wrap` — fixed top-right stack, sits just below the top nav.
class IgToastStack extends ConsumerWidget {
  const IgToastStack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toasts = ref.watch(toastQueueProvider);
    return Positioned(
      top: 72,
      right: 20,
      child: IgnorePointer(
        ignoring: toasts.isEmpty,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final toast in toasts) _ToastCard(entry: toast),
          ],
        ),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.entry});

  final IgToastEntry entry;

  Color get _color {
    switch (entry.variant) {
      case IgToastVariant.success:
        return const Color(0xFF10B981); // Emerald green status color
      case IgToastVariant.danger:
        return const Color(0xFFEF4444); // Red status color
      case IgToastVariant.standard:
        return const Color(0xFF3B82F6); // Blue status color
    }
  }

  IconData get _icon {
    switch (entry.variant) {
      case IgToastVariant.success:
        return Icons.check_circle_outline_rounded;
      case IgToastVariant.danger:
        return Icons.error_outline_rounded;
      case IgToastVariant.standard:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: const Color(0xFF0F172A), // Minimalist dark slate background
        borderRadius: BorderRadius.circular(20), // Premium pill shape
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _color.withOpacity(0.35), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _icon,
                size: 15,
                color: _color,
              ),
              const SizedBox(width: 8),
              Text(
                entry.message,
                style: AppTypography.toast.copyWith(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 150.ms).slideY(begin: -0.15, end: 0, duration: 150.ms),
    );
  }
}
