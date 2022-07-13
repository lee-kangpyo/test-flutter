import 'package:flutter/material.dart';
import 'package:navigation/layout/layout/main_layout.dart';
import 'package:navigation/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {
  final int number;
  const RouteOneScreen({
    required this.number,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "라우트 1",
      children: [
        Text(
          number.toString(),
          // MainLayout에 crossAxisAlignment: CrossAxisAlignment.stretch 가 되어있는데도
          // 가운데로 가지 않기 때문에 center로 설정
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(456);
          },
          child: const Text("pop"),
        ),
        ElevatedButton(
          onPressed: () {
            // [HomeScreen(), RouteOne(), RouteTwo()] 같이 스택으로 쌓인다.
            // 데이터를 전달하는 두번째 방법
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RouteTwoScreen(),
                settings: RouteSettings(
                  arguments: 789,
                ),
              ),
            );
          },
          child: const Text("Push"),
        ),
      ],
    );
  }
}
