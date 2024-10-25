import 'package:flutter/material.dart';

class WorkingHourViewModel extends ChangeNotifier {
  TimeOfDay _selectedTime;
  bool _isStartTime = true;

  WorkingHourViewModel({TimeOfDay? initialTime})
      : _selectedTime = initialTime ?? TimeOfDay.now();

  TimeOfDay get selectedTime => _selectedTime;
  bool get isStartTime => _isStartTime;

  void updateTime(int hour, int minute, bool isPM) {
    final adjustedHour = isPM ? hour + 12 : hour;
    _selectedTime = TimeOfDay(hour: adjustedHour, minute: minute);
    notifyListeners();
  }

  void toggleTimeType() {
    _isStartTime = !_isStartTime;
    notifyListeners();
  }
}
