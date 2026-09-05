import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_x.dart';
import '../../../core/theme/app_typography.dart';

/// Placeholder for Batch 2 (SSO login).
///
/// It exists so the splash has somewhere to land, and doubles as a smoke test
/// for the foundation: if both fonts render and these colours flip with the
/// device theme, the token wiring is correct.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SAAS People',
              style: AppTypography.display.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 10),
            Text(
              'BATCH 2 - SSO LOGIN',
              style: AppTypography.caption.copyWith(color: colors.ink3),
            ),
          ],
        ),
      ),
    );
  }
}
