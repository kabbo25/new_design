import 'package:flutter/material.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_working/model/start_working_hour.dart';
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

  StartWorkingHour _startWorkingHour = StartWorkingHour(
    location: 'Home',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 9, minute: 40),
  );

  StartWorkingHour get startWorkingHour => _startWorkingHour;

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
    _startWorkingHour = StartWorkingHour(
      location: _startWorkingHour.location,
      date: _startWorkingHour.date,
      time: newTime,
    );
    notifyListeners();
  }
}
