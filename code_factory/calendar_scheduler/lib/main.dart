import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 초기화가 되었는지 확인하라
  // 플러터 프레임 워크가 준비가 될때까지 기다림 runApp()이 실행될때 자동으로 실행
  // runApp 실행전에 코드가 실행되야 하므로 따로 실행해줌
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "NotoSans",
      ),
      home: HomeScreen(),
    )
  );
}
