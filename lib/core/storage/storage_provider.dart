import 'package:new_design/features/finish_working/model/outside_meeting.dart';

abstract class StorageProvider {
  Future<void> saveMeeting(OutsideMeeting meeting);
  Future<List<OutsideMeeting>> getMeetings();
  Future<void> deleteMeeting(OutsideMeeting meeting);
  Future<void> updateMeeting(OutsideMeeting meeting);
  Future<void> clearMeetings();
}
