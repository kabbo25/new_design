import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';

class FinishWorkingViewModel extends ChangeNotifier {
  WorkingStatus _workingStatus = const WorkingStatus(
    location: 'Office',
    workMode: WorkMode.starting,
    time: TimeOfDay(hour: 8, minute: 13),
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
}
