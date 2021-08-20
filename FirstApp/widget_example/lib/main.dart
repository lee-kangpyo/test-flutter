import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: WidgetApp(),
    );
  }
}


class WidgetApp extends StatefulWidget{
  //WidgetApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetExapleState();
}

class _WidgetExapleState extends State<WidgetApp>{
  String sum = "";
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget Example"),),
      body:Container(
        child:Center(
          child:Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Text("flutter caculator"),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text( '결과 : $sum', style: TextStyle(fontSize: 20), ),
              ),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: TextField(keyboardType: TextInputType.number, controller: value1,),
              ),
              Padding(
                padding: EdgeInsets.only(left:20, right:20),
                child: TextField(keyboardType: TextInputType.number, controller: value2,),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      int result = int.parse(value1.value.text) + int.parse(value2.value.text);
                      sum = '$result';
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      Text("더하기"),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    onPrimary: Colors.black,
                  ),
                ),
              ),

            ],
          )
        )
      )
    );
  }
}