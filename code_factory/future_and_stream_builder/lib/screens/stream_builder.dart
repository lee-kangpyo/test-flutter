import 'dart:math';

import 'package:flutter/material.dart';

class StreamHomeScreen extends StatefulWidget {

  const StreamHomeScreen({Key? key}) : super(key: key);

  @override
  State<StreamHomeScreen> createState() => _StreamHomeScreenState();
}

class _StreamHomeScreenState extends State<StreamHomeScreen> {
  bool bol = false;
  @override
  Widget build(BuildContext context) {
    bol = !bol;
    TextStyle textStyle = const TextStyle(fontSize: 20.0);
    return Scaffold(
      appBar: AppBar(title: Text("StreamBuilder")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
          stream: StreamNumbers(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "FutureBuilder",
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                  ),
                ),
                Text("ConState : ${snapshot.connectionState}",
                    style: textStyle),
                Row(
                  children: [
                    Text("Data : ${snapshot.data}", style: textStyle),
                    // 데이터는 두고 로딩이 돌아가는것을 추가로 보여주면 앱이 스무스하게 돌아가는것을 보임
                    if (snapshot.connectionState == ConnectionState.waiting)
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                  ],
                ),
                Text("Error : ${snapshot.error}", style: textStyle),
                // setState()를 실행해서 build를 다시 실행하면 data를 캐싱 해두고 새로운
                // Future가 리턴될때까지 기존의 데이터 값을 기억한다.
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text("setState")),
              ],
            );
          },
        ),
      ),
    );
  }

  Stream<int> StreamNumbers() async* {
    for(int i = 0; i < 10; i++){
      await Future.delayed(Duration(seconds: 1));

      yield i;

      if(i == 5){
        throw Exception("i = 5");
      }
    }
  }
}
