import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/start_page/model/background_config.dart';

class FinishWorkingViewModel extends ChangeNotifier {
  String? _note;

  String? get note => _note;

  late WorkingStatus _workingStatus;
  final List<String> _locations = [
    'Office',
    'Home',
    'Cafe'
  ]; // Add your default locations here
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

  void updateNote(String newNote) {
    _note = newNote;
    notifyListeners();
  }
}
