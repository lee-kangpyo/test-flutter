import 'dart:async';

import 'package:flutter/material.dart';

import 'package:yakollyeo_delivery/module/fireBaseAnalytics.dart';
import 'package:yakollyeo_delivery/module/fileIo.dart';

class SplashApp extends StatefulWidget{

  @override
  State createState() => _SplashApp();
}

class _SplashApp extends State<SplashApp> {
  late Future<String?> cstCo;                 // 로그인할때 저장한 cstCo
  late Future<String?> userId;                // 로그인할때 저장한 userId
  late String _message;
  bool _initialized = false;
  bool _error = false;


  void setMessage(String message){
    setState(() {
      _message = message;
    });
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async{
    return Timer(Duration(seconds: 1), _init);
  }

  void _init() async {
    print("##########");
    print("##########");
    print("##########");
    print("##########");
    print("##########");


    //오래걸리는 작업 수행
    String? token = await getToken();
    print(token);
    Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false, arguments: {"token":token});
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
              Image.asset("repo/images/logo.png"),
            ],
          )
        ),
      ),
    );
  }

/*
  Future<String?> initializeFlutterFMC(context) async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      //await Firebase.initializeApp();
      //firebaseMessaging = FirebaseMessaging.instance;

      String token = (await firebaseMessaging.getToken())!;

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        print("onMessage: $message");
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(notification.title!),
                subtitle: Text(notification.body!),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('ok')
                ),
              ],
            )
        );

      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("onMessageOpenedApp: $message");
      });
      return token;
    } catch(e) {

    }
  }*/


}