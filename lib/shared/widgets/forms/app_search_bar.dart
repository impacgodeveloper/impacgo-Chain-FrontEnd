import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/ig_colors.dart';
import '../../../core/theme/ig_radii.dart';
import '../../../core/theme/app_typography.dart';

/// Ported from `.tb-search` — an icon-prefixed search input used in every
/// list toolbar, constrained to `min-width:180px;max-width:320px`.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    required this.value,
    required this.onChanged,
  });

  final String hintText;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  bool _focused = false;

  @override
  void didUpdateWidget(covariant AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(text: widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 320),
      child: Focus(
        onFocusChange: (has) => setState(() => _focused = has),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: IgRadii.rMd,
            border: Border.all(
              color: _focused ? IgColors.primary : IgColors.borderStrong,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(FeatherIcons.search, size: 16, color: IgColors.textFaint),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  autocorrect: false,
                  enableSuggestions: false,
                  spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
                  style: AppTypography.formInput.copyWith(fontSize: 12.5),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintText: widget.hintText,
                    hintStyle: AppTypography.formInput.copyWith(
                      fontSize: 12.5,
                      color: IgColors.textFaint,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
