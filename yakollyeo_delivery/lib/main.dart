import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yakollyeo_delivery/module/fireBaseAnalytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'views/loginPage.dart';
import 'views/splash.dart';
import 'views/MainPage.dart';
import 'views/preOrderPage.dart';
import 'views/newOrderPage.dart';
import 'views/postSearchPage.dart';



final routes = {
  "/":(context) => MyHomePage(title: "로그인 테스트"),// LoginApp(),
  "/splash":(context) => SplashApp(),
  "/login":(context) => LoginApp(),
  "/main":(context) => MainApp(),
  "/preOrder":(context) => PreOrderApp(),
  "/newOrder":(context) => NewOrderApp(),
  "/searchPost":(context) => PostSearch(title: "우편번호 검색"),
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: routes,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }


}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text("firebase load fail"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Text("firebase load complete"),
          );//Navigator.of(context).pushNamed("/login");*/
        }
        return CircularProgressIndicator();
      },
    );
  }
}
