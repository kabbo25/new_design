import 'package:flutter/material.dart';
import 'package:new_design/features/start_page/model/background_config.dart';

class BackgroundWidget extends StatelessWidget {
  final BackgroundConfig config;

  const BackgroundWidget({
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
              flex: 9,
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
              flex: 6,
              child: Container(
                color: config.bottomColor,
              ),
            ),
          ],
        ),
        Positioned(
          top: 100,
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
                    color: config.glowColor.withOpacity(.3),
                    blurRadius: 200,
                    offset: const Offset(0, -50),
                    spreadRadius: 200,
                  ),
                  BoxShadow(
                    color: config.glowColor.withOpacity(.2),
                    blurRadius: 200,
                    offset: const Offset(-100, 50),
                    spreadRadius: 150,
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
