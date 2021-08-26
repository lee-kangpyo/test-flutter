import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments;
    final args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text("Third Page"),),
      body: Container(
        child: Center(
          child:Text(args.toString(), style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
