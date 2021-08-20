import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Materal Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MateralFlutterApp(),
    );
  }
}


class MateralFlutterApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaterialFlutterApp();
  }

}

class _MaterialFlutterApp extends State<MateralFlutterApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Material Design App"),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {  },
      ),
      body: Container(
        child:Center(
            child:Column(
              children: [
                Icon(Icons.android),
                Text("android"),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
        )
      )
    );
  }
}
