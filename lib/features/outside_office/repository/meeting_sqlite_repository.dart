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
      CREATE TABLE $tableName(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        location TEXT NOT NULL,
        time TEXT NOT NULL,
        purpose TEXT NOT NULL
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

  @override
  Future<void> clear() async {
    final db = await database;
    await db.delete('meetings');
  }
}
