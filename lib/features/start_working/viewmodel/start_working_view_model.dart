import 'package:flutter/material.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_page/model/last_working_day.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';

class StartWorkingViewModel extends ChangeNotifier {
  BackgroundConfig get backgroundConfig => const BackgroundConfig(
        gradientColors: [
          Color(0xCCB8D3FB),
          Color(0x80FFFFFF),
        ],
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topCenter,
        bottomColor: Color(0xFFEEF4FF),
        glowColor: Color(0xFF2D68FE),
        glowOpacity: 0.8,
      );

  LastWorkingDay _lastWorkingDay = LastWorkingDay(
    location: 'Home',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 9, minute: 40),
  );

  LastWorkingDay get lastWorkingDay => _lastWorkingDay;

  List<StartWorkingLocation> get locationOptions => [
        const StartWorkingLocation(
          icon: 'assets/icons/meeting_outside.png',
          title: 'Having a meeting outside?',
        ),
        const StartWorkingLocation(
          icon: 'assets/icons/office.png',
          title: 'Working from office now?',
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
