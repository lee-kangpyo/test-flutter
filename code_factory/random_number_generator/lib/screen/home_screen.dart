import 'package:flutter/material.dart';
import 'package:random_number_generator/constant/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          // EdgeInsets.zero - 패딩 0
          // EdgeInsets.all - 상하좌우 모든 곳에 적용
          // EdgeInsets.fromLTRB - 왼쪽, 위, 오른쪽 아래
          // EdgeInsets.only(top: 16.0, bottom:16.0) - 네임드 파라메터로 적용
          // EdgeInsets.symmetric(horizontal: 16,vertical: 0) - 대칭으로 적용
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "랜덤숫자 생성기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      color: RED_COLOR,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [123, 456, 789]
                        .asMap().entries
                        .map(
                          (x) => Padding(
                            padding: EdgeInsets.only(bottom: x.key == 2 ? 0 : 16.0),
                            child: Row(
                              children: x.value
                                  .toString()
                                  .split("")
                                  .map(
                                    (y) => Image.asset(
                                      'asset/img/$y.png',
                                      height: 70.0,
                                      width: 50.0,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                        .toList()),
              ),
              // container, sizedBox
              // sizedBox는 기능이 좀더 적은 위젯 너비, 높이만 설정가능 성능이 미세하게 좋음
              // container는 색, 테두리 등을 설정 가능
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: RED_COLOR),
                  onPressed: () {},
                  child: Text("생성하기!"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
