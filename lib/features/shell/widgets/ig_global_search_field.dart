import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/ig_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/schema/entity_nav_item.dart';
import '../../../domain/schema/nav_registry.dart';

/// Ported from `#tn-search-wrap` / `#tn-search` / `#tn-search-results`.
class IgGlobalSearchField extends ConsumerStatefulWidget {
  const IgGlobalSearchField({super.key});

  @override
  ConsumerState<IgGlobalSearchField> createState() =>
      _IgGlobalSearchFieldState();
}

class _IgGlobalSearchFieldState extends ConsumerState<IgGlobalSearchField> {
  final _layerLink = LayerLink();
  final _overlayController = OverlayPortalController();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _overlayController.hide();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<EntityNavItem> get _matches {
    final q = _controller.text.trim().toLowerCase();
    if (q.length < 2) return const [];
    return NavRegistry.entitiesByKey.values
        .where(
          (e) =>
              e.label.toLowerCase().contains(q) ||
              e.group.toLowerCase().contains(q),
        )
        .take(8)
        .toList();
  }

  void _onChanged(String value) {
    setState(() {});
    if (value.length >= 2) {
      _overlayController.show();
    } else {
      _overlayController.hide();
    }
  }

  void _select(EntityNavItem item) {
    _controller.clear();
    _overlayController.hide();
    _focusNode.unfocus();
    context.go('/entity/${item.key}');
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 6),
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 320,
                  maxWidth: 420,
                  maxHeight: 420,
                ),
                child: Material(
                  color: IgColors.surface,
                  borderRadius: IgRadii.rMd,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    decoration: const BoxDecoration(boxShadow: IgShadows.lg),
                    child: _buildResultsList(),
                  ),
                ),
              ),
            ),
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: _focusNode.hasFocus
                  ? IgColors.surface
                  : IgColors.surfaceAlt,
              borderRadius: IgRadii.rMd,
              border: Border.all(
                color: _focusNode.hasFocus
                    ? IgColors.primary
                    : IgColors.border,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(
                  FeatherIcons.search,
                  size: 18,
                  color: IgColors.textSoft,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onChanged,
                    onTap: () {
                      if (_controller.text.length >= 2) {
                        _overlayController.show();
                      }
                    },
                    autocorrect: false,
                    enableSuggestions: false,
                    spellCheckConfiguration:
                        const SpellCheckConfiguration.disabled(),
                    style: AppTypography.tnSearch.copyWith(
                      color: IgColors.text,
                      fontSize: 13,
                    ),
                    cursorColor: IgColors.text,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      hintText: 'Search customers, orders, items, suppliers...',
                      hintStyle: AppTypography.tnSearch.copyWith(
                        color: IgColors.textFaint,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final matches = _matches;
    if (matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          'No matches found for "${_controller.text}"',
          style: AppTypography.searchResultSub,
        ),
      );
    }
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text('MODULES', style: AppTypography.searchGroupLabel),
        ),
        for (final item in matches)
          InkWell(
            onTap: () => _select(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: IgColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      item.label,
                      style: AppTypography.searchResultTitle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(item.group, style: AppTypography.searchResultSub),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
