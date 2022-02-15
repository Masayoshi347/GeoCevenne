import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final _dbName = 'poi_database.db';
  static final _dbVersion = 3;
  static final _tableName = 'poi';

  static final cnameId = 'id';
  static final cnameVillage = 'village';
  static final cnameLieu = 'lieu';
  static final cnameType = 'type';
  static final cnameEtat = 'etat';
  static final cnameNotes = 'notes';
  static final cnameLatitude = 'latitude';
  static final cnameLongitude = 'longitude';
  static final cnameImageUrl = 'image_url';
  static final cnameStatus = 'status';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $_tableName(
      $cnameId INTEGER PRIMARY KEY,
      $cnameVillage TEXT NOT NULL,
      $cnameLieu TEXT NOT NULL,
      $cnameType TEXT NOT NULL,
      $cnameEtat TEXT NOT NULL,
      $cnameNotes TEXT NOT NULL,
      $cnameLatitude TEXT NOT NULL,
      $cnameLongitude TEXT NOT NULL,
      $cnameImageUrl TEXT
      $cnameStatus INTEGER)
      '''
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[cnameId];
    return await db.update(_tableName, row, where:'$cnameId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$cnameId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(_tableName);
  }

  void updateStatusOnline(int id) async {
    Database db = await instance.database;
    await db.execute("UPDATE $_tableName SET $cnameStatus = 1 WHERE $cnameId = $id");
  }

}