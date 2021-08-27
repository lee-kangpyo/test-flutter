import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class AddTodoApp extends StatefulWidget{
  final Future<Database> db;
  AddTodoApp(this.db);

  @override
  State createState() => _AddTodoApp();


}

class _AddTodoApp extends State<AddTodoApp> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo 추가"),),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "제목", hintText: "제목을 입력해"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: "할일"),
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    Todo todo = Todo(title: titleController.value.text, content: contentController.value.text, active: false);
                    Navigator.of(context).pop(todo);
                  },
                  child: Text("저장하기")
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

}