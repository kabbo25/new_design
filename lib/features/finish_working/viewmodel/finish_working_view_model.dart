import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/outside_office/repository/meeting_shared_prefs_repository.dart';
import 'package:new_design/features/outside_office/repository/meeting_sqlite_repository.dart';
import 'package:new_design/features/outside_office/view_model/base_location_view_model.dart';
import 'package:new_design/features/start_page/model/background_config.dart';

class FinishWorkingViewModel extends BaseLocationViewModel<OutsideMeeting> {
  FinishWorkingViewModel({
    String storageType = 'sqlite',
    WorkMode workMode = WorkMode.starting,
  }) : super(_createRepository(storageType)) {
    _workingStatus = WorkingStatus(
      location: 'Office',
      workMode: workMode,
      time: const TimeOfDay(hour: 8, minute: 13),
    );
  }
  String? _note;

  String? get note => _note;
  late WorkingStatus _workingStatus;
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
          const Color(0xFFFFFFFF).withOpacity(1), // White
          const Color(0xFFB8D3FB).withOpacity(1), // Light blue
        ],
        gradientBegin: Alignment.topCenter,
        gradientEnd: Alignment.bottomCenter,
        bottomColor: AppPalette.background,
        glowColor: AppPalette.secondary, // Yellow color
        glowOpacity: 0.8,
      );

  WorkingStatus get workingStatus => _workingStatus;

  void updateLastWorkingDay(TimeOfDay newTime) {
    _workingStatus = WorkingStatus(
      location: _workingStatus.location,
      workMode: _workingStatus.workMode,
      time: newTime,
    );
    notifyListeners();
  }

  void updateNote(String newNote) {
    _note = newNote;
    notifyListeners();
  }
}
