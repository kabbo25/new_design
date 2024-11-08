import 'package:new_design/core/storage/shared_preference/base_shared_prefs_provider.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetingSharedPrefsRepository
    extends BaseSharedPrefsProvider<OutsideMeeting> {
  @override
  String get storageKey => 'meetings';

  @override
  OutsideMeeting fromJson(Map<String, dynamic> json) =>
      OutsideMeeting.fromJson(json);
  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove(storageKey); // or whatever key you're using to store meetings
  }
}
