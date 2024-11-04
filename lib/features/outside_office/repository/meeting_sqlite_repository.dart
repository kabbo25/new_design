import 'package:new_design/core/storage/sqlite/sqlite_provider.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:sqflite/sqflite.dart';

class MeetingSQLiteRepository extends SQLiteProvider<OutsideMeeting> {
  @override
  String get tableName => 'meetings';
  Database? _db;
  @override
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        location TEXT NOT NULL,
        time TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  @override
  OutsideMeeting fromJson(Map<String, dynamic> json) =>
      OutsideMeeting.fromJson(json);
}
