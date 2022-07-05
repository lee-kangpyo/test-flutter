import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("랜덤숫자 생성기"),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("123"),
                  Text("456"),
                  Text("789"),
                ],
              ),
            ),
            // container, sizedBox
            // sizedBox는 기능이 좀더 적은 위젯 너비, 높이만 설정가능 성능이 미세하게 좋음
            // container는 색, 테두리 등을 설정 가능
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("생성하기!"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
