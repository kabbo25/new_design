import 'package:flutter/material.dart';
import 'package:new_design/core/config/router/app_router.dart';
import 'package:new_design/core/theme/app_palette.dart';
class LocationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final locationService = LocationService();
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
