import 'package:flutter/material.dart';
import 'package:new_design/features/attendance/model/background_config.dart';
import 'package:new_design/generated/assets.dart';
import 'package:new_design/theme/app_palette.dart';

import '../model/attendance_location.dart';
import '../model/last_working_day.dart';

class AttendanceViewModel extends ChangeNotifier {
  BackgroundConfig get backgroundConfig => const BackgroundConfig(
        gradientColors: [
          Color(0x80FFFFFF),
          Color(0xCCB8D3FB),
        ],
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topCenter,
        bottomColor: AppPalette.background,
        glowColor: AppPalette.secondary,
        glowOpacity: 0.8,
      );
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
}
