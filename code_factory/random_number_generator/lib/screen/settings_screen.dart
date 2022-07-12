import 'package:flutter/material.dart';
import 'package:random_number_generator/component/number_row.dart';

import '../constant/color.dart';

class SettingsScreen extends StatefulWidget {
  final int maxNumber;
  const SettingsScreen({required this.maxNumber, Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 1000;

  //액티비티가 새로 생성될때 호출되는 함수 빌드를 실행하기전에 실행이된다.
  @override
  void initState() {
    super.initState();

    maxNumber = widget.maxNumber.toDouble();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _top(
                  maxNumber: maxNumber,
                ),
                _bottom(
                  maxNumber: maxNumber,
                  onButtonPressed: onButtonPressed,
                  onSliderChanged: onSliderChanged,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSliderChanged(double val) {
    setState(() {
      maxNumber = val;
    });
  }

  void onButtonPressed() {
    Navigator.of(context).pop(maxNumber.toInt());
  }
}

class _top extends StatelessWidget {
  final double maxNumber;
  const _top({
    required this.maxNumber,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(
        number: maxNumber.toInt(),
      ),
    );
  }
}

class _bottom extends StatelessWidget {
  final ValueChanged<double>? onSliderChanged;
  final VoidCallback onButtonPressed;
  final maxNumber;
  const _bottom(
      {required this.onSliderChanged,
      required this.onButtonPressed,
      required this.maxNumber,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: maxNumber,
          min: 1000,
          max: 100000,
          onChanged: onSliderChanged,
        ),
        ElevatedButton(
          onPressed: onButtonPressed,
          style: ElevatedButton.styleFrom(primary: RED_COLOR),
          child: Text("저장!"),
        ),
      ],
    );
  }
}
