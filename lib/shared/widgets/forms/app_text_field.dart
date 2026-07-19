import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ported from `.form-field input` — relies on `IgTheme`'s
/// `inputDecorationTheme` for padding/border/radius/focus-color, so this is
/// a thin, purpose-named wrapper rather than a re-styled widget.
///
/// `spellCheckConfiguration: disabled` + `autocorrect/enableSuggestions:
/// false` suppress the browser's native spellcheck underline on the
/// underlying `<input>` element.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autocorrect: false,
      enableSuggestions: false,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
      decoration: InputDecoration(hintText: hintText),
    );
  }
}

/// Ported from `.form-field textarea` — `min-height:60px`, vertically
/// resizable in the browser; Flutter approximates with a fixed 3-line
/// minimum and free vertical growth.
class IgTextArea extends StatelessWidget {
  const IgTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: 3,
      maxLines: null,
      autocorrect: false,
      enableSuggestions: false,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
