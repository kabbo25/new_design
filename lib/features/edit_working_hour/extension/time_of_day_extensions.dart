import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  TimeOfDay copyWith({int? hour, int? minute}) {
    return TimeOfDay(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  bool get isAM => period == DayPeriod.am;
  bool get isPM => period == DayPeriod.pm;

  int get hourIn24Format => hour;
  int get hourIn12Format => hourOfPeriod;
}
