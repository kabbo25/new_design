import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/storage_factory.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/viewmodel/timer_tracking_view_model.dart';
import 'package:new_design/features/outside_office/view_model/base_working_status_view_model.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String TIMER_KEY = 'elapsed_timer_seconds';

class StartWorkingViewModel extends ChangeNotifier
    with BaseWorkingStatusViewModel {
  final TimeTrackingViewModel _timeTrackingViewModel;
  StartWorkingViewModel({
    StorageType workingStatusStorageType = StorageType.sqlite,
    TimeTrackingViewModel? timeTrackingViewModel,
  }) : _timeTrackingViewModel =
            timeTrackingViewModel ?? TimeTrackingViewModel() {
    initializeWorkingStatusProvider(
        StorageProviderFactory.create<WorkingStatus>(workingStatusStorageType));
    _initialize();
  }
  Future<void> _initialize() async {
    await initworking();
    await _initializeTimeTracking();
  }

  Future<void> _initializeTimeTracking() async {
    if (startingStatus == null) {
      saveWorkingStatus(_workingStatus);
    }
    _timeTrackingViewModel.startTracking('728');
  }

  Future<void> pauseTimer() async {
    _timeTrackingViewModel.pauseTracking();
    notifyListeners();
  }

  @override
  Future<void> saveWorkingStatus(WorkingStatus status) async {
    await super.saveWorkingStatus(status);
    timeTrackingViewModel.pauseTracking();
    await _timeTrackingViewModel.updateWorkingStatus(status);
    await Future.delayed(const Duration(seconds: 1));
    timeTrackingViewModel.startTracking('728');
    notifyListeners();
  }

  TimeTrackingViewModel get timeTrackingViewModel => _timeTrackingViewModel;
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

  WorkingStatus _workingStatus = WorkingStatus(
    location: 'office',
    workMode: WorkMode.starting,
    time: TimeOfDay.now(),
  );
  WorkingStatus get workingStatus => _workingStatus;
  void updateStartWorkingStatusTime(DateTime exactTime) {
    _workingStatus = WorkingStatus(
      location: 'office',
      workMode: WorkMode.starting,
      time: TimeOfDay(hour: exactTime.hour, minute: exactTime.minute),
    );
    saveWorkingStatus(_workingStatus);
    notifyListeners();
  }

  Future<void> saveElapsedTime(int seconds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(TIMER_KEY, seconds);
      developer.log('Successfully saved elapsed time: $seconds seconds');
    } catch (e) {
      developer.log('Error saving elapsed time: $e');
    }
  }

  Future<int> getElapsedTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(TIMER_KEY) ?? 0;
    } catch (e) {
      developer.log('Error retrieving elapsed time: $e');
      return 0;
    }
  }

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
}
