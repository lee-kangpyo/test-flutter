import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/future");
              },
              child: Text("FutureBuilder"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/stream");
              },
              child: Text("StreamBuilder"),
            ),
          ],
        ),
      ),
    );
  }
}
