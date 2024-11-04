import 'package:new_design/core/storage/storage_provider.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteProvider implements StorageProvider {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meetings.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE meetings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            location TEXT NOT NULL,
            time TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<void> saveMeeting(OutsideMeeting meeting) async {
    final db = await database;
    await db.insert(
      'meetings',
      {
        'title': meeting.title,
        'location': meeting.location,
        'time': meeting.time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<OutsideMeeting>> getMeetings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meetings');
    
    return List.generate(maps.length, (i) {
      return OutsideMeeting(
        title: maps[i]['title'],
        location: maps[i]['location'],
        time: maps[i]['time'],
      );
    });
  }

  @override
  Future<void> deleteMeeting(OutsideMeeting meeting) async {
    final db = await database;
    await db.delete(
      'meetings',
      where: 'title = ? AND location = ? AND time = ?',
      whereArgs: [meeting.title, meeting.location, meeting.time],
    );
  }

  @override
  Future<void> updateMeeting(OutsideMeeting meeting) async {
    final db = await database;
    await db.update(
      'meetings',
      {
        'title': meeting.title,
        'location': meeting.location,
        'time': meeting.time,
      },
      where: 'title = ? AND location = ? AND time = ?',
      whereArgs: [meeting.title, meeting.location, meeting.time],
    );
  }
}