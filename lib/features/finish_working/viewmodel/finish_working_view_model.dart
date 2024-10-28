import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';

class FinishWorkingViewModel extends ChangeNotifier {
  late WorkingStatus _workingStatus;
  final List<String> _locations = [
    'Office',
    'Home',
    'Cafe'
  ]; // Add your default locations here

  FinishWorkingViewModel({WorkMode workMode = WorkMode.starting}) {
    _workingStatus = WorkingStatus(
      location: 'Office',
      workMode: workMode,
      time: const TimeOfDay(hour: 8, minute: 13),
    );
  }

  WorkingStatus get workingStatus => _workingStatus;
  List<String> get locations => _locations;

  void updateLastWorkingDay(TimeOfDay newTime) {
    _workingStatus = WorkingStatus(
      location: _workingStatus.location,
      workMode: _workingStatus.workMode,
      time: newTime,
    );
    notifyListeners();
  }

  void updateLocation(String newLocation) {
    _workingStatus = WorkingStatus(
      location: newLocation,
      workMode: _workingStatus.workMode,
      time: _workingStatus.time,
    );
    notifyListeners();
  }
}
