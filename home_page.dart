import 'package:flutter/material.dart';
import 'package:flutternew/data/database.dart';
import 'package:flutternew/util/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../util/dialog_box.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is first time open app
    if (_myBox.get("TODOLIST")==null){
      db.createinitialData();
    }
    else{
      //there already exist data
      db.loadData();
    }

    super.initState();
  }


  //text Controller
  final _controller = TextEditingController();

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }
  // save new task
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  // create a new task
  void createNewTask(){
    showDialog(
      context: context,
      builder: (context){
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () =>Navigator.of(context).pop(),
        );
        },
    );
  }
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
      db.updateDatabase();
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:Colors.green[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('TO DO', style : TextStyle(color:Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context,index){
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList [index][1],
            onChanged: (value)=>checkBoxChanged(value,index),
            deleteFunction:(context)=>deleteTask(index),
          );
        },
      ),
    );
  }
}