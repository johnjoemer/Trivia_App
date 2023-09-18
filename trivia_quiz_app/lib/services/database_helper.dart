import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trivia_quiz_app/resources/username_model.dart';

class DatabaseHelper{
  static const int _version = 1;
  static const String _dbname = "Scores.db";

  static Future<Database> _getDB() async {
    return openDatabase(join (await getDatabasesPath(), _dbname),
      onCreate: (db, version) async => await db.execute(
        "CREATE TABLE Scores(username TEXT NOT NULL, score INTEGER);"),
        version: _version);
  }

  static Future<int> addUser(userName username) async {
    final db = await _getDB();
    return await db.insert("username", username.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(userName username) async {
    final db = await _getDB();
    return await db.update("username", username.toJson(),
          where: 'username = ?',
          whereArgs: [username],
          conflictAlgorithm: ConflictAlgorithm.replace);
  }
}