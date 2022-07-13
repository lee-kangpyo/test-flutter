import 'package:flutter/material.dart';
import 'package:navigation/layout/layout/main_layout.dart';

class RouteThreeScreen extends StatelessWidget {
  const RouteThreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agument = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
      title: "라우트 3",
      children: [
        Text("arguments : $agument", textAlign: TextAlign.center),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Pop"),
        ),
      ],
    );
  }
}
