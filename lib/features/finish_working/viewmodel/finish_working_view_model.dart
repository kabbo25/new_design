import 'package:flutter/material.dart';
import 'package:new_design/core/storage/storage_factory.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/note.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/viewmodel/note_view_model.dart';
import 'package:new_design/features/finish_working/viewmodel/timer_tracking_view_model.dart';
import 'package:new_design/features/outside_office/view_model/base_location_view_model.dart';
import 'package:new_design/features/outside_office/view_model/base_working_status_view_model.dart';
import 'package:new_design/features/start_page/model/background_config.dart';

class FinishWorkingViewModel extends ChangeNotifier
    with BaseLocationViewModel, BaseWorkingStatusViewModel, NoteViewModelMixin {
  final TimeTrackingViewModel timeTrackingViewModel;

  FinishWorkingViewModel({
    StorageType locationStorageType = StorageType.sqlite,
    StorageType workingStatusStorageType = StorageType.sqlite,
    required this.timeTrackingViewModel,
  }) {
    initializeLocationProvider(
        StorageProviderFactory.create<OutsideMeeting>(locationStorageType));
    initializeWorkingStatusProvider(
        StorageProviderFactory.create<WorkingStatus>(workingStatusStorageType));
    initializeNoteProvider(
        StorageProviderFactory.create<Note>(workingStatusStorageType));

    _initialize();
  }

  Future<void> _initialize() async {
    await initlocation();
    await initworking();
    await initNotes();
  }

  @override
  Future<void> saveWorkingStatus(WorkingStatus status) async {
    await super.saveWorkingStatus(status);
    await timeTrackingViewModel.updateWorkingStatus(status);
    notifyListeners();
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
  WorkingStatus get startingWorkingStatus => _startingWorkingStatus;
  WorkingStatus get finishWorkingStatus => _finishWorkingStatus;

  final WorkingStatus _startingWorkingStatus = WorkingStatus(
    location: 'outside',
    workMode: WorkMode.starting,
    time: TimeOfDay.now(),
  );

  WorkingStatus _finishWorkingStatus = WorkingStatus(
    location: 'outside',
    workMode: WorkMode.ending,
    time: TimeOfDay.now(),
  );

  void updateFinishWorkingStatusTime(DateTime exactTime) {
    _finishWorkingStatus = WorkingStatus(
      location: 'outside',
      workMode: WorkMode.ending,
      time: TimeOfDay(hour: exactTime.hour, minute: exactTime.minute),
    );
    saveWorkingStatus(_finishWorkingStatus);
    timeTrackingViewModel.pauseTracking();
    notifyListeners();
  }
}
