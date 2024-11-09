import 'package:new_design/core/storage/base_sqlite_database_provider.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:sqflite/sqflite.dart';

class WorkingStatuscaSQLiteRepository
    extends BaseDatabaseProvider<WorkingStatus> {
  @override
  String get tableName => 'working_status';

  @override
  String get databaseName => 'working_status.db';

  @override
  int get version => 3;

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $tableName(
      id TEXT PRIMARY KEY,
      location TEXT NOT NULL,
      time TEXT NOT NULL,
      work_mode TEXT NOT NULL
    )
  ''';

  @override
  WorkingStatus fromJson(Map<String, dynamic> json) =>
      WorkingStatus.fromJson(json);

  Future<void> onCreate(Database db, int version) async {
    await db.execute(createTableQuery);
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS $tableName');
      await onCreate(db, newVersion);
    }
  }
}
