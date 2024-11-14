import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:new_design/core/config/router/app_router.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/outside_office/model/elapsed_time_provider.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep splash screen up while initializing
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    developer.log('pausing');
    // Simulate some initialization process
    await Future.delayed(const Duration(seconds: 3));
    developer.log('removing');
    // Remove splash screen after 3 seconds
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return TimerProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppPalette.background,
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
