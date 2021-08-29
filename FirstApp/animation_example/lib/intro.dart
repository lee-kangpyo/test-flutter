import 'package:flutter/material.dart';
import 'package:animation_example/saturenLoading.dart';
import 'dart:async';
import 'main.dart';

class IntroPage extends StatefulWidget {

  @override
  State createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 5), onDoneLoading);
  }

  void onDoneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AnimationApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text("애니메이션 앱"),
              SizedBox(height: 20,),
              SaturenLoading(),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

}