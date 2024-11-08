import 'dart:developer' as developer;

import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/storage/models/storable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDatabaseProvider<T extends Storable>
    implements BaseStorageProvider<T> {
  Database? _database;

  // Abstract properties that must be implemented by child classes
  String get tableName;
  String get databaseName;
  int get version;
  String get createTableQuery;

  // Function to convert JSON to entity
  T fromJson(Map<String, dynamic> json);

  // Optional upgrade function
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    developer.log('Database path: $path');

    return await openDatabase(
      path,
      version: version,
      onCreate: (Database db, int version) async {
        await db.execute(createTableQuery);
      },
      onUpgrade: onUpgrade,
    );
  }

  @override
  Future<void> save(T entity) async {
    final db = await database;
    await db.insert(
      tableName,
      entity.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<T>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => fromJson(map)).toList();
  }

  @override
  Future<void> delete(T item) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> update(T entity) async {
    final db = await database;
    await db.update(
      tableName,
      entity.toJson(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  @override
  Future<void> clear() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
