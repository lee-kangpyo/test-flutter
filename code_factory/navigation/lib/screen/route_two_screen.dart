import 'package:flutter/material.dart';
import 'package:navigation/layout/layout/main_layout.dart';
import 'package:navigation/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
      title: "라우트 2",
      children: [
        Text(
          "arguments:$arguments",
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(456);
          },
          child: const Text("Pop"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              "/three",
              arguments: "pushNamed",
            );
          },
          child: Text("Push named"),
        ),

        //replace 2를 3로 대체 하므로 3에서 pop() 할경우 1로 돌아간다.
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              "/three",
              arguments: "pushReplacementNamed",
            );
          },
          child: Text("Push Replacement Named"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/three",
              (route) => route.settings.name == "/",
            );
          },
          child: Text("Push Named And Remove Until"),
        ),
      ],
    );
  }
}
