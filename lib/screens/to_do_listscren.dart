import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlcrud/models/to_do_model.dart';
import 'package:sqlcrud/screens/post_to_do_list.dart';
import 'package:sqlcrud/utitilites/db_helper.dart';

class TOdoList extends StatefulWidget {
  const TOdoList({Key? key}) : super(key: key);

  @override
  State<TOdoList> createState() => _TOdoListState();
}

class _TOdoListState extends State<TOdoList> {
  DataBaseHelper dataBaseHelper=DataBaseHelper();
   List<TODOModel>? _todolist;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(_todolist==null){
      _todolist=[];
      updateListView();//this is view the list of task or item which we have adding
    }
    return Scaffold(
      appBar: AppBar(title: Text("To do list"),),
      body:  populateListView()
    ,
      floatingActionButton: FloatingActionButton(onPressed: (){
      naviagtionToDetailsScreen(TODOModel("", "", "", ""), "Add your daily tasks");
      },child: Icon(Icons.add),backgroundColor: Colors.yellow,),
    );
  }

  updateListView()async{
    _todolist=await dataBaseHelper.getModelsFromMapList();

    setState(() {
      _todolist=_todolist;
      count=_todolist!.length;
    });
  }
  ListView populateListView(){
  return ListView.builder(
    itemCount: count,
      itemBuilder: (context,index){
      TODOModel todoModel=this._todolist![index];
    return Card(
      color: todoModel.status=="pending"?Colors.red:Colors.green,
      child:GestureDetector(
        onTap: (){
          naviagtionToDetailsScreen(todoModel, "update task");
        },
        child: ListTile(
          leading: todoModel.status=="pending"?Icon(Icons.warning):Icon(Icons.done),
          title: Text(todoModel.title),
          subtitle: Text(todoModel.description),
          trailing: todoModel.status=="completed"?GestureDetector(

              child: Icon(Icons.delete),onTap: (){
          deleteTasksfromList(todoModel);
        },
        ):null,
      ) ,
      )
    );
  });
  }

  deleteTasksfromList(TODOModel todoModel)async{
    int result=await dataBaseHelper.deleteTask(todoModel);

    if(result!=0){
      updateListView();
    }
  }
  naviagtionToDetailsScreen(TODOModel todoModel,String appBarTitle)async{//this is for navigating from one screen to other
 bool results=await Navigator.push(context, MaterialPageRoute(builder: (context){
    return PostTodolist(todoModel,appBarTitle);
  }));


 if(results){
updateListView();
 }
  }
}
