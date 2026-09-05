import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.bg,

      extensions: [colors],

      textTheme: AppTypography.textTheme(colors.ink),

      colorScheme:
          ColorScheme.fromSeed(
            seedColor: colors.ink,
            brightness: brightness,
          ).copyWith(
            surface: colors.surface,
            onSurface: colors.ink,
            outline: colors.line,
          ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.bg,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
