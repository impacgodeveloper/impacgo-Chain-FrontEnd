import 'package:flutter/material.dart';
import 'ig_colors.dart';

class IgTheme {
  IgTheme._();

  static const double radius = 12;
  static const double radiusSm = 8;

  static ThemeData get light {
    final base = IgColors.isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final textTheme = base.textTheme
        .apply(fontFamily: 'Inter')
        .apply(bodyColor: IgColors.text, displayColor: IgColors.text);

    return base.copyWith(
      brightness: IgColors.isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: IgColors.bg,
      canvasColor: IgColors.surface,
      iconTheme: const IconThemeData(color: IgColors.textSoft),
      colorScheme: base.colorScheme.copyWith(
        brightness: IgColors.isDark ? Brightness.dark : Brightness.light,
        primary: IgColors.primary,
        secondary: IgColors.purple,
        surface: IgColors.surface,
        error: IgColors.danger,
        onSurface: IgColors.text,
        onSurfaceVariant: IgColors.textSoft,
        onPrimary: Colors.white,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: IgColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: IgColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: IgColors.border,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: IgColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: IgColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: IgColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: IgColors.primary, width: 1.5),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: IgColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFFAEB9C9);
          }
          return const Color(0xFFC7D1DE);
        }),
        trackColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        thickness: const WidgetStatePropertyAll<double?>(9),
        radius: const Radius.circular(8),
        interactive: true,
      ),
    );
  }
}
