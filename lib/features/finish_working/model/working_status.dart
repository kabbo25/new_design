import 'package:flutter/material.dart';
import 'package:new_design/core/storage/models/storable.dart';
import 'package:uuid/uuid.dart';

enum WorkMode {
  starting,
  ending,
}

class WorkingStatus implements Storable {
  @override
  final String id;
  final String location;
  final TimeOfDay time;
  final WorkMode workMode;

  WorkingStatus({
    String? id,
    required this.location,
    required this.time,
    required this.workMode,
  }) : id = id ?? const Uuid().v4();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'time': '${time.hour}:${time.minute}',
      'work_mode': workMode.toString(),
    };
  }

  factory WorkingStatus.fromJson(Map<String, dynamic> json) {
    final timeStr = json['time'] as String;
    final timeParts = timeStr.split(':');

    return WorkingStatus(
      id: json['id'] as String,
      location: json['location'] as String,
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      workMode: WorkMode.values.firstWhere(
        (e) => e.toString() == json['work_mode'],
      ),
    );
  }

  WorkingStatus copyWith({
    String? id,
    String? location,
    TimeOfDay? time,
    WorkMode? workMode,
  }) {
    return WorkingStatus(
      id: id ?? this.id,
      location: location ?? this.location,
      time: time ?? this.time,
      workMode: workMode ?? this.workMode,
    );
  }
}
