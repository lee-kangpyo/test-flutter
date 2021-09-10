import 'package:flutter/material.dart';

Widget commomAlert({required BuildContext context, String title = "", String content = "", String btnName = "close", var callback}) {
    return AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        new TextButton(
          child: new Text(btnName),
          onPressed: () {
            if(callback != null) {callback();}
            Navigator.pop(context);
          },
        ),
      ],
    );
}
