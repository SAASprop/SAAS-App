import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saas_app/core/theme/app_typography.dart';

void main() {
  // google_fonts reads from the asset bundle, which needs a live binding.
  // Without this it still works but logs an error for every style it builds.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // google_fonts would otherwise try to download font files over the network
    // during tests. Disable it so tests are deterministic and offline-safe.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('emToPx', () {
    test('converts the spec CSS tracking to logical pixels', () {
      // The splash tagline: .18em at 11px.
      expect(AppTypography.emToPx(0.18, 11), closeTo(1.98, 0.001));

      // The design's uppercase caption: .14em at 11px.
      expect(AppTypography.emToPx(0.14, 11), closeTo(1.54, 0.001));
    });

    test('scales with font size', () {
      expect(AppTypography.emToPx(0.1, 20), closeTo(2.0, 0.001));
    });
  });

  group('named roles match the spec sizes', () {
    test('display type', () {
      expect(AppTypography.display.fontSize, 27);
      expect(AppTypography.cardTitle.fontSize, 28);
      expect(AppTypography.statValue.fontSize, 25);
    });

    test('UI type', () {
      expect(AppTypography.body.fontSize, 13);
      expect(AppTypography.body.fontWeight, FontWeight.w400);

      expect(AppTypography.label.fontSize, 13);
      expect(AppTypography.label.fontWeight, FontWeight.w500);

      expect(AppTypography.meta.fontSize, 11);
      expect(AppTypography.meta.fontWeight, FontWeight.w500);
    });

    test('caption carries the spec tracking', () {
      expect(AppTypography.caption.fontSize, 11);
      expect(AppTypography.caption.letterSpacing, closeTo(1.54, 0.001));
    });

    test('styles carry no colour, so they work on any background', () {
      // Colour is applied at the call site from theme tokens. Baking one in
      // here would make the style unusable over the splash video.
      expect(AppTypography.body.color, isNull);
      expect(AppTypography.display.color, isNull);
    });
  });

  group('textTheme', () {
    test('applies the given ink colour to every slot', () {
      const ink = Color(0xFF123456);
      final theme = AppTypography.textTheme(ink);

      expect(theme.displayLarge?.color, ink);
      expect(theme.titleLarge?.color, ink);
      expect(theme.bodyMedium?.color, ink);
      expect(theme.labelLarge?.color, ink);
      expect(theme.labelSmall?.color, ink);
    });
  });
}
