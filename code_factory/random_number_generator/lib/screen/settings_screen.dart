import 'package:flutter/material.dart';

import '../constant/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 1000;
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
                Expanded(
                  child: Row(
                    children: maxNumber.toInt()
                        .toString()
                        .split("")
                        .map(
                          (e) => Image.asset(
                            "asset/img/$e.png",
                            width: 50.0,
                            height: 70.0,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Slider(
                  value: maxNumber,
                  min: 1000,
                  max : 100000,
                  onChanged: (double val) {
                    setState((){
                      maxNumber = val;
                    });

                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // pop() - 액티비티를 터뜨리는것
                    // 인자로 전달할 데이터를 넣어주면된다.
                    Navigator.of(context).pop(maxNumber.toInt());
                  },
                  style: ElevatedButton.styleFrom(primary: RED_COLOR),
                  child: Text("저장!"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
