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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const로 위젯을 인스턴스로 만들면 이위젯은 앱이 실행하는 동안 단 한번만 그리고
            // 다음에 build 했을때 이미 그려놓은 위젯을 재사용함을 알수 있다.
            // 플러터 프레임 워크는 build 함수를 여러번 재실행해서 위젯의 상태를 변경해주지만
            // 렌더링할때 const를 사용한 위젯이 많으면 많을수록 리소스 사용에 유리하다.
            const TestWidget(label: "test1"),
            const TestWidget(label: "test2"),
            ElevatedButton(
                onPressed: (){
                  // setState를 실행하면 build가 실행된다.
                  setState((){});
                },
                child: const Text("빌드!"),
            ),
          ],
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  final String label;
  const TestWidget({
    required this.label,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("$label build 실행");

    return Container(
      child: Text(label),
    );
  }
}
