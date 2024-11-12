import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';

class TimeTrackerController extends ChangeNotifier {
  WorkingStatus? _workingStatus;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  String _status = 'idle'; // 'idle', 'running', 'paused'
  DateTime? _effectiveStartTime;

  Duration get elapsed => _elapsed;
  String get status => _status;
  bool get isRunning => _status == 'running';
  DateTime? get startTime => _effectiveStartTime;
  WorkingStatus? get workingStatus => _workingStatus;

  void updateWorkingStatus(WorkingStatus? status) {
    _workingStatus = status;
    if (status != null) {
      _updateEffectiveStartTime(status);
      if (_status == 'running') {
        _updateElapsed();
      }
    }
    notifyListeners();
  }

  void _updateEffectiveStartTime(WorkingStatus status) {
    final now = DateTime.now();
    final startTimeOfDay = status.time;
    
    _effectiveStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTimeOfDay.hour,
      startTimeOfDay.minute,
    );

    // If the start time is in the future, assume it's from yesterday
    if (_effectiveStartTime!.isAfter(now)) {
      _effectiveStartTime = _effectiveStartTime!.subtract(const Duration(days: 1));
    }
  }

  void start() {
    if (_status != 'idle' && _status != 'paused') return;
    if (_workingStatus == null) return;
    
    if (_status == 'idle') {
      _updateEffectiveStartTime(_workingStatus!);
    }
    
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
    _effectiveStartTime = null;
    _elapsed = Duration.zero;
    _status = 'idle';
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    _updateElapsed();
    notifyListeners();
  }

  void _updateElapsed() {
    if (_effectiveStartTime == null) return;
    
    _elapsed = DateTime.now().difference(_effectiveStartTime!);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}