import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/outside_office/repository/meeting_shared_prefs_repository.dart';
import 'package:new_design/features/outside_office/repository/meeting_sqlite_repository.dart';
import 'package:new_design/features/outside_office/view_model/base_location_view_model.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_working/model/start_working_hour.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';

class OutsideMeetingViewModel extends BaseLocationViewModel<OutsideMeeting> {
  OutsideMeetingViewModel({String storageType = 'shared_preferences'})
      : super(_createRepository(storageType));

  static BaseStorageProvider<OutsideMeeting> _createRepository(String type) {
    switch (type.toLowerCase()) {
      case 'sqlite':
        return MeetingSQLiteRepository();
      case 'shared_preferences':
        return MeetingSharedPrefsRepository();
      default:
        throw Exception('Unknown storage type: $type');
    }
  }

  BackgroundConfig get backgroundConfig => BackgroundConfig(
        gradientColors: [
          const Color(0xFFFFFFFF).withOpacity(1),
          const Color.fromARGB(255, 150, 188, 245).withOpacity(0.8),
        ],
        gradientBegin: Alignment.topCenter,
        gradientEnd: Alignment.bottomCenter,
        bottomColor: AppPalette.background,
        glowColor: AppPalette.secondary,
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
