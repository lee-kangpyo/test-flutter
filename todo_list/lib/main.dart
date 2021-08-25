import 'package:flutter/material.dart';
import 'subDetail.dart';
import 'secondDetail.dart';
import 'thirdPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String _title = "Widget Example";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      initialRoute: '/',
      routes: {
        '/' : (context) => SubDetail(),
        '/second' : (context) => SecondDetail(),
        '/third' : (context) => ThirdPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    );
  }
}
