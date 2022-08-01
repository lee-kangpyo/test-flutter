import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //키보드가 올라올 때 그만큼 패딩을 줘야함
    // 스크린에 해당되는 부분에서 시스템적 UI로 가려진 사이즈를 가져올수있다.
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2 + bottomInset,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          children: [
            TextField()
          ],
        ),
      ),
    );
  }
}
