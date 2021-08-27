import 'package:flutter/material.dart';
import 'largeFileMain.dart';
import 'introPage..dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Thisted.
        primarySwatch: Colors.blue,
      ),
      home: IntroPage(),
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
    // This methividually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text('로고 바꾸기'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LargeFileMain()));
            },
            child: Text('로고 바꾸기', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Container(
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
