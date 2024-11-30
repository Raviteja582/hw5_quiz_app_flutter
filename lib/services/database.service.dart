import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'leaderboard.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE leaderboard(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              player TEXT,
              category TEXT,
              score INTEGER
            )''',
        );
      },
      version: 1,
    );
    return _database!;
  }

  static Future<void> addScore(
      String player, String category, int score) async {
    final db = await getDatabase();
    await db.insert(
      'leaderboard',
      {'player': player, 'category': category, 'score': score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getTopScores() async {
    final db = await getDatabase();
    return await db.query(
      'leaderboard',
      orderBy: 'score DESC',
      limit: 10,
    );
  }
}
