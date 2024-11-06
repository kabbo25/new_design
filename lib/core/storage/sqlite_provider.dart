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
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE meetings(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            location TEXT NOT NULL,
            time TEXT NOT NULL,
            purpose TEXT NOT NULL,
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE meetings ADD COLUMN purpose TEXT');
        }
      },
    );
  }

  @override
  Future<void> saveMeeting(OutsideMeeting meeting) async {
    final db = await database;
    await db.insert(
      'meetings',
      {
        'id': meeting.id,
        'title': meeting.title,
        'location': meeting.location,
        'time': meeting.time,
        'purpose': meeting.purpose,
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
        id: maps[i]['id'],
        title: maps[i]['title'],
        location: maps[i]['location'],
        time: maps[i]['time'],
        purpose: maps[i]['purpose'] ?? '',
      );
    });
  }

  @override
  Future<void> deleteMeeting(OutsideMeeting meeting) async {
    final db = await database;
    await db.delete(
      'meetings',
      where: 'id = ?',
      whereArgs: [meeting.id],
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
        'purpose': meeting.purpose,
      },
      where: 'id = ?',
      whereArgs: [meeting.id],
    );
  }

  @override
  Future<void> clearMeetings() async {
    final db = await database;
    await db.delete('meetings');
  }
}
