import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/outside_office/repository/meeting_shared_prefs_repository.dart';
import 'package:new_design/features/outside_office/repository/meeting_sqlite_repository.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_working/model/start_working_hour.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';

class OutsideMeetingViewModel extends ChangeNotifier {
  late final BaseStorageProvider<OutsideMeeting> _repository;
  final List<OutsideMeeting> _locations = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isInitialized = false;

  OutsideMeetingViewModel({String storageType = 'shared_preferences'}) {
    _repository = _createRepository(storageType);
    init();
  }

  Future<void> init() async {
    if (!_isInitialized) {
      await loadMeetings();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _locations.clear();
    if (_repository is MeetingSQLiteRepository) {
      (_repository).close();
    }
    super.dispose();
  }

  BaseStorageProvider<OutsideMeeting> _createRepository(String type) {
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
  List<OutsideMeeting> get locations => List.unmodifiable(_locations);
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

  Future<void> loadMeetings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final meetings = await _repository.getAll();
      _locations.clear();
      _locations.addAll(meetings);
    } catch (e) {
      developer.log('Error loading meetings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLocation(OutsideMeeting meeting) async {
    try {
      await _repository.save(meeting);
      _locations.add(meeting);
      notifyListeners();
    } catch (e) {
      developer.log('Error adding location: $e');
    }
  }

  Future<void> updateLocation(OutsideMeeting meeting) async {
    try {
      await _repository.update(meeting);
      final index = _locations.indexWhere((m) => m.id == meeting.id);

      if (index != -1) {
        _locations[index] = meeting;
        // Force a rebuild of the UI
        notifyListeners();
      } else {
        developer.log('Meeting not found in locations list');
        // If the meeting wasn't found, reload all meetings
        await loadMeetings();
      }
    } catch (e) {
      developer.log('Error updating location: $e');
      // On error, reload meetings to ensure UI is in sync with storage
      await loadMeetings();
    }
  }

  Future<void> deleteLocation(OutsideMeeting meeting) async {
    try {
      await _repository.delete(meeting);
      _locations.removeWhere((m) => m.id == meeting.id);
      notifyListeners();
    } catch (e) {
      developer.log('Error deleting location: $e');
    }
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
