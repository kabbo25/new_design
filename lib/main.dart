import 'package:flutter/material.dart';
import 'package:new_design/theme/app_palette.dart';

import 'features/attendance/view/pages/attendance_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppPalette.background,
      ),
      home: const AttendancePage(),
    );
  }
}
