import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/features/office_page/view/pages/attendance_error.dart';
import 'package:new_design/features/office_page/view/pages/attendence_success.dart';
import 'package:new_design/features/start_page/view/pages/attendance_page.dart';
import 'package:new_design/features/start_working/view/pages/start_working_page.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AttendancePage();
      },
    ),
    GoRoute(
      path: '/attendance/success',
      name: 'attendance_success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return AttendanceSuccessPage(wifiName: extra['wifiName']);
      },
    ),
    GoRoute(
      path: '/attendance/error',
      name: 'attendance_error',
      builder: (context, state) {
        final errorType = state.uri.queryParameters['type'];
        return AttendanceErrorPage(errorType: errorType ?? 'generic_error');
      },
    ),
    GoRoute(
      path: '/start-working',
      name: 'start_working',
      builder: (context, state) {
        //final extra = state.extra as Map<String, dynamic>?;
        return const StartWorkingPage();
      },
    ),
  ],
);
