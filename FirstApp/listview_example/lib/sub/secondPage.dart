import 'package:flutter/material.dart';
import '../animalItem.dart';

class SecondApp extends StatelessWidget{
  final List<Animal> list;
  SecondApp({required Key key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("두 번째 페이지"),
        ),
      ),
    );
  }
}