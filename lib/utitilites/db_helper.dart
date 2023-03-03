import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlcrud/models/to_do_model.dart';

class DataBaseHelper{

  String tableName="to_do_list";
  String id="id";
  String title="title";
  String description="description";
  String status="status";
  String date="date";

  static   DataBaseHelper? _dataBaseHelper=null;

   DataBaseHelper._createInstance();

  factory DataBaseHelper(){

    if(_dataBaseHelper == null){
      _dataBaseHelper = DataBaseHelper._createInstance();
    }
    return _dataBaseHelper!;
  }

  static  Database? _database=null;

/* Future<Database> get database async{
    if(_database==null){
      _database=await _initialzepathData();
    }
    return _database;
  }*/

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database=await _initialzepathData();
    return _database!;
  }
  Future<Database> _initialzepathData() async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path= directory.path+"my_to_do_list.db";
    return await openDatabase(path,version: 1,onCreate: _create);
  }

  _create(Database database,int version)async{
    return await database.execute("CREATE TABLE $tableName ($id INTEGER PRIMARY KEY AUTOINCREMENT , $title TEXT , $description TEXT, $status TEXT , $date TEXT )");

  }

 Future<int> insert(TODOModel todoModel)async{
    Database database=await this.database;
    var results=database.insert(tableName, todoModel.toMap());
    print("database inserted");
    return results;
  }

  Future<List<Map<String,dynamic>>> getDetailinMaps() async{
    Database database=await this.database;
    return database.query(tableName);
  }

  Future<List<TODOModel>> getModelsFromMapList() async{
    List<Map<String,dynamic>> maplist= await getDetailinMaps();
    List<TODOModel> todolist= [];

    for(int i=0;i<maplist.length;i++){
      todolist.add(TODOModel.fromMap(maplist[i]));
    }
  return todolist;
  }

  Future<int> updateTask(TODOModel todoModel)async{
    Database database=await this.database;
    var updatedresult=database.update(tableName, todoModel.toMap(),where: "$id = ?", whereArgs: [todoModel.id]);
    return updatedresult;
  }

  Future<int> deleteTask(TODOModel todoModel)async{
    Database database=await this.database;
    var deletedresults=database.delete(tableName,where: "$id = ?",whereArgs: [todoModel.id]);
    return deletedresults;
  }
}