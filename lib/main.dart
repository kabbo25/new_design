import 'package:flutter/material.dart';
import 'package:new_design/config/router/app_router.dart';
import 'package:new_design/theme/app_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppPalette.background,
      ),
      routerConfig: goRouter,
    );
  }
}
