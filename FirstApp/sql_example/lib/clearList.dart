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
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData){
                    var data = snapshot.data as List<Todo>;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Todo todo = data[index];
                        return ListTile(
                          title: Text(todo.title!, style: TextStyle(fontSize: 20),),
                          subtitle: Container(
                            child: Column(
                              children: [
                                Text(todo.content!),
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: data.length,
                    );
                  }
                  return Text("no Data");
              }
            },
            future: clearList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("완료한 일 삭제"),
                content: Text("완료한 일을 모두 삭제할까요?"),
                actions: [
                  TextButton(onPressed: () {Navigator.of(context).pop(true);}, child: Text("예")),
                  TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text("아니오")),
                ],
              );
            }
          );
          if (result == true){
            _removeAllTodos();
          }
        },
        child: Icon(Icons.remove),),
    );
  }

  Future<void> _removeAllTodos() async {
    final Database db = await widget.db;
    db.rawDelete('delete from todos where active = 1');
    setState(() {
      clearList = getClearList();
    });
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