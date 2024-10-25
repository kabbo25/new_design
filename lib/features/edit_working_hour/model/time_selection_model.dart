import 'package:flutter/material.dart';

class TimeSelectionModel {
  final TimeOfDay time;
  final bool isStartTime;

  TimeSelectionModel({
    required this.time,
    required this.isStartTime,
  });

  int get hourOfPeriod => time.hourOfPeriod;
  int get minute => time.minute;
  bool get isPM => time.period == DayPeriod.pm;
}
