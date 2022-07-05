import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "sunflower",
        textTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.white,
              fontFamily: 'paris',
              fontSize: 80.0,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 50.0,
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        )
      ),
      home: HomeScreen(),
    )
  );
}
