import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/outside_office/view_model/base_working_status_view_model.dart';

class TimeTrackerController extends ChangeNotifier
    with BaseWorkingStatusViewModel {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  String _status = 'idle'; // 'idle', 'running', 'paused'

  Duration get elapsed => _elapsed;
  String get status => _status;
  bool get isRunning => _status == 'running';

  void start() {
    developer.log('status $_status');
    // if (_status != 'idle' && _status != 'paused') return;
    // if (startingStatus == null) return;

    _status = 'running';
    _startTimer();
    notifyListeners();
  }

  void pause() {
    if (_status != 'running') return;

    _status = 'paused';
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_status != 'paused') return;

    _status = 'running';
    _startTimer();
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _elapsed = Duration.zero;
    _status = 'idle';
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    _updateElapsed(); // Initial update
  }

  void _updateTimer(Timer timer) {
    _updateElapsed();
    notifyListeners();
  }

  Future<void> updateWorkingStatus(WorkingStatus status) async {
    await saveWorkingStatus(status);
    _updateElapsed();
    notifyListeners();
  }

  void _updateElapsed() {
    final start = startingStatus;
    if (start == null) return;

    final now = DateTime.now();
    var startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      start.time.hour,
      start.time.minute,
    );

    // If start time is in the future, assume it's from yesterday
    if (startDateTime.isAfter(now)) {
      startDateTime = startDateTime.subtract(const Duration(days: 1));
    }

    final end = finishingStatus;
    if (end != null) {
      // Calculate using end time
      var endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        end.time.hour,
        end.time.minute,
      );

      // If end time appears to be before start time, assume it's for the next day
      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      _elapsed = endDateTime.difference(startDateTime);
    } else {
      // Calculate using current time if no end time exists
      _elapsed = now.difference(startDateTime);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
