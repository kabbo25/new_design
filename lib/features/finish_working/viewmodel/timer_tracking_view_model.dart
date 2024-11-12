import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/elapsed_time/elapsed_time_controller.dart';

class TimeTrackingViewModel extends ChangeNotifier {
  final TimeTrackerController timerController;
  WorkingStatus? _startingStatus;

  TimeTrackingViewModel() : timerController = TimeTrackerController() {
    _setupTimerController();
  }

  void _setupTimerController() {
    timerController.addListener(_handleTimerUpdate);
  }

  void updateStartingStatus(WorkingStatus status) {
    _startingStatus = status;
    timerController.updateWorkingStatus(status);
    notifyListeners();
  }

  Future<void> _handleTimerUpdate() async {
    if (!timerController.isRunning) return;
  }

  Future<void> startTracking(String userId) async {
    if (_startingStatus == null) {
      throw Exception('Starting status must be set before starting tracking');
    }

    timerController.start();
  }

  Future<void> pauseTracking() async {
    timerController.pause();
  }

  Future<void> resumeTracking() async {
    timerController.resume();
  }

  Future<void> stopTracking() async {
    timerController.reset();
  }

  @override
  void dispose() {
    timerController.removeListener(_handleTimerUpdate);
    timerController.dispose();
    super.dispose();
  }
}
