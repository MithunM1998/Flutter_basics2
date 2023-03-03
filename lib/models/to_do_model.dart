class TODOModel{

  int? id;
  late String title;
  late String description;
  late String status;
  late String date;

  TODOModel(String title,String description,String status,String date){
    this.title=title;
    this.description=description;
    this.status=status;
    this.date=date;
  }

  TODOModel.withID(int id,String title,String description,String status,String date){
    this.id= id;
    this.title=title;
    this.description=description;
    this.status=status;
    this.date=date;
  }
//model to map
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=new Map();

    if(id!=null) {
      map["id"]=id;
    }
      map["title"]=title;
      map["description"]=description;
      map["status"]=status;
      map["date"]=date;

    return map;
  }

  //map to model
TODOModel.fromMap(Map<String,dynamic> map){
id=map["id"];
title=map["title"];
description=map["description"];
status=map["status"];
date=map["date"];
  }

}