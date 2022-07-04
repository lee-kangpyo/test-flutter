import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      // controller.page의 리턴타입이 double인 이유는 페이지가 이동한 거리까지 계산하기때문에
      // 0.5는 0번과 1번 사이에 반만 보이는 상태
      int cureentPage = controller.page!.toInt();
      int nextPage = cureentPage + 1;

      if(nextPage > 4){
        nextPage = 0;
      }

      // curve : 애니메이션이 어떤방식으로 실행되는지지
     controller.animateToPage(nextPage, duration: Duration(milliseconds: 400), curve: Curves.linear);

    });
  }

  @override
  void dispose() {
    controller.dispose();
    if(timer != null){
      timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 상태바를 검정색으로 변경할수있음
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [1, 2, 3, 4, 5].map(
                (e) => Image.asset("asset/img/image_$e.jpeg", fit: BoxFit.cover,)
        ).toList(),
      ),
    );
  }
}
