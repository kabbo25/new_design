import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_working/model/start_working_hour.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';

class OutsideMeetingViewModel extends ChangeNotifier {
  final _locations = [
    const OutsideMeeting(
      title: 'Requirement gathering IPEMIS',
      location: '36 B, MJ road, Shershah Colony fjdsfkasfdsak;fjs;jf;sjf;j',
      time: '11:00 am',
    ),
    const OutsideMeeting(
      title: 'Requirement gathering IPEMIS',
      location: '36 B, MJ road, Shershah Colony',
      time: '12:00 am',
    ),
    const OutsideMeeting(
      title: 'Requirement gathering IPEMIS',
      location: '36 B, MJ road, Shershah Colony',
      time: '1:00 am',
    ),
    const OutsideMeeting(
      title: 'Requirement gathering IPEMIS',
      location: '36 B, MJ road, Shershah Colony',
      time: '2:00 am',
    ),
  ];
  BackgroundConfig get backgroundConfig => BackgroundConfig(
        gradientColors: [
          const Color(0xFFFFFFFF).withOpacity(1), // White
          Color.fromARGB(255, 150, 188, 245).withOpacity(0.8), // Light blue
        ],
        gradientBegin: Alignment.topCenter,
        gradientEnd: Alignment.bottomCenter,
        bottomColor: AppPalette.background,
        glowColor: AppPalette.secondary, // Yellow color
        glowOpacity: 0.8,
      );

  StartWorkingHour _startWorkingHour = StartWorkingHour(
    location: 'Home',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 9, minute: 40),
  );

  StartWorkingHour get startWorkingHour => _startWorkingHour;
  List<OutsideMeeting> get locations => _locations;
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
  void updateLocations(String newLocations) {
    _locations.clear();
    //_locations.addAll(newLocations);
    notifyListeners();
  }

  void updateLastWorkingDay(TimeOfDay newTime) {
    _startWorkingHour = StartWorkingHour(
      location: _startWorkingHour.location,
      date: _startWorkingHour.date,
      time: newTime,
    );
    notifyListeners();
  }
}
