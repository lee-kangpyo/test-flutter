import 'dart:async';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'loginPage.dart';
import 'package:yakollyeo_delivery/main.dart';

class SplashApp extends StatefulWidget{
  @override
  State createState() => _SplashApp();
}

class _SplashApp extends State<SplashApp> {

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async{
    return Timer(Duration(seconds: 5), _init);
  }

  void _init() async {
    //오래걸리는 작업 수행
    Navigator.of(context).pushNamed("/login");
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(tag: "logo", child: Image.asset("repo/images/logo.png"),),
            ],
          )
        ),
      ),
    );
  }


}