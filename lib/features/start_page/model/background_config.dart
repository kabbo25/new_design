import 'package:flutter/material.dart';

class BackgroundConfig {
  final List<Color> gradientColors;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final Color bottomColor;
  final Color glowColor;
  final double glowOpacity;

  const BackgroundConfig({
    required this.gradientColors,
    required this.gradientBegin,
    required this.gradientEnd,
    required this.bottomColor,
    required this.glowColor,
    required this.glowOpacity,
  });
}
