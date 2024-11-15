import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/outside_office/view_model/base_working_status_view_model.dart';

class TimeTrackerController extends ChangeNotifier
    with BaseWorkingStatusViewModel {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  String _status = 'idle';
  DateTime? _lastUpdateTime;
  int _timerInstanceCount = 0;
  Duration? _pausedDuration; // Store complete duration instead of just seconds

  Duration get elapsed => _elapsed;
  String get status => _status;
  bool get isRunning => _status == 'running';

  int get elapsedSeconds => _elapsed.inSeconds;

  String get formattedHours => (_elapsed.inHours).toString().padLeft(2, '0');
  String get formattedMinutes =>
      (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
  String get formattedSeconds =>
      (elapsedSeconds % 60).toString().padLeft(2, '0');

  String get formattedTime =>
      '$formattedHours:$formattedMinutes:$formattedSeconds';

  void start() {
    if (_status != 'idle' && _status != 'paused') {
      developer.log('Timer start rejected - Invalid status: $_status');
      return;
    }
    if (startingStatus == null) {
      developer.log('Timer start rejected - No starting status');
      return;
    }

    developer.log('=== Timer Start ===');
    developer.log('Previous status: $_status');
    developer.log('Starting status: ${startingStatus?.toJson()}');
    developer.log('Finishing status: ${finishingStatus?.toJson()}');
    developer.log('Current time: ${DateTime.now()}');

    _status = 'running';
    _lastUpdateTime = DateTime.now();
    _pausedDuration = null; // Reset paused duration when starting
    _updateElapsed();
    _startTimer();

    developer
        .log('Timer initialized with elapsed: $_elapsed (${formattedTime})');
    notifyListeners();
  }

  void _startTimer() {
    _stopTimer();

    _timerInstanceCount++;
    final currentInstance = _timerInstanceCount;

    developer.log('Starting new timer instance #$currentInstance');

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status != 'running' || currentInstance != _timerInstanceCount) {
        _stopTimer();
        return;
      }

      _updateElapsed(shouldLog: false);
      notifyListeners();
    });
  }

  void _stopTimer() {
    if (_timer?.isActive ?? false) {
      developer.log('Stopping active timer');
      _timer?.cancel();
      _timer = null;
    }
  }

  DateTime _getStartDateTime() {
    final start = startingStatus;
    if (start == null) return DateTime.now();

    final now = DateTime.now();
    var startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      start.time.hour,
      start.time.minute,
    );

    if (startDateTime.isAfter(now)) {
      startDateTime = startDateTime.subtract(const Duration(days: 1));
    }

    return startDateTime;
  }

  void pause() {
    if (_status != 'running') {
      developer.log('Pause rejected - Timer is not running');
      return;
    }

    developer.log('=== Timer Pause ===');
    developer.log('Current elapsed time: $_elapsed');
    developer.log('Formatted time: $formattedTime');
    developer.log('Status before pause: $_status');
    developer.log(
        'Hours: $formattedHours, Minutes: $formattedMinutes, Seconds: $formattedSeconds');

    _pausedDuration = _elapsed; // Store complete duration when pausing
    _stopTimer();
    _status = 'paused';
    _updateElapsed();
    notifyListeners();
  }

  void _updateElapsed({bool shouldLog = true}) {
    final start = startingStatus;
    if (start == null) {
      developer.log('ERROR: No starting status available');
      return;
    }

    final now = DateTime.now();
    var startDateTime = _getStartDateTime();

    final end = finishingStatus;
    if (end != null && _status != 'running') {
      var endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        end.time.hour,
        end.time.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      _elapsed = endDateTime.difference(startDateTime);

// Add 3 seconds but limit within 0 to 59 for seconds
      final additionalSeconds = (_elapsed.inSeconds + elapsedSeconds) % 60;
      _elapsed = Duration(
        hours: _elapsed.inHours,
        minutes: _elapsed.inMinutes % 60,
        seconds: additionalSeconds,
      );
      developer.log('elapsed seconds in time of ending is $additionalSeconds');
      if (shouldLog) {
        developer.log('Using end time: ${_formatDateTime(endDateTime)}');
      }
    } else {
      _elapsed = now.difference(startDateTime);
      final additionalSeconds = (_elapsed.inSeconds + elapsedSeconds) % 60;
      _elapsed = Duration(
        hours: _elapsed.inHours,
        minutes: _elapsed.inMinutes % 60,
        seconds: additionalSeconds,
      );
      if (shouldLog) {
        developer.log('Using current time for calculation');
      }
    }

    if (shouldLog) {
      developer.log('Updated elapsed time: $elapsedSeconds');
      developer.log(
          'Hours: $formattedHours, Minutes: $formattedMinutes, Seconds: $formattedSeconds');
    }
    _lastUpdateTime = now;
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  Future<void> updateWorkingStatus(WorkingStatus status) async {
    developer.log('=== Updating Working Status ===');
    developer.log('New status: ${status.toJson()}');
    developer.log('Current status: $_status');
    developer.log('Current elapsed time: $formattedTime');
    developer.log(
        'Hours: $formattedHours, Minutes: $formattedMinutes, Seconds: $formattedSeconds');

    await saveWorkingStatus(status);

    if (status.workMode == WorkMode.ending && _status == 'running') {
      _status = 'idle';
      _stopTimer();
    }

    _updateElapsed();
    notifyListeners();
  }

  @override
  void dispose() {
    developer.log('Disposing TimeTrackerController');
    _stopTimer();
    super.dispose();
  }
}
