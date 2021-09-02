import 'dart:convert';

import 'package:flutter/material.dart';
import '../vo/userVo.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginApp extends StatefulWidget {
  @override
  State createState() => _LoginApp();
}

class _LoginApp extends State<LoginApp> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _formKey = new GlobalKey<FormState>();

  User user = User();

  void validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid id: ${user.id}, password: ${user.passWord}');
    } else {
      print('Form is invalid id: ${user.id}, password: ${user.passWord}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("약올려 로그인 페이지"),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){Navigator.of(context).pushReplacementNamed("/login")},
                  child: Padding(padding: EdgeInsets.all(20), child: Hero(tag: "logo", child: Image.asset("repo/images/logo.png"),),),
                ),
                formIdField(),
                formPasswordField(),
                formButtonGroup(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget formIdField(){
    return Padding(padding: EdgeInsets.all(10), child:TextFormField(
      decoration: InputDecoration(labelText: '아이디', border: OutlineInputBorder(),),
      validator: (value) => value!.isEmpty? '아이디는 공백일수 없습니다.':null,
      onSaved: (value) => user.id = value,
    )
    );
  }

  Widget formPasswordField(){
    return Padding(padding: EdgeInsets.all(10), child:TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: '패스워드', border: OutlineInputBorder(),),
      validator: (value) => value!.isEmpty? '패스워드는 공백일수 없습니다.':null,
      onSaved: (value) {
        var bite = utf8.encode(value!);
        print(bite);

        user.passWord = value;
      },
    )
    );
  }

  Widget formButtonGroup(){
    return Padding(padding: EdgeInsets.all(10),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: validateAndSave, child: Text("Login", style: TextStyle(fontSize: 20),)),
            ElevatedButton(onPressed: (){}, child: Text("regist", style: TextStyle(fontSize: 20),)),
          ],
        )
    );
  }

}