import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class ClearListApp extends StatefulWidget {
  Future<Database> db;
  ClearListApp(this.db);

  @override
  State createState() => _ClearListApp();
}

class _ClearListApp extends State<ClearListApp> {
  late Future<List<Todo>> clearList;


  @override
  void initState() {
    super.initState();
    clearList = getClearList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("완료한 일"),),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot){
              
            },
          ),
        ),
      ),
    );
  }


  Future<List<Todo>> getClearList() async {
    final Database db = await widget.db;
    List<Map<String, dynamic>> maps = await db.rawQuery('select title, content, id from todos where active = 1');
    return List.generate(maps.length, (i){
      return Todo(
        title : maps[i]['title'].toString(),
        content:maps[i]['title'].toString(),
        id:maps[i]['id'],
      );
    });
  }
}