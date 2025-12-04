import 'package:location_tracker/app/data/models/location_history.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = await getDatabasesPath() + 'app_database.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            latitude REAL,
            longitude REAL,
            address TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insert(LocationHistory data) async {
    final db = await database;
    await db.insert("history", data.toMap());
  }

  static Future<List<LocationHistory>> getAllData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('history');

    return maps.map((e) => LocationHistory.fromMap(e)).toList();
  }
}