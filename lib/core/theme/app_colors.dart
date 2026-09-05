import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.accent,
    required this.accentSoft,
  });

  /// Screen background.
  final Color bg;

  /// Cards, inputs.
  final Color surface;

  /// Chips, icon chips, subtle fills.
  final Color surface2;

  /// Primary text, black hero cards.
  final Color ink;

  /// Secondary text.
  final Color ink2;

  /// Tertiary text, icons.
  final Color ink3;

  /// Borders and dividers — the 1px outline on almost every card.
  final Color line;

  /// Primary action fill.
  final Color accent;

  /// Avatar / badge tint.
  final Color accentSoft;

  static const light = AppColors(
    bg: Color(0xFFFCFCFC),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF0F0F0),
    ink: Color(0xFF000000),
    ink2: Color(0xFF525252),
    ink3: Color(0xFF868686),
    line: Color(0xFFE4E4E4),
    accent: Color(0xFF000000),
    accentSoft: Color(0xFFEBEBEB),
  );

  static const dark = AppColors(
    bg: Color(0xFF000000),
    surface: Color(0xFF090909),
    surface2: Color(0xFF222222),
    ink: Color(0xFFFFFFFF),
    ink2: Color(0xFFA4A4A4),
    ink3: Color(0xFF747474),
    line: Color(0xFF242424),
    accent: Color(0xFF2E2E2E),
    accentSoft: Color(0xFF333333),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? accent,
    Color? accentSoft,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      ink3: Color.lerp(ink3, other.ink3, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
    );
  }
}

abstract final class StatusColors {
  static const ok = Color(0xFF4B7453);
  static const warn = Color(0xFFAC844A);
  static const info = Color(0xFF506E94);
  static const danger = Color(0xFFE54B4F);
  static const approve = Color(0xFF3AA460);
  static const deny = Color(0xFFDB4241);
}
