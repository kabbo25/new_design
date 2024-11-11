import 'package:new_design/core/storage/base_sqlite_database_provider.dart';
import 'package:new_design/features/finish_working/model/note.dart';


class NoteStorageProvider extends BaseDatabaseProvider<Note> {
  @override
  String get tableName => 'notes';

  @override
  String get databaseName => 'notes.db';

  @override
  int get version => 1;

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $tableName(
      id TEXT PRIMARY KEY,
      content TEXT NOT NULL,
      createdAt TEXT NOT NULL
    )
''';

  @override
  Note fromJson(Map<String, dynamic> json) => Note.fromJson(json);
}