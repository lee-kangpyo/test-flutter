import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:flutter/material.dart';

import '../component/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDay: selectedDay,
              scheduleCount: 4,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.separated(
                  // itemCount에 10개를 지정해서 10개의 리스트가 보일것을 명시
                  itemCount: 10,
                  // itemBuilder -> separatorBuilder -> itemBuilder 순으로 실행이됨
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8.0,
                    );
                  },
                  // 각각의 카드마다 itemBuilder가 실행이됨 (index가 달라짐)
                  // 강력한 기능은 모든 위젯를 만들어 두는게 아니라 스크롤할때마다
                  // 새로운 위젯을 생성해서 밑에 붙여줌.
                  // (100개를 생성해도 처음엔 10개만 스크롤 할때마다 추가로 생성)
                  itemBuilder: (context, index) {
                    return ScheduleCard(
                      startTime: 9,
                      endTime: 12,
                      content: '프로그래밍 공부하기. ${index}',
                      color: Colors.red,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}
