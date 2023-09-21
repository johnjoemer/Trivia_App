import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:trivia_quiz_app/resources/username_model.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();

  // Initialize the database
  Future<Database?> get db async {
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  // Create and initialize the database
  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'quiz_scores.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE scores (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          playerName TEXT,
          score INTEGER
        )
        ''');
    });
  }

  // Insert or update a player's score
  Future<void> insertOrUpdateScore(String playerName, int score) async {
    final dbClient = await db;
    await dbClient!.insert(
      'scores',
      {'playerName': playerName, 'score': score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get the highest score for a player 
  Future<Map<String, dynamic>?> getHighestScore() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
      SELECT playerName, MAX(score) AS highestScore
      FROM scores
    ''');

    if (result.isNotEmpty) {
      final playerName = result.first['playerName'];
      final highestScore = result.first['highestScore'] as int;
      return {'playerName': playerName, 'highestScore': highestScore};
    }
    else{
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllScores() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> scores = await dbClient!.query('scores');
    return scores;
  }
  }