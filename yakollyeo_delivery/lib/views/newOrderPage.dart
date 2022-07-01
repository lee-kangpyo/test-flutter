import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:yakollyeo_delivery/module/fireBaseAnalytics.dart';
import 'package:yakollyeo_delivery/module/fileIo.dart';
import 'package:yakollyeo_delivery/module/urlIfo.dart' as path;
import 'package:yakollyeo_delivery/module/alert.dart';
import 'package:yakollyeo_delivery/vo/orderVo.dart';
import 'package:kpostal/kpostal.dart';


class NewOrderApp extends StatefulWidget {
  @override
  State<NewOrderApp> createState() => _NewOrderApp();
}

class _NewOrderApp extends State<NewOrderApp> {
  final _formKey = new GlobalKey<FormState>(); // 신규 배송 주문시 사용할 폼키
  late var NAMESPACE;                           // modeItemList에서 mode에 해당하는 데이터만 뽑아냄
  late Future<Map<String, dynamic>> _data;     // 서버에서 가져오는 jsonResponse
  late Future<String?> cstCo;                 // 로그인할때 저장한 cstCo
  late Future<String?> userId;                // 로그인할때 저장한 userId
  bool isSuccess = false;
  Order order = Order();

  TextEditingController sCstNaController = TextEditingController();
  TextEditingController sMngNaController = TextEditingController();
  TextEditingController sMngHpNoController = TextEditingController();
  TextEditingController sZipAddrController = TextEditingController();
  TextEditingController sAddrController = TextEditingController();
  TextEditingController sZipNoController = TextEditingController();
  TextEditingController pCstNaController = TextEditingController();
  TextEditingController pMngNaController = TextEditingController();
  TextEditingController pMngHpNoController = TextEditingController();
  TextEditingController pZipAddrController = TextEditingController();
  TextEditingController pAddrController = TextEditingController();
  TextEditingController pZipNoController = TextEditingController();

  late FocusNode sAddrFocus;
  late FocusNode pAddrFocus;

  var senderInfo;

  @override
  void initState() {
    super.initState();
    sendAnalyticsScreen("newOrderPage");
    cstCo = readCstco();
    userId = readStr("userId");
    NAMESPACE = {"title":"신규 배송요청", "build":"", "newOrder":path.getUrlPath("newOrder") , "fnc":fncNewOrder, "backColor": Color(0xffF7D59C)};

    _data = reqHTTP(NAMESPACE);
    _data.then((data)=>{
      senderInfo = data["result"],
      sCstNaController.text = senderInfo["sCstNa"],
      sMngNaController.text = senderInfo["sMngNa"],
      sMngHpNoController.text = senderInfo["sMngHpNo"],
      sZipAddrController.text = senderInfo["sZipAddr"],
      sAddrController.text = senderInfo["sAddr"],
      sZipNoController.text = senderInfo["sZipNo"],
      setState(() {isSuccess = true;}),
    });

    sAddrFocus = FocusNode();
    pAddrFocus = FocusNode();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Text(NAMESPACE["title"]),
                  Hero(tag: "newOrder", child: Image.asset("repo/images/new_order.png", width: 30,)),
                ],
              ),
            ),
          ],),
        actions: [
          IconButton(
            icon: Text("전송"),
            onPressed: validateAndSubmit,
          ),
        ],
      ),

      body: (isSuccess) ? fncNewOrder():fncWait(),
    );
  }

  void validateAndSubmit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      userId.then((value){
        order.userId = value;
        Future<Map<String, dynamic>> result = reqSave();
        result.then((data){
          if(data["result"] > 0){
            _showCommonDialog(
                commomAlert(
                  context:context,
                  title:"신규 배송요청 성공",
                  content:"신규 배송요청이 성공하였습니다.",
                  btnName: "닫기",
                  callback: (){Navigator.of(context).pop();},
                )
            );
          }
        });
      });
    } else {
      _showCommonDialog(
          commomAlert(
            context:context,
            title:"공백을 채워주세요",
            content:"빨강색으로 강조된 입력 박스를 모두 채운 후 다시 시도해 주세요",
            btnName: "닫기",)
      );
    }
  }

  Widget fncWait(){
    return Container(
        child: Center(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            )
        )
    );
  }

  Widget fncNewOrder(){
    return Container(
        child: Center(
          child:Form(
            key: _formKey,
            child: Padding(padding: EdgeInsets.all(10),
              child:SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    sellerWidget(),
                    Divider(),
                    purchaseWidget(),
                  ],
                ),
              )
            ),
          )
        )
    );
  }

  Future<Widget> callKaKaoAddress(String flag) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          useLocalServer: false,
          localPort: 1024,
          // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
          callback: (Kpostal result) {
            print(result);
            setState(() {
              if(flag == "seller"){
                sZipNoController.text = result.postCode;
                sZipAddrController.text = result.address;
                sAddrController.text = "";
                sAddrFocus.requestFocus();
              }else if(flag == "purchase"){
                pZipNoController.text = result.postCode;
                pZipAddrController.text = result.address;
                pAddrController.text = "";
                pAddrFocus.requestFocus();
              }

            });
          },
        ),
      ),
    );
  }

  Widget sellerWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("출발지 정보", style: TextStyle(fontSize: 20,),)),
                  TextButton(
                    onPressed: (){callKaKaoAddress("seller");},
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                    child: Text(
                      '주소 조회',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: (){callKaKaoAddress("seller");},
                child: TextFormField(
                  enabled: false,
                  controller: sZipAddrController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: '주소', border: OutlineInputBorder(),),
                  validator: (value) => value!.isEmpty? '주소는 공백일수 없습니다.':null,
                  onSaved: (value) => {order.sZipAddr = value},
                  onChanged: (value){textLenvalidate(sZipAddrController, value, 500);},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller:sAddrController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: '상세 주소', border: OutlineInputBorder(),),
                validator: (value) => value!.isEmpty? '상세 주소는 공백일수 없습니다.':null,
                onSaved: (value) => {order.sAddr = value},
                onChanged: (value){textLenvalidate(sAddrController, value, 500);},
                focusNode: sAddrFocus,

              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: sCstNaController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: '상호명', border: OutlineInputBorder(),),
                      validator: (value) => value!.isEmpty? '상호명는 공백일수 없습니다.':null,
                      onSaved: (value) => {order.sCstNa = value},
                      onChanged: (value){textLenvalidate(sCstNaController, value, 20);},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: (){callKaKaoAddress("seller");},
                      child: TextFormField(
                        enabled: false,
                        controller: sZipNoController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: '우편번호', border: OutlineInputBorder(),),
                        validator: (value) => value!.isEmpty? '우편번호는 공백일수 없습니다.':null,
                        onSaved: (value) => {order.sZipNo = value},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: sMngNaController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: '이름', border: OutlineInputBorder(),),
                      validator: (value) => value!.isEmpty? '이름은 공백일수 없습니다.':null,
                      onSaved: (value) => {order.sMngNa = value},
                      onChanged: (value){textLenvalidate(sMngNaController, value, 10);},
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        controller: sMngHpNoController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: '연락처', border: OutlineInputBorder(),),
                        validator: (value) => value!.isEmpty? '연락처는 공백일수 없습니다.':null,
                        onSaved: (value) => {order.sMngHpNo = value},
                        keyboardType: TextInputType.number,
                        onChanged: (value){textLenvalidate(sMngHpNoController, value, 11);},
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget purchaseWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("도착지 정보", style: TextStyle(fontSize: 20,),)),
                  TextButton(
                    onPressed: (){callKaKaoAddress("purchase");},
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                    child: Text(
                      '주소 조회',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: (){callKaKaoAddress("purchase");},
                child: TextFormField(
                  enabled: false,
                  controller: pZipAddrController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: '주소', border: OutlineInputBorder(),),
                  validator: (value) => value!.isEmpty? '주소는 공백일수 없습니다.':null,
                  onSaved: (value) => {order.pZipAddr = value},
                  onChanged: (value){textLenvalidate(pZipAddrController, value, 500);},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: pAddrController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: '상세 주소', border: OutlineInputBorder(),),
                validator: (value) => value!.isEmpty? '상세 주소는 공백일수 없습니다.':null,
                onSaved: (value) => {order.pAddr = value},
                onChanged: (value){textLenvalidate(pAddrController, value, 500);},
                focusNode: pAddrFocus,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: pCstNaController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: '상호명', border: OutlineInputBorder(),),
                      validator: (value) => value!.isEmpty? '상호명는 공백일수 없습니다.':null,
                      onSaved: (value) => {order.pCstNa = value},
                      onChanged: (value){textLenvalidate(pMngNaController, value, 20);},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: (){callKaKaoAddress("purchase");},
                      child: TextFormField(
                        enabled: false,
                        controller: pZipNoController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: '우편번호', border: OutlineInputBorder(),),
                        validator: (value) => value!.isEmpty? '우편번호 공백일수 없습니다.':null,
                        onSaved: (value) => {order.pZipNo = value},
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      controller: pMngNaController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: '이름', border: OutlineInputBorder(),),
                      validator: (value) => value!.isEmpty? '이름은 공백일수 없습니다.':null,
                      onSaved: (value) => {order.pMngNa = value},
                      onChanged: (value){textLenvalidate(pMngNaController, value, 10);},
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        controller: pMngHpNoController,
                        decoration: InputDecoration(labelText: '연락처', border: OutlineInputBorder(),),
                        validator: (value) => value!.isEmpty? '연락처는 공백일수 없습니다.':null,
                        onSaved: (value) => {order.pMngHpNo = value},
                        keyboardType: TextInputType.number,
                        onChanged: (value){textLenvalidate(pMngHpNoController, value, 11);},
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void textLenvalidate(controller, value, len){
    if(value.length > len){
      controller.text = value.substring(0, len);
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    }
  }

  void _showCommonDialog(Widget alertWidget){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertWidget;
      },
    );
  }

  Future<Map<String, dynamic>> reqHTTP(modeObj) async {
    print("call reqHTTP()");
    return await cstCo.then((value) async {
      var url = Uri.http(path.getHost(), modeObj["newOrder"], {"cstCo":value});
      return reqCommonHTTP(url, "get");
    }).catchError((error) {
      print('에러발생');
      dynamic code = "-10";
      return Map<String, dynamic>().putIfAbsent("err", code);
    });
  }

  Future<Map<String, dynamic>> reqSave() async {
    print("call reqSave()");
    var url = Uri.http(path.getHost(), path.getUrlPath("reqShipping"), order.toJson());
    return reqCommonHTTP(url, "post");
  }

  Future<Map<String, dynamic>> reqCommonHTTP(url, method) async {
    var response;
    try{
      if(method == "get"){
        print("겟전송");
        response = await http.get(url);
      }else if(method == "post"){
        print("포스트전송");
        response = await http.post(url);
      }
    }on SocketException{
      return Map<String, dynamic>().putIfAbsent("err", "-5" as dynamic);
    }
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return Map<String, dynamic>().putIfAbsent("err", response.statusCode);
    }
  }
}