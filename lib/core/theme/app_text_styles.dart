import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppPalette.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppPalette.textPrimary,
  );
  static const TextStyle title = TextStyle(
    fontSize: 16,
    color: AppPalette.textPrimary,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    color: AppPalette.textSecondary,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    color: AppPalette.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 24 / 14,
    color: AppPalette.primary,
  );

  static const TextStyle clock = TextStyle(
    fontSize: 17.5,
    fontWeight: FontWeight.w600,
    height: 24 / 14,
    color: AppPalette.textPrimary,
  );

  // Single method to customize any text style
  static TextStyle customStyle(
    TextStyle baseStyle, {
    Color? color,
    FontWeight? weight,
    double? fontSize,
    double? height,
  }) {
    return baseStyle.copyWith(
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
      height: height,
    );
  }
}
