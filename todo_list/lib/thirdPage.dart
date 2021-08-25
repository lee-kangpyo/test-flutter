import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Third Page"),),
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text("첫 번째 페이지 돌아가기"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}