// import 'dart:convert';

// import 'package:new_design/core/storage/storage_provider.dart';
// import 'package:new_design/features/finish_working/model/outside_meeting.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesProvider implements StorageProvider {
//   static const String _meetingsKey = 'meetings';

//   Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

//   @override
//   Future<void> saveMeeting(OutsideMeeting meeting) async {
//     final meetings = await getMeetings();
//     meetings.add(meeting);

//     final prefs = await _prefs;
//     final meetingsJson = meetings
//         .map((m) => {
//               'title': m.title,
//               'location': m.location,
//               'time': m.time,
//             })
//         .toList();

//     await prefs.setString(_meetingsKey, jsonEncode(meetingsJson));
//   }

//   @override
//   Future<List<OutsideMeeting>> getMeetings() async {
//     final prefs = await _prefs;
//     final meetingsJson = prefs.getString(_meetingsKey);

//     if (meetingsJson == null) return [];

//     final List<dynamic> decoded = jsonDecode(meetingsJson);
//     return decoded
//         .map((json) => OutsideMeeting(
//               title: json['title'],
//               location: json['location'],
//               time: json['time'],
//               purpose: json['purpose'],
//             ))
//         .toList();
//   }

//   @override
//   Future<void> deleteMeeting(OutsideMeeting meeting) async {
//     final meetings = await getMeetings();
//     meetings.removeWhere((m) =>
//         m.title == meeting.title &&
//         m.location == meeting.location &&
//         m.time == meeting.time);

//     final prefs = await _prefs;
//     final meetingsJson = meetings
//         .map((m) => {
//               'title': m.title,
//               'location': m.location,
//               'time': m.time,
//             })
//         .toList();

//     await prefs.setString(_meetingsKey, jsonEncode(meetingsJson));
//   }

//   @override
//   Future<void> updateMeeting(OutsideMeeting meeting) async {
//     final meetings = await getMeetings();
//     final index = meetings.indexWhere((m) =>
//         m.title == meeting.title &&
//         m.location == meeting.location &&
//         m.time == meeting.time);

//     if (index != -1) {
//       meetings[index] = meeting;
//       final prefs = await _prefs;
//       final meetingsJson = meetings
//           .map((m) => {
//                 'title': m.title,
//                 'location': m.location,
//                 'time': m.time,
//               })
//           .toList();

//       await prefs.setString(_meetingsKey, jsonEncode(meetingsJson));
//     }
//   }
// }
