import 'package:flutter/material.dart';
import 'package:navigation/layout/layout/main_layout.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
      title: "라우트 2",
      children: [
        Text("arguments:$arguments", textAlign: TextAlign.center,),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(456);
          },
          child: const Text("Pop"),
        ),
      ],
    );
  }
}
