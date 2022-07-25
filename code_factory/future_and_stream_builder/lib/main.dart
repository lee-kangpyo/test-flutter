import 'package:flutter/material.dart';
import 'package:future_and_stream_builder/screens/future_builder.dart';
import 'package:future_and_stream_builder/screens/home_screen.dart';
import 'package:future_and_stream_builder/screens/stream_builder.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        "/" : (context) => HomeScreen(),
        "/future" : (context) => FutureHomeScreen(),
        "/stream" : (context) => StreamHomeScreen(),
      },
    )
  );
}
