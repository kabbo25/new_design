import 'package:flutter/material.dart';

class AppPalette {
  // Colors
  static const Color primary = Color(0xFF003E9C);
  static const Color secondary = Color(0xFFFFBA09);
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF757575);
  static const Color success = Color(0xFF4CAF50);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFB8D3FB),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topCenter,
  );
}
