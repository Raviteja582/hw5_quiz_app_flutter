import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._instance();
  static Database? _database;

  DatabaseService._instance();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  /// initialize the database
  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'leaderboard.db');
    return await openDatabase(
      path,
      version: 1,
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
    );
  }

  static Future<void> addUser(String player, String category) async {
    final db = await instance.database;
    var user = await db.query('leaderboard',
        where: 'player = ? AND category = ?', whereArgs: [player, category]);
    if (user.isNotEmpty) {
      return;
    }
    await db.insert(
      'leaderboard',
      {'player': player, 'category': category, 'score': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateScore(
      String player, String category, int score) async {
    final db = await instance.database;
    await db.update('leaderboard', {'score': score},
        where: 'player = ? AND category = ?', whereArgs: [player, category]);
  }

  static Future<List<Map<String, dynamic>>?> getTopScores() async {
    final db = await instance.database;
    var resutls = await db.query(
      'leaderboard',
      orderBy: 'score DESC',
      limit: 10,
    );
    return resutls;
  }
}
