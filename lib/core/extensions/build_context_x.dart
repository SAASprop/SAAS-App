import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shorthand for reading theme values off the tree.
///
/// `Theme.of(context).extension<AppColors>()!` at every call site is noise;
/// `context.colors.ink2` is the same lookup with the ceremony hidden.
extension BuildContextX on BuildContext {
  /// The active token set — light or dark, resolved from this position in the
  /// widget tree.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  TextTheme get textStyles => Theme.of(this).textTheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
