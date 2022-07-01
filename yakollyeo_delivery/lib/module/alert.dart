import 'package:flutter/material.dart';

Widget commomAlert({required BuildContext context, String title = "", String content = "", String btnName = "close", var callback}) {

  return AlertDialog(
    title: new Text(title),
    content: new Text(content),
    actions: <Widget>[
      new TextButton(
        child: new Text(btnName, style: TextStyle(color: Color(0xff26c998)),),
        onPressed: () {
          if(callback != null) {callback();}
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget commomConfirm({required BuildContext context, String title = "", String content = "", List<String> btnName = const ["취소", "확인"], var callback }) {
  return AlertDialog(
    title: new Text(title),
    content: new Text(content),
    actions: <Widget>[

      new TextButton(
        child: new Text(btnName[0], style: TextStyle(color: Colors.grey),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      new TextButton(
        child: new Text(btnName[1], style: TextStyle(color: Color(0xff26c998)),),
        onPressed: () {
          if(callback != null) {callback();}
          Navigator.pop(context);
        },
      ),
    ],
  );
}