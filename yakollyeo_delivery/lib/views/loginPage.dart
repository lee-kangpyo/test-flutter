import 'dart:io';

import 'package:flutter/material.dart';
import '../vo/userVo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:yakollyeo_delivery/module/fireBaseAnalytics.dart';
import 'package:yakollyeo_delivery/module/alert.dart';
import 'package:yakollyeo_delivery/module/fileIo.dart';
import 'package:yakollyeo_delivery/module/urlIfo.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:encrypt/encrypt.dart';


final publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkapd53FWX2vpTDeUbo1wZcOMxLMdSXG5Lz1C7MOUyxu34LpSkZxcAkU5Yl73Pm5lB9+rsL+L0mHv0hK5vg6hWsy9bSHBk0FbW15BYtud1mULNzkjF9yYd5NDN6kT+OIybQXvTm/l+mNz/pfwm6QhzujRsTnAE3bBcr87oikdchNQ9ZDCmhwR9sIULEiRMMvU6XsVYg49NuPGQRJuxTIh0QsGyN1NbbNhdwtYvITTzmEcpT/jtpqOC2tock/EoncvUjrMjQ5R+ttjtW4WbFAzQuNgtjrKuzCrVMjVR3hYowrH0O5FwB6DhcDGAlEaZakn4b7vh1mBh3Jungg0hlPqjQIDAQAB";
final _formKey = new GlobalKey<FormState>();

class LoginApp extends StatefulWidget {
  @override
  State createState() => _LoginApp();
}

class _LoginApp extends State<LoginApp> {
  bool isAutoLogin = false;
  var _firstTab = true;
  User user = User();

  @override
  void initState() {
    super.initState();
    sendAnalyticsScreen("loginPage");
  }

  void validateAndSave() {
    if(_firstTab) {
      //_firstTab = false;

      final form = _formKey.currentState;
      if (form!.validate()) {
        print(user.token);
        form.save();
        reqLogin();

      } else {
        print('Form is invalid id: ${user.id}, password: ${user.passWord}, token: ${user.token}');
      }
    }
  }

  void reqLogin() async {
    var url = Uri.http(getHost (), getUrlPath("login"));
    var helper = RsaKeyHelper();
    var pubk = helper.parsePublicKeyFromPem(publicKey);
    final encrypter = Encrypter(RSA(publicKey: pubk));
    final encrypted =  encrypter.encrypt(user.passWord!);
    user.passWord = encrypted.base64;
    var response;
    try{
      analytics.logLogin();
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
          writeStr("userId", result["userId"].toString());
          Navigator.of(context).pushReplacementNamed("/main");
        }else{
          _showCommonDialog(
              commomAlert(
                context:context,
                title:"????????? ??????",
                content:"??? ?????? ?????? ?????????????????????.",
                callback:(){_firstTab = true;},
                btnName: "??????",
              )
          );
        }
      }else {
        print("10");
        _showCommonDialog(
          commomAlert(
            context:context,
            title:"????????? ??????",
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
            title:"????????? ??????",
            content:"???????????? ????????? ??????????????????.\n?????? ???????????? ????????? ??????????????? 070-8158-1008??? ??????????????????.\n\n???????????? : ${statusCode}",
            callback: (){_firstTab = true;},
            btnName: "??????",
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
      decoration: InputDecoration(labelText: '?????????', border: OutlineInputBorder(),),
      validator: (value) => value!.isEmpty? '???????????? ???????????? ????????????.':null,
      onSaved: (value) => user.id = value,
    )
    );
  }

  Widget formPasswordField(){
    return Padding(padding: EdgeInsets.all(10), child:TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: '????????????', border: OutlineInputBorder(),),
      validator: (value) => value!.isEmpty? '??????????????? ???????????? ????????????.':null,
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
        child:Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                    value: isAutoLogin,
                    onChanged: (check){
                      setState(() {
                        isAutoLogin = check!;
                      });
                    }
                ),
                Text("?????? ?????????"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    onPressed: validateAndSave,
                    label: Text("Login", style: TextStyle(fontSize: 20),),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15), primary: Color(0xff26c998)),
                  ),
                ),
                //ElevatedButton(onPressed: (){}, child: Text("regist", style: TextStyle(fontSize: 20),)),
              ],
            ),
          ],
        )
    );
  }

}

