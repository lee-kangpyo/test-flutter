import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase/firebase.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [observer],
      home: FirebaseApp(
        analytics: analytics,
        observer:observer,
      ),
    );
  }
}

class FirebaseApp extends StatefulWidget {
  FirebaseApp({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<FirebaseApp> createState() => _FirebaseApp(analytics, observer);
}

class _FirebaseApp extends State<FirebaseApp> {
  _FirebaseApp(this.analytics, this.observer);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  late String _message;

  void setMessage(String message){
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name:"test_event",
      parameters: <String, dynamic> {
        "string":"hello flutter",
        "int": 100,
      }
    );
    setMessage("Analytics 보내기 성공");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Example"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(onPressed: _sendAnalyticsEvent, child: Text("테스트"),),
            Text(_message, style: const TextStyle(color: Colors.blueAccent),),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.tab),
        onPressed: (){},
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
