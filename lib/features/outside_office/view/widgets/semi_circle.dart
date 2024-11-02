import 'package:flutter/material.dart';

class SemiCircle extends StatelessWidget {
  const SemiCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(1),
            spreadRadius: 30, // Controls how much the shadow spreads
            blurRadius: 100, // Controls how blurry the shadow is
            offset: const Offset(0, 0), // Controls shadow position (x,y)
          ),
        ],
      ),
    );
  }
}
