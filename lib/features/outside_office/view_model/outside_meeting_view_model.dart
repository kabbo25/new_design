import 'package:flutter/material.dart';
import 'package:new_design/core/storage/storage_factory.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/viewmodel/timer_tracking_view_model.dart';
import 'package:new_design/features/outside_office/view_model/base_location_view_model.dart';
import 'package:new_design/features/outside_office/view_model/base_working_status_view_model.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';

class OutsideMeetingViewModel extends ChangeNotifier
    with BaseLocationViewModel, BaseWorkingStatusViewModel {
  final TimeTrackingViewModel _timeTrackingViewModel;

  OutsideMeetingViewModel({
    StorageType locationStorageType = StorageType.sqlite,
    StorageType workingStatusStorageType = StorageType.sqlite,
    TimeTrackingViewModel? timeTrackingViewModel,
  }) : _timeTrackingViewModel =
            timeTrackingViewModel ?? TimeTrackingViewModel() {
    initializeLocationProvider(
        StorageProviderFactory.create<OutsideMeeting>(locationStorageType));
    initializeWorkingStatusProvider(
        StorageProviderFactory.create<WorkingStatus>(workingStatusStorageType));
    _initialize();
  }

  Future<void> _initialize() async {
    await initlocation();
    await initworking();
    await _initializeTimeTracking();
  }

  Future<void> _initializeTimeTracking() async {
    _timeTrackingViewModel.startTracking('728');
  }

  Future<void> pauseTimer() async {
    _timeTrackingViewModel.pauseTracking();
    notifyListeners();
  }

  @override
  Future<void> saveWorkingStatus(WorkingStatus status) async {
    await super.saveWorkingStatus(status);
    await _timeTrackingViewModel.updateWorkingStatus(status);
    notifyListeners();
  }

  TimeTrackingViewModel get timeTrackingViewModel => _timeTrackingViewModel;

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

  WorkingStatus _workingStatus = WorkingStatus(
    location: 'outside',
    workMode: WorkMode.starting,
    time: TimeOfDay.now(),
  );
  WorkingStatus get workingStatus => _workingStatus;
  void updateStartWorkingStatusTime(DateTime exactTime) {
    _workingStatus = WorkingStatus(
      location: 'outside',
      workMode: WorkMode.starting,
      time: TimeOfDay(hour: exactTime.hour, minute: exactTime.minute),
    );
    saveWorkingStatus(_workingStatus);
    notifyListeners();
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
