// working_status.dart
import 'package:flutter/material.dart';

enum WorkMode {
  starting,
  ending,
}

class WorkingStatus {
  final String location;
  final TimeOfDay time;
  final WorkMode workMode;

  const WorkingStatus({
    required this.location,
    required this.time,
    required this.workMode,
  });

  // Add copyWith method for easy modifications
  WorkingStatus copyWith({
    String? location,
    TimeOfDay? time,
    WorkMode? workMode,
  }) {
    return WorkingStatus(
      location: location ?? this.location,
      time: time ?? this.time,
      workMode: workMode ?? this.workMode,
    );
  }

  // Add fromJson and toJson if needed for serialization
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'time': '${time.hour}:${time.minute}',
      'workMode': workMode.toString(),
    };
  }

  factory WorkingStatus.fromJson(Map<String, dynamic> json) {
    final timeStr = json['time'] as String;
    final timeParts = timeStr.split(':');

    return WorkingStatus(
      location: json['location'] as String,
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      workMode: WorkMode.values.firstWhere(
        (e) => e.toString() == json['workMode'],
      ),
    );
  }
}
