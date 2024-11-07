import 'dart:convert';

import 'package:new_design/core/storage/storage_provider.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider implements StorageProvider {
  static const String _meetingsKey = 'meetings';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<void> saveMeeting(OutsideMeeting meeting) async {
    final meetings = await getMeetings();
    final existingIndex = meetings.indexWhere((m) => m.id == meeting.id);

    if (existingIndex != -1) {
      meetings[existingIndex] = meeting;
    } else {
      meetings.add(meeting);
    }

    final prefs = await _prefs;
    final meetingsJson = meetings
        .map((m) => {
              'id': m.id,
              'title': m.title,
              'location': m.location,
              'time': m.time,
              'purpose': m.purpose,
            })
        .toList();

    await prefs.setString(_meetingsKey, jsonEncode(meetingsJson));
  }

  @override
  Future<List<OutsideMeeting>> getMeetings() async {
    final prefs = await _prefs;
    final meetingsJson = prefs.getString(_meetingsKey);

    if (meetingsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(meetingsJson);
    return decoded
        .map((json) => OutsideMeeting(
              id: json['id'],
              title: json['title'],
              location: json['location'],
              time: json['time'],
              purpose: json['purpose'] ?? '',
            ))
        .toList();
  }

  @override
  Future<void> deleteMeeting(OutsideMeeting meeting) async {
    final meetings = await getMeetings();
    meetings.removeWhere((m) => m.id == meeting.id);

    final prefs = await _prefs;
    final meetingsJson = meetings
        .map((m) => {
              'id': m.id,
              'title': m.title,
              'location': m.location,
              'time': m.time,
              'purpose': m.purpose,
            })
        .toList();

    await prefs.setString(_meetingsKey, jsonEncode(meetingsJson));
  }

  @override
  Future<void> updateMeeting(OutsideMeeting meeting) async {
    final meetings = await getMeetings();
    final index = meetings.indexWhere((m) => m.id == meeting.id);

    if (index != -1) {
      meetings[index] = meeting;
      final prefs = await _prefs;
      final meetingsJson = meetings
          .map((m) => {
                'id': m.id,
                'title': m.title,
                'location': m.location,
                'time': m.time,
                'purpose': m.purpose,
              })
          .toList();

      await prefs.setString(_meetingsKey, jsonEncode(meetingsJson));
    }
  }

  @override
  Future<void> clearMeetings() async {
    final prefs = await _prefs;
    await prefs.remove(_meetingsKey);
  }
}
