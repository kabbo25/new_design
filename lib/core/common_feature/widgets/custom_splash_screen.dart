import 'package:flutter/material.dart';
import 'package:new_design/generated/assets.dart';

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(Assets.pngHRythmic),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
