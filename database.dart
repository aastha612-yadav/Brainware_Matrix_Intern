import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {

  List toDoList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // opening app for the first time
  void createinitialData(){
    toDoList = [
      ["Exercise", false],
      ["Work",false],
    ];
  }

  // load the data from database
  void loadData(){
    toDoList=_myBox.get("TODOLIST");
  }

// update the database
  void updateDatabase(){
    _myBox.put("TODOLIST",toDoList);
  }
}