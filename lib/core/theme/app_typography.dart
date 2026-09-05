import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static double emToPx(double em, double fontSize) => em * fontSize;

  static TextStyle serif({
    double size = 27,
    double height = 1.05,
    Color? color,
  }) {
    return GoogleFonts.instrumentSerif(
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: height,
      color: color,
    );
  }

  static TextStyle geist({
    double size = 13,
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.geist(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // --- Named roles from the design ---------------------------------------

  static TextStyle get display => serif(size: 27);

  static TextStyle get cardTitle => serif(size: 28, height: 1.1);

  static TextStyle get statValue => serif(size: 25, height: 1.1);

  static TextStyle get body => geist(size: 13);

  static TextStyle get label => geist(size: 13, weight: FontWeight.w500);

  static TextStyle get meta => geist(size: 11, weight: FontWeight.w500);

  static TextStyle get caption =>
      geist(size: 11, weight: FontWeight.w500, letterSpacing: emToPx(0.14, 11));

  static TextTheme textTheme(Color ink) {
    return TextTheme(
      displayLarge: display.copyWith(color: ink),
      titleLarge: cardTitle.copyWith(color: ink),
      bodyMedium: body.copyWith(color: ink),
      labelLarge: label.copyWith(color: ink),
      labelSmall: meta.copyWith(color: ink),
    );
  }
}
