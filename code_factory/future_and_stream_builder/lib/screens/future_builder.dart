import 'dart:math';

import 'package:flutter/material.dart';

class FutureHomeScreen extends StatefulWidget {

  const FutureHomeScreen({Key? key}) : super(key: key);

  @override
  State<FutureHomeScreen> createState() => _FutureHomeScreenState();
}

class _FutureHomeScreenState extends State<FutureHomeScreen> {
  bool bol = false;
  @override
  Widget build(BuildContext context) {
    bol = !bol;
    TextStyle textStyle = const TextStyle(fontSize: 20.0);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<int>(
          future: getNumber(bol),
          builder: (context, snapshot) {
            // 이전에 강의에서 사용한 waiting시 인디게이터를 보여주는것은 좋지 않다.
            // setState가 실행되서 시간이 좀 걸리는 작업이 있다면 앱이 느려 보일것이다.
            //if(snapshot.connectionState == ConnectionState.waiting){
            //  return Center(child: CircularProgressIndicator(),);
            //}

            if (!snapshot.hasError && !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              // 데이터가 있을때 위젯 렌더링
            }
            if(snapshot.hasError){
              // 에러가 났을때 위젯 렌더링
            }
            // 로딩중일때 위젯 렌더링

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

  Future<int> getNumber(bol) async {
    await Future.delayed(Duration(seconds: 3));
    final random = Random();
    if (bol) {
      throw Exception("에러가 발생했습니다");
    }
    return random.nextInt(100);
  }
}
