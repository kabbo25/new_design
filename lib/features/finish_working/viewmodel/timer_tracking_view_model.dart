import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/storage_factory.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/elapsed_time/elapsed_time_controller.dart';

class TimeTrackingViewModel extends ChangeNotifier {
  final TimeTrackerController timerController;

  TimeTrackingViewModel(
      {StorageType workingStatusStorageType = StorageType.sqlite})
      : timerController = TimeTrackerController() {
    _setupTimerController();
    _initializeController(workingStatusStorageType);
  }

  void _initializeController(StorageType storageType) {
    timerController.initializeWorkingStatusProvider(
        StorageProviderFactory.create<WorkingStatus>(storageType));
  }

  void _setupTimerController() {
    timerController.addListener(_handleTimerUpdate);
  }

  Future<void> updateWorkingStatus(WorkingStatus status) async {
    await timerController.updateWorkingStatus(status);
    notifyListeners();
  }

  Future<void> _handleTimerUpdate() async {
    if (!timerController.isRunning) return;
    notifyListeners();
  }

  Future<void> startTracking(String userId) async {
    developer.log(userId);
    await timerController.initworking();
    
    timerController.start();
  }

  Future<void> pauseTracking() async {
    timerController.pause();
  }

  // Future<void> resumeTracking() async {
  //   timerController.resume();
  // }

  // Future<void> stopTracking() async {
  //   timerController.reset();
  // }

  Duration get elapsed => timerController.elapsed;
  bool get isRunning => timerController.isRunning;

  @override
  void dispose() {
    timerController.removeListener(_handleTimerUpdate);
    timerController.dispose();
    super.dispose();
  }
}
