import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginApp extends StatefulWidget {
  @override
  State createState() => _LoginApp();
}

class AppState {
  //bool loading;
  //FirebaseUser user;
  //AppState(this.loading, this.user);
}

class _LoginApp extends State<LoginApp> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _formKey = new GlobalKey<FormState>();

  late String _id;
  late String _password;

  void validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid id: $_id, password: $_password');
    } else {
      print('Form is invalid Email: $_id, password: $_password');
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
            key: _formKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: '아이디', border: OutlineInputBorder(),),
                    validator: (value) => value!.isEmpty? '아이디는 공백일수 없습니다.':null,
                    onSaved: (value) => _id = value!,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: '패스워드', border: OutlineInputBorder(),),
                    validator: (value) => value!.isEmpty? '패스워드는 공백일수 없습니다.':null,
                    onSaved: (value) => _password = value!,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: validateAndSave, child: Text("Login", style: TextStyle(fontSize: 20),)),
                      ElevatedButton(onPressed: (){}, child: Text("regist", style: TextStyle(fontSize: 20),)),
                    ],
                  )

                ),

              ],
            )
          ),
        ),
      ),
    );
  }
}