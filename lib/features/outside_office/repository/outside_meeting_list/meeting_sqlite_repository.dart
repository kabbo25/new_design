import 'package:new_design/core/storage/base_sqlite_database_provider.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';

class MeetingStorageProvider extends BaseDatabaseProvider<OutsideMeeting> {
  @override
  String get tableName => 'meetings';

  @override
  String get databaseName => 'meetings.db';

  @override
  int get version => 2;

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName(
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      location TEXT NOT NULL,
      time TEXT NOT NULL,
      purpose TEXT NOT NULL
    )
  ''';

  @override
  OutsideMeeting fromJson(Map<String, dynamic> json) =>
      OutsideMeeting.fromJson(json);
}
