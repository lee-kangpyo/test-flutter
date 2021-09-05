import 'dart:convert';

import 'package:flutter/material.dart';
import '../vo/userVo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class LoginApp extends StatefulWidget {

  @override
  State createState() => _LoginApp();
}

class _LoginApp extends State<LoginApp> {
  late var token;
  final _formKey = new GlobalKey<FormState>();

  User user = User();

  void validateAndSave() {
    print("토큰값 : "+token);
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      test();
      print('Form is valid id: ${user.id}, password: ${user.passWord}');
    } else {
      print('Form is invalid id: ${user.id}, password: ${user.passWord}');
    }
  }

  void test() async {

    var url = Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }


  @override
  Widget build(BuildContext context) {
    final Map<String, String?> modalRoute = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    token = modalRoute['token'];

    return Scaffold(
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
                  onTap: (){Navigator.of(context).pushReplacementNamed("/login");},
                  child: Padding(padding: EdgeInsets.all(20), child: Image.asset("repo/images/logo.png"),),
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