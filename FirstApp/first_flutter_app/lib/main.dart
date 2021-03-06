import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    print("createState");
    return _MyApp();
  }
}

/*
 *  상태가 변경되지 않는 StatelessWidget을 상속 받은 클래스에 build를 재정의함
 *  맨처음 runApp() 함수를 이용해 프로그램을 실행할때는 MaterialApp을 리턴해줘야함.
 *  MaterialApp은 그림을 그리는데 필요한 도화지 정도로 이해하고
 *  title(앱의 이름), theme(디자인), home(화면에 어떤 내용을 표시할지를 정함)등이 정의되어있음
 */
class _MyApp extends State<MyApp> {
  var switchValue = false;
  String test = 'hello';
  Color _color = Colors.blue;

  @override
  void initState() {
    super.initState();
    print("initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.light(),
      home: Scaffold(
        body:Center(
          child:ElevatedButton(
            child: Text('$test'),
            style: ElevatedButton.styleFrom(
              primary: _color, // background
            ),
            onPressed: () {
              if(test == "hello"){
                setState(() {
                  test = 'flutter';
                  _color = Colors.amber;
                });
              }else{
                setState(() {
                  test = 'hello';
                  _color = Colors.blue;
                });
              }
            },
          )
        )
      )
    );
  }
}
