import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 최상위 위젯에서 상태를 관리하는 이유는 데이터가 여러곳에 분산되어있으면 흐름을 보기가 아주 힘들어진다.
// 어디서 어떤 데이터를 다룰수 있는지 찾아야되고 찾기가 힘들어진다.
// 따라서 데이터를 한곳에서 관리하는게 좋다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: SafeArea(
          bottom: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                _TopPart(
                    selectedDate: selectedDate,
                    onPressed: onHeartPressed,
                ),
                _BottomPart(),
              ],
            ),
          ),
        ));
  }

  void onHeartPressed(){
      final DateTime now = DateTime.now();
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 300.0,
              child: CupertinoDatePicker(
                // 초기화값을 넣고, 최대 값을 넣어줘야함 그렇지않으면 오류발생
                // 오늘날짜 00:00:00은 지금시간보다 이전이므로
                initialDateTime: selectedDate,
                maximumDate: now,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
          );
        },
      );
  }
}

class _TopPart extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPressed;

  _TopPart({
    required this.selectedDate,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // context를 가져와서 of를 사용
    // of를 사용하는 위젯의 큰 특징은 inherited 위젯임임
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final now = DateTime.now();

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("U&I", style: textTheme.headline1,),
          Column(
            children: [
              Text("우리 처음 만난날", style: textTheme.bodyText1,),
              Text(
                  "${selectedDate.year}.${selectedDate.month}.${selectedDate.day}",
                  style: textTheme.bodyText2,
              ),
            ],
          ),
          IconButton(
              iconSize: 60.0,
              onPressed: onPressed,
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              )),
          Text(
            "D+${DateTime(now.year, now.month, now.day).difference(selectedDate).inDays + 1}",
            style: textTheme.headline2,
          ),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.asset(
        'asset/img/middle_image.png',
      ),
    );
  }
}
