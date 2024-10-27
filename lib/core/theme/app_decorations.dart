import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppPalette.background,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade100,
        offset: const Offset(0, 2),
        blurRadius: 6,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration borderDecoration = BoxDecoration(
    color: AppPalette.background,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade200),
  );
}
