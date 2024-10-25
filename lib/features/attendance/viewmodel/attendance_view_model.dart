import 'package:flutter/material.dart';
import 'package:new_design/generated/assets.dart';
import 'package:new_design/theme/app_palette.dart';

import '../model/attendance_location.dart';
import '../model/last_working_day.dart';

class AttendanceViewModel extends ChangeNotifier {
  LastWorkingDay _lastWorkingDay = LastWorkingDay(
    location: 'Office',
    date: DateTime(2024, 5, 28),
    time: const TimeOfDay(hour: 8, minute: 13),
  );

  LastWorkingDay get lastWorkingDay => _lastWorkingDay;

  List<AttendanceLocation> get locationOptions => [
        AttendanceLocation(
          icon: Assets.pngOfficeFigma,
          title: 'Office',
          subtitle: 'At your office premises',
        ),
        AttendanceLocation(
          icon: Assets.pngHome,
          title: 'Home',
          subtitle: 'At your home',
        ),
        AttendanceLocation(
          icon: Assets.pngOutside,
          title: 'Outside',
          subtitle: 'Out for office work',
        ),
      ];

  void updateLastWorkingDay(TimeOfDay newTime) {
    _lastWorkingDay = LastWorkingDay(
      location: _lastWorkingDay.location,
      date: _lastWorkingDay.date,
      time: newTime,
    );
    notifyListeners();
  }

  Widget buildBackground() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x80FFFFFF), // White with 50% opacity (0.5)
                      Color(0xCCB8D3FB), // Light blue with 80% opacity (0.8)
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: AppPalette.background,
              ),
            ),
          ],
        ),
        Positioned(
          top: 100,
          child: Opacity(
            opacity: 0.8,
            child: Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                color: AppPalette.secondary,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.secondary.withOpacity(.3),
                    blurRadius: 200,
                    offset: const Offset(0, -50),
                    spreadRadius: 200,
                  ),
                  BoxShadow(
                    color: AppPalette.secondary.withOpacity(.2),
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
