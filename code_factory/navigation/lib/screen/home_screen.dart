import 'package:flutter/material.dart';
import 'package:navigation/layout/layout/main_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // true - pop() 가능
        // false - pop() 불가능
        // 일부러 pop() 버튼을 눌러서 지우는것은 막을수는 없지만 시스템 뒤로가기는 막을수 있다.
        final canPop = Navigator.of(context).canPop();
        return canPop;
      },
      child: MainLayout(
        title: "홈스크린",
        children: [
          // canPop은 pop이 가능한지 체크하는 메소드
          ElevatedButton(
            onPressed: () {
              print(Navigator.of(context).canPop());
            },
            child: Text("Can Pop"),
          ),
          // 라우트 스택에 있는 페이지가 하나이면 pop()이 싱행되지 않는다.
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            child: Text("Maybe Pop"),
          ),
          // [HomeScreen()] -> [] 검은 스크린으로 변경
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("POP"),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const RouteOneScreen(
                    number: 123,
                  ),
                ),
              );

              print(result);
            },
            child: const Text("Push"),
          ),
        ],
      ),
    );
  }
}
