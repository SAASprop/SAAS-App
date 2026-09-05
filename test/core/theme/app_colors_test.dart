import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_app/core/theme/app_colors.dart';

/// Locks the colour tokens to the values in handoff/01-foundation-spec.md.
///
/// The design spec is the source of truth and these hexes were copied from it
/// verbatim. If someone "tidies" a colour or eyeballs a new one, this fails and
/// says so, rather than the difference shipping unnoticed.
void main() {
  group('AppColors.light matches the spec table', () {
    test('tokens', () {
      const c = AppColors.light;
      expect(c.bg, const Color(0xFFFCFCFC));
      expect(c.surface, const Color(0xFFFFFFFF));
      expect(c.surface2, const Color(0xFFF0F0F0));
      expect(c.ink, const Color(0xFF000000));
      expect(c.ink2, const Color(0xFF525252));
      expect(c.ink3, const Color(0xFF868686));
      expect(c.line, const Color(0xFFE4E4E4));
      expect(c.accent, const Color(0xFF000000));
      expect(c.accentSoft, const Color(0xFFEBEBEB));
    });
  });

  group('AppColors.dark matches the spec table', () {
    test('tokens', () {
      const c = AppColors.dark;
      expect(c.bg, const Color(0xFF000000));
      expect(c.surface, const Color(0xFF090909));
      expect(c.surface2, const Color(0xFF222222));
      expect(c.ink, const Color(0xFFFFFFFF));
      expect(c.ink2, const Color(0xFFA4A4A4));
      expect(c.ink3, const Color(0xFF747474));
      expect(c.line, const Color(0xFF242424));
      expect(c.accent, const Color(0xFF2E2E2E));
      expect(c.accentSoft, const Color(0xFF333333));
    });
  });

  group('StatusColors are theme independent', () {
    test('tokens', () {
      expect(StatusColors.ok, const Color(0xFF4B7453));
      expect(StatusColors.warn, const Color(0xFFAC844A));
      expect(StatusColors.info, const Color(0xFF506E94));
      expect(StatusColors.danger, const Color(0xFFE54B4F));
      expect(StatusColors.approve, const Color(0xFF3AA460));
      expect(StatusColors.deny, const Color(0xFFDB4241));
    });
  });

  group('ThemeExtension contract', () {
    test('lerp interpolates rather than snapping', () {
      // If lerp returned `this`, a light/dark switch would jump instead of
      // cross-fading. Halfway between the two backgrounds must be neither.
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);

      expect(mid.bg, isNot(AppColors.light.bg));
      expect(mid.bg, isNot(AppColors.dark.bg));
    });

    test('lerp returns the endpoints at t = 0 and t = 1', () {
      expect(AppColors.light.lerp(AppColors.dark, 0).bg, AppColors.light.bg);
      expect(AppColors.light.lerp(AppColors.dark, 1).bg, AppColors.dark.bg);
    });

    test('copyWith changes only the named token', () {
      final changed = AppColors.light.copyWith(ink: const Color(0xFF123456));

      expect(changed.ink, const Color(0xFF123456));
      expect(changed.bg, AppColors.light.bg);
      expect(changed.line, AppColors.light.line);
    });
  });

  testWidgets('tokens resolve from the widget tree', (tester) async {
    late AppColors resolved;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Builder(
          builder: (context) {
            resolved = Theme.of(context).extension<AppColors>()!;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(resolved.ink2, const Color(0xFF525252));
  });
}
