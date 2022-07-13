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
        appBar: AppBar(
          title: Text("버튼"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  // Material State
                  //
                  // hovered - 호버링상태 (마우스 커서를 올려놓은 상태) 모바일에서는 사용할일 없음
                  // focused - 포커스 상태 (텍스트 필드)
                  // pressed - 클릭 OR 탭
                  // dragged - 드래그 됐을때
                  // selected - 선택 됐을때 (체크박스, 라디오 버튼)
                  // scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을때
                  // disabled - 비활성화 됐을때, 버튼의 경우 onPressed 가 null일때
                  // error - 에러상태

                  // 버튼의 경우 pressed, disabled일 때 만 사용
                    // backgroundColor: MaterialStateProperty.all( Colors.black,),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states){
                          if(states.contains(MaterialState.pressed)){
                            return Colors.green;
                          }
                          return Colors.black;
                        },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                        if(states.contains(MaterialState.pressed)){
                          return Colors.white;
                        }
                        return Colors.red;
                      },
                    ),
                  padding: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      if(states.contains(MaterialState.pressed)){
                        return const EdgeInsets.all(100.0);
                      }
                      return const EdgeInsets.all(20.0);
                    },
                  )
                ),
                child: const Text("ButtonStyle"),
              ),
              //간단히 디자인하는 방법
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  //메인 색
                  primary: Colors.red,
                  // 글자 및 애니메이션 색깔
                  onPrimary: Colors.black,
                  // 그립자 색
                  shadowColor: Colors.green,
                  // 3D 입체감의 높이
                  elevation: 10.0,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 20.0),
                  // 패딩
                  padding: const EdgeInsets.all(32.0),
                  // 테두리
                  side: const BorderSide(
                    color: Colors.black,
                    width: 4.0,
                  ),
                ),
                child: const Text("ElevatedButton"),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  // 글자 및 애니메이션 색깔 - onprimary가 없다.
                  primary: Colors.amber,
                  // 배경색, 입체감까지 주면 elevatedButton과 똑같아진다.
                  // 공통되는 위젯을 상속받아 만들어졌기 때문이고 많이쓰는 템플릿 위젯이 3개라고 생각하면됨
                  // 배경색
                  //backgroundColor: Colors.yellow,
                  // 3D 입체감
                  //elevation: 10.0,
                ),
                child: const Text("OutlinedButton"),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  primary: Colors.brown,
                ),
                child: const Text("TextButton"),
              )
            ],
          ),
        ));
  }
}
