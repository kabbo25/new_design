import 'package:flutter/material.dart';
import 'package:new_design/features/start_page/model/background_config.dart';

class BottomGradient extends StatelessWidget {
  final BackgroundConfig config;

  const BottomGradient({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 12,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: config.gradientColors,
                    begin: config.gradientBegin,
                    end: config.gradientEnd,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                color: config.bottomColor,
              ),
            ),
          ],
        ),
        Positioned(
          top: 300,
          left: 500,
          child: Opacity(
            opacity: config.glowOpacity,
            child: Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                color: config.glowColor,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: config.glowColor.withOpacity(0.1),
                    blurRadius: 200,
                    offset: const Offset(0, -50),
                    spreadRadius: 200,
                  ),
                  BoxShadow(
                    color: config.glowColor.withOpacity(0.2),
                    blurRadius: 200,
                    offset: const Offset(-100, 50),
                    spreadRadius: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
