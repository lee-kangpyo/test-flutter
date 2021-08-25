import 'package:flutter/material.dart';

class SubDetail extends StatefulWidget {
  @override
  State<SubDetail> createState() => _SubDetail();
}

class _SubDetail extends State<SubDetail>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sub Detail Example'),),
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text("두 번째 페이지로 이동하기"),
            onPressed: (){
              Navigator.of(context).pushNamed("/second");
            },
          ),
        ),
      ),
    );
  }
}