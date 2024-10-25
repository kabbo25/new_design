import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_text_styles.dart';

class AppButtonStyles {
  static final ButtonStyle elevatedButton = ElevatedButton.styleFrom(
    backgroundColor: AppPalette.primary,
    foregroundColor: AppPalette.background,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(60),
    ),
    textStyle: AppTextStyles.buttonText.copyWith(
      color: AppPalette.background,
    ),
    disabledBackgroundColor: AppPalette.primary.withOpacity(0.5),
    disabledForegroundColor: AppPalette.background.withOpacity(0.5),
  );

  static final ButtonStyle textButton = TextButton.styleFrom(
    foregroundColor: AppPalette.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: AppTextStyles.buttonText,
    disabledForegroundColor: AppPalette.primary.withOpacity(0.5),
  );

  // Helper methods to customize colors while keeping other styles
  static ButtonStyle elevatedButtonWithColors({
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return elevatedButton.copyWith(
      backgroundColor: backgroundColor != null
          ? WidgetStateProperty.all(backgroundColor)
          : null,
      foregroundColor: foregroundColor != null
          ? WidgetStateProperty.all(foregroundColor)
          : null,
    );
  }

  static ButtonStyle textButtonWithColors({
    Color? foregroundColor,
  }) {
    return textButton.copyWith(
      foregroundColor: foregroundColor != null
          ? WidgetStateProperty.all(foregroundColor)
          : null,
    );
  }
}
