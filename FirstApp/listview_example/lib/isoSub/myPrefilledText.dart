import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import '../animalItem.dart';

class MyPrefilledText extends StatefulWidget {
  //final List<Animal> animalList;
  //const MyPrefilledText({Key? key, required this.animalList}) : super(key: key);
  String test;
  MyPrefilledText({Key? key, required this.test}) : super(key: key);

  @override
  _MyPrefilledTextState createState() {
    return _MyPrefilledTextState();
  }
}

class _MyPrefilledTextState extends State<MyPrefilledText> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'initial text');
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: Center(
          child: Column(
            children: [
              CupertinoTextField(controller: _textController),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        )
    );
  }
}