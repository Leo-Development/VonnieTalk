import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
//import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    //This is the path where we can store out data
    return await sql.openDatabase(
      path.join(dbPath, 'app_data.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE user_images(id TEXT PRIMARY KEY,title TEXT, image TEXT,audioPath TEXT,categoryId TEXT)');
        db.execute(
            'CREATE TABLE category(categoryId TEXT PRIMARY KEY,title TEXT, image TEXT)');
        db.execute(
            'CREATE TABLE language_translate(id PRIMARY KEY,audio_path TEXT)');
      },
      version: 1,
    );
    //In the code above we want to open a database but if the database does not execet we create using the onCreaete
  }

  static Future<void> insertData(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    try {
      await db.insert(table, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (error) {
      print('insertion failed');
      throw error;
    }
  }

  // static Future<void> insertLanguage(String table, Map<String,String> data) async {
  //   final db = await DBHelper.database();
  //   try {
  //     await db.insert('language_translate', data,
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   } catch (error) {
  //     print('insertion failed');
  //     throw error;
  //   }
  // }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    try {
      await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      print('Failed to delete itme');
    }
  }
}
