import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlcrud/models/to_do_model.dart';
import 'package:sqlcrud/utitilites/db_helper.dart';

class PostTodolist extends StatefulWidget {
 late TODOModel todoModel;
 late String appBartitle;

 PostTodolist(TODOModel todoModel,String appBartitle){
   this.todoModel=todoModel;
   this.appBartitle=appBartitle;
 }
  @override
  State<PostTodolist> createState() => _PostTodolistState( this.todoModel=todoModel,
      this.appBartitle=appBartitle);
}

class _PostTodolistState extends State<PostTodolist> {

  late TODOModel todoModel;
  late String appBartitle;

  var _stauslist=["pending","completed"];
  var selectedstaus="pending";

  TextEditingController _titleeditingController=new TextEditingController();
  TextEditingController _descriptioneditingController=new TextEditingController();

  _PostTodolistState(TODOModel todoModel,String appBartitle){
    this.todoModel=todoModel;
    this.appBartitle=appBartitle;
  }

@override
  void initState() {//why we are using this method means ,what ever the data we have setted before that data/status will be seen and it is fixed cannot be changed in order to the data/status we are using this method before build method
    // TODO: implement initState
  selectedstaus=todoModel.status.length==0 ? "pending" : todoModel.status;//length we are taking zero because in to_do_list we are passing empty in TODOModel constructor
  _descriptioneditingController.text=todoModel.description;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _titleeditingController.text=todoModel.title;//this and below lines is for getting the data what we have set in adding the task


    return Scaffold(
      appBar: AppBar(title: Text(appBartitle),backgroundColor: Colors.orange,),
      body: Container(
        child: Column(
          children: [
            Center(
              child: DropdownButton(value:selectedstaus,
                  items: _stauslist.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                  onChanged: (e){
                setState(() {
                  selectedstaus=e!;
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _titleeditingController,
                decoration: InputDecoration(
                  hintText: "Enter your task",
                  labelText: "Task",
                  border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _descriptioneditingController,
                decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "description",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: (){
                    validate();
                },style: ElevatedButton.styleFrom(primary: Colors.deepOrange), child: Text(appBartitle),),
              ),
            )
          ],
        ),
      ),
    );
  }
  validate(){
    todoModel.title=_titleeditingController.text;
    todoModel.description=_descriptioneditingController.text;
    todoModel.status=selectedstaus;
    todoModel.date=DateFormat.yMMMd().format(DateTime.now());


    DataBaseHelper dataBaseHelper=DataBaseHelper();
    if(todoModel.id==null)
    dataBaseHelper.insert(todoModel);
    else
      dataBaseHelper.updateTask(todoModel);
    Navigator.pop(context,true);
  }
}
