import 'package:new_design/core/storage/base_sqlite_database_provider.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';

class WorkingStatuscaSQLiteRepository
    extends BaseDatabaseProvider<WorkingStatus> {
  @override
  String get tableName => 'working_status';
  @override
  String get databaseName => 'meetings.db';

  @override
  int get version => 2;

  @override
  String get createTableQuery => '''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        location TEXT NOT NULL,
        time TEXT NOT NULL,
        work_mode TEXT NOT NULL
      )
    ''';

  @override
  WorkingStatus fromJson(Map<String, dynamic> json) =>
      WorkingStatus.fromJson(json);
}
