import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proj_tracking/models/category.dart';

class DBHelper {
  static DBHelper _dbHelper;

  DBHelper._createInstance();
  factory DBHelper() {
    if(_dbHelper == null) {
      _dbHelper = DBHelper._createInstance();
    }
    return _dbHelper;
  }

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'category.db';

    // Open/create the database at a given path
    var db = await openDatabase(path, version: 1, onCreate: _createTable);
    return db;
  }

  String cateTable = 'cate_table';
  String col_Id = 'id';
  String col_Parent_Id = 'parent';
  String col_Name = 'name';

  void _createTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $cateTable($col_Id INTEGER PRIMARY KEY AUTOINCREMENT, $col_Name TEXT, '
        '$col_Parent_Id INTEGER)');
  }

  Future<int> insertCategory(Category category) async {
    Database db = await this.database;
    var result = await db.insert(cateTable, category.toMap());
    return result;
  }

  Future<List<Category>> getCategoryList() async {

    var todoMapList = await getCategoryMapList(); // Get 'Map List' from database
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<Category> list = List<Category>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      list.add(Category.fromMapObject(todoMapList[i]));
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(cateTable, orderBy: '$col_Name ASC');
    return result;
  }

  Future<int> updateCategory(Category category) async {
    var db = await this.database;
    var result = await db.update(cateTable, category.toMap(), where: '$col_Id = ?', whereArgs: [category.id]);
    return result;
  }

  Future<int> deleteCategory(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $cateTable WHERE $col_Id = $id');
    return result;
  }
}