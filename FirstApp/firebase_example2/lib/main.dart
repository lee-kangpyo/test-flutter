import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'tabPage.dart';
import 'memoPage.dart';



void main() =>  runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [observer],
      home: FirebaseApp(analytics:analytics, observer:observer, key: UniqueKey(),),
      //home: MemoPage(),
    );
  }
}

class FirebaseApp extends StatefulWidget {
  FirebaseApp({required Key key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<FirebaseApp> createState() => _FirebaseApp(analytics, observer);
}

class _FirebaseApp extends State<FirebaseApp> {
  _FirebaseApp(this.analytics, this.observer);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  String _message = "";

  void setMessage(String message){
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: "test_event",
      parameters: <String, dynamic>{
        "string":"hello flutter",
        "int":100,
      },
    );
    setMessage('Analytics 보내기 성공');
  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: _sendAnalyticsEvent, child: Text("테스트")),
            Text(_message, style: TextStyle(color: Colors.blueAccent),),
          ],
        ),
      ),
      floatingActionButton: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TabsPage(observer),settings: RouteSettings(name: '/tab') ));
              },
              child: Icon(Icons.tab),
            ),
          ),

          FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemoPage(),settings: RouteSettings(name: '/momo') ));
            },
            child: Icon(Icons.menu_book),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      )  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
