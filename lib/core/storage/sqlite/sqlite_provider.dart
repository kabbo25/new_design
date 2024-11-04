import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/storage/models/storable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class SQLiteProvider<T extends Storable> implements BaseStorageProvider<T> {
  static Database? _database;
  
  String get tableName;
  T fromJson(Map<String, dynamic> json);
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await createTable(db);
      },
    );
  }

  Future<void> createTable(Database db);

  @override
  Future<void> save(T item) async {
    final db = await database;
    await db.insert(
      tableName,
      item.toJson(),
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
  Future<void> update(T item) async {
    final db = await database;
    await db.update(
      tableName,
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<T?> getById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return fromJson(maps.first);
  }
}