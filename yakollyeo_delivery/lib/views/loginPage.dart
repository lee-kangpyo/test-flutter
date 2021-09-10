import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../vo/userVo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';

import 'package:yakollyeo_delivery/module/alert.dart';
import 'package:yakollyeo_delivery/module/fileIo.dart';
import 'package:yakollyeo_delivery/module/urlIfo.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:encrypt/encrypt.dart';


class LoginApp extends StatefulWidget {
  @override
  State createState() => _LoginApp();
}

class _LoginApp extends State<LoginApp> {
  late String publicKey;
  late String privateKey;
  final _formKey = new GlobalKey<FormState>();
  var _firstTab = true;
  User user = User();


  @override
  void initState() {
    super.initState();
    publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkapd53FWX2vpTDeUbo1wZcOMxLMdSXG5Lz1C7MOUyxu34LpSkZxcAkU5Yl73Pm5lB9+rsL+L0mHv0hK5vg6hWsy9bSHBk0FbW15BYtud1mULNzkjF9yYd5NDN6kT+OIybQXvTm/l+mNz/pfwm6QhzujRsTnAE3bBcr87oikdchNQ9ZDCmhwR9sIULEiRMMvU6XsVYg49NuPGQRJuxTIh0QsGyN1NbbNhdwtYvITTzmEcpT/jtpqOC2tock/EoncvUjrMjQ5R+ttjtW4WbFAzQuNgtjrKuzCrVMjVR3hYowrH0O5FwB6DhcDGAlEaZakn4b7vh1mBh3Jungg0hlPqjQIDAQAB";
  }

  void validateAndSave() {
    if(_firstTab) {
      //_firstTab = false;

      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();
        reqLogin();
      } else {
        print('Form is invalid id: ${user.id}, password: ${user.passWord}, token: ${user.token}');
      }
    }
  }

  void reqLogin() async {
    var url = Uri.http(getHost (), getUrlPath("login"));
    //var url = Uri.http('admin.yakollyeo.com', '/api/v1/login.do');
    print("##############################");
    var helper = RsaKeyHelper();
    var pubk = helper.parsePublicKeyFromPem(publicKey);
    //var prik = helper.parsePrivateKeyFromPem(privateKey);
    final encrypter = Encrypter(RSA(publicKey: pubk));

    final encrypted =  encrypter.encrypt(user.passWord!);
    print(encrypted.base64);


    user.passWord = encrypted.base64;
    print("##############################");

    //user.passWord = result;

    var response;
    try{
      print(user.toJson());
      response = await http.post(url, headers: {"contentType" : "application/json;charset=UTF-8",}, body: user.toJson()).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          return http.Response('Error', 500); // Replace 500 with your http code.
        }
      );
    }on SocketException{
      _showLoginErrDialog(-1);
    }


    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      if(data["err"] == null){
        var result = data["result"];
        if(result["cstCl"] == "WH"){
          writeCstco(result["cstCo"].toString());
          writeStr("cstNa", result["cstNA"].toString());
          writeStr("cstCl", result["cstCl"].toString());
          Navigator.of(context).pushReplacementNamed("/main");
        }else{
          _showCommonDialog(
              commomAlert(
                context:context,
                title:"로그인 에러",
                content:"이 앱은 도매 회원전용입니다.",
                callback:(){_firstTab = true;},
              )
          );
        }
      }else {
        print("10");
        _showCommonDialog(
          commomAlert(
            context:context,
            title:"로그인 에러",
            content:data["err"],
            callback:(){_firstTab = true;},
          )
        );
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      _showLoginErrDialog(response.statusCode);
    }
  }

  void _showLoginErrDialog(int statusCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return commomAlert(
            context:context,
            title:"로그인 에러",
            content:"로그인중 오류가 발생했습니다.\n만약 계속해서 오류가 발생한다면 070-8158-1008에 문의해주세요.\n\n에러코드 : ${statusCode}",
            callback: (){_firstTab = true;},
        );
      },
    );
  }

  void _showCommonDialog(Widget alertWidget){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertWidget;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final Map<String, String?> modalRoute = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    user.token = modalRoute['token'];
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
                  onTap: (){},
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
        //var bytes = utf8.encode("foobar"); // data being hashed
        //var digest = sha256.convert(bytes);
        //encodePublicKeyToPemPKCS1(keyPair.publicKey).
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
            Expanded(
                child:ElevatedButton.icon(
                  icon: Icon(Icons.login), 
                  onPressed: validateAndSave, 
                  label: Text("Login", style: TextStyle(fontSize: 20),),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15), primary: Color(0xff26c998)),
                ),
            ),
            //ElevatedButton(onPressed: (){}, child: Text("regist", style: TextStyle(fontSize: 20),)),
          ],
        )
    );
  }

}

