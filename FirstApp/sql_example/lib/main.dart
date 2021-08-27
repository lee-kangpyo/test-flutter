import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'todo.dart'; //Vo
import 'addTodo.dart'; //add
import 'clearList.dart'; //clear

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Database> db = initDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => DatabaseApp(db),
        '/add' : (context) => AddTodoApp(db),
        '/clear': (context) => ClearListApp(db),
      },
    );
  }
  
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version){
        return db.execute("CREATE TABLE TODOS(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, active BOOL)");
      },
      version: 1,
    );
  }
  
}

class DatabaseApp extends StatefulWidget {
  final Future<Database> db;
  DatabaseApp(this.db);

  @override
  State createState() => _DatabaseApp();
}

class _DatabaseApp extends State<DatabaseApp>{
  late Future<List<Todo>> todoList;

  @override
  void initState() {
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database Example"),
        actions: [
          TextButton(onPressed: () async {
              await Navigator.of(context).pushNamed("/clear");
              setState(() {
                todoList = getTodos();
              });
            }, child: Text("완료만보기", style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Container(
        child: Center(
          child: FutureBuilder (
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if(snapshot.hasData){
                    var data = snapshot.data as List<Todo>;
                    return ListView.builder(
                      itemBuilder: (context, index){
                        Todo todo = data[index];
                        return ListTile(
                          leading: Text("앞"),
                          trailing: Text("뒤"),
                          title: Text(todo.title!, style: TextStyle(fontSize: 20),),
                          subtitle: Container(
                            child: Column(
                              children: [
                                Text(todo.content!),
                                Text("체크 : ${todo.active.toString()}"),
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            TextEditingController controller = TextEditingController(text: todo.content);
                            Todo result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: TextField(controller: controller, keyboardType: TextInputType.text,),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        setState(() {
                                          todo.active == true ? todo.active = false : todo.active = true;
                                          todo.content = controller.value.text;
                                          Navigator.of(context).pop(todo); // 예일경우 result에 todo를 전달
                                        });
                                      }, child: Text("수정")),
                                    TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("취소")),
                                  ],
                                );
                              }
                            );
                            if (result != null){
                              _updateTodo(result);
                            }
                          },
                          onLongPress: () async {
                            Todo result = await showDialog(
                              context:context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("${todo.id} : ${todo.title}"),
                                  content: Text("${todo.content}를 삭제하시겠습니까?"),
                                  actions: [
                                    TextButton(onPressed: (){
                                        Navigator.of(context).pop(todo);
                                      }, child: Text("예")),
                                    TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("아니오")),
                                  ],
                                );
                              },
                            );
                            if(result != null){
                              _deleteTodo(result);
                            }
                          },
                        );
                      },
                      itemCount: data.length,
                    );
                  }else{
                    return Text("No data");
                  }
              }
            },
            future: todoList,
          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final  todo = await Navigator.of(context).pushNamed("/add");
          _insertTodo(todo as Todo);
                  },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  void _deleteTodo (Todo todo) async {
    final Database db = await widget.db;
    await db.delete('todos', where:"id=?", whereArgs: [todo.id]);
    setState(() {
      todoList = getTodos();
    });
  }

  void _updateTodo (Todo todo) async {
    final Database db = await widget.db;
    await db.update('todos', todo.toMap(), where: 'id=?', whereArgs: [todo.id]);
    setState(() {
      todoList = getTodos();
    });
  }

  void _insertTodo(Todo todo) async {
    final Database database = await widget.db; // 현재 클래스의 전역 변수를 참조할수 있다. 여기서는 final Future<Database> db;를 참조함
    await database.insert( 'todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace, );
    setState(() {
      todoList = getTodos();
    });
  }


  Future<List<Todo>> getTodos() async {
    final Database db = await widget.db;
    final List<Map<String, dynamic>> maps = await db.query("todos");

    return List.generate(maps.length,
      (i) {
         bool active = maps[i]['active'] == 1 ? true : false;
         return Todo(
            title : maps[i]['title'].toString(),
            content : maps[i]['content'].toString(),
            active : active,
            id : maps[i]['id'],
         );
      }
    );
  }


}