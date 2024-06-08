import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'activities.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date DATE,
        location TEXT,
        category TEXT,
        done INTEGER DEFAULT 0,
        image TEXT
      )
    ''');
  }

  Future<void> addActivity(Map<String, dynamic> activity) async {
    final db = await database;
    await db.insert('activities', activity);
  }

  Future<void> updateActivity(int id, Map<String, dynamic> activity) async {
    final db = await database;
    await db.update('activities', activity, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteActivity(int id) async {
    final db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllActivities() async {
    final db = await database;
    return await db.query('activities');
  }
}
