import 'package:flutter/material.dart';

class StartWorkingHour {
  final String location;
  final DateTime date;
  final TimeOfDay time;

  StartWorkingHour({
    required this.location,
    required this.date,
    required this.time,
  });
}
