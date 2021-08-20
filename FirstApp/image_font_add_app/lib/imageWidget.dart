import 'package:flutter/material.dart';

class ImageWidgetApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageWidgetApp();
  }
}

class _ImageWidgetApp extends State<ImageWidgetApp>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Widget")),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("image/lion.jpg", width: 200, height: 100, fit: BoxFit.fill,),
              Text("Hello flutter",
                style: TextStyle(fontFamily: 'Pacifico', fontSize: 30, color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}