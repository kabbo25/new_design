import 'package:new_design/core/storage/models/storable.dart';
import 'package:uuid/uuid.dart';

class OutsideMeeting implements Storable {
  @override
  final String id;
  final String title;
  final String location;
  final String time;
  final String purpose;

  OutsideMeeting({
    String? id,
    required this.title,
    required this.location,
    required this.time,
    required this.purpose,
  }) : id = id ?? const Uuid().v4();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'time': time,
      'purpose': purpose,
    };
  }

  factory OutsideMeeting.fromJson(Map<String, dynamic> json) {
    return OutsideMeeting(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      time: json['time'],
      purpose: json['purpose'] ?? '',
    );
  }
}
