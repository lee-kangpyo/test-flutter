import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:yakollyeo_delivery/module/fileIo.dart';
import 'package:yakollyeo_delivery/module/urlIfo.dart';


class OrderApp extends StatefulWidget {
  OrderApp(this.mode);
  String mode;
  @override
  State<OrderApp> createState() => _OrderApp(mode);
}

class _OrderApp extends State<OrderApp> {
  _OrderApp(this.mode);
  String mode;                                // preOrder or newOrder
  var modeItemList;                           // initState에서 각각의 모드에따라 사용할 데이터를 저장
  late var modeObj;                           // modeItemList에서 mode에 해당하는 데이터만 뽑아냄
  late Future<Map<String, dynamic>> data;     // 서버에서 가져오는 jsonResponse
  late Future<String?> cstCo;                 // 로그인할때 저장한 cstCo

  @override
  void initState() {
    cstCo = readCstco();
    modeItemList =  {
      "preOrder":{"title":"기주문 배송요청", "build":"", "urlPath":getUrlPath("preOrder")},
      "newOrder":{"title":"신규 배송요청", "build":"", "urlPath":getUrlPath("newOrder")},
    };
    modeObj = modeItemList[mode];
    //data = reqHTTP(modeObj);
  }

  @override
  Widget build(BuildContext context) {
    /*data.then((value){
      print(value["result"][0]["ORDNA"]);
    });*/
    return Scaffold(
      appBar: AppBar(title:Text(modeObj["title"]),),
      body: FutureBuilder(
        future: reqHTTP(modeObj),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if (snapshot.hasData == false) {
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
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          }else {
            var items = snapshot.data["result"];
            bool isBtn = true;
            return ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                var sZip = item["sZipAddr"].split(" ");
                var pZip = item["pZipAddr"].split(" ");
                (sZip[0] == pZip[0]) ? print("") : print(sZip[0]+", "+pZip[0]);
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (sZip[0].trim() == pZip[0].trim()) ? Text("가능") : Text("불가능"),

                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["ORDNA"]),
                            Text("[주문번호 : "+item["ORDNO"].toString()+"]"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(""),
                            Text("출발지 : "+item["sCstNa"] + " " + sZip[0] + " " + sZip[1]),
                            Text("도착지 : "+ item["pCstNa"] + " " + pZip[0] + " " + pZip[1]),
                          ],
                        ),
                      ),
                      (sZip[0].trim() == pZip[0].trim()) ?
                        (isBtn)?
                          ButtonBar(
                            children: [
                              TextButton(
                                onPressed: (){
                                  print(isBtn);
                                  reqShipping(item["ORDNO"].toString());
                                  setState(() {
                                    isBtn = false;
                                  });
                                  print(isBtn);
                                },
                                child: Text("신청하기"),
                                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15), primary: Color(0xff26c998), onPrimary: Colors.white),
                              )
                            ],
                          )
                        :
                        Text("신청 완료")
                      :
                        Text(""),
                    ],
                  )
                );
              },
              separatorBuilder: (BuildContext context, int index) { return Divider(); },
            );
          }

        },
      ),
    );
  }


  void reqShipping(String ordNo) async {
    print(ordNo);
    var url = Uri.http(getHost (), getUrlPath("reqShipping"), {"ordNo":ordNo});
    print(url);
    Future<Map<String, dynamic>> response = reqCommonHTTP(url);

    response.then((value) => {
      print(value)
    });

  }

  Future<Map<String, dynamic>> reqHTTP(modeObj) async {
    return await cstCo.then((value) async {
      var url = Uri.http(getHost (), modeObj["urlPath"], {"cstCo":value});
      return reqCommonHTTP(url);
    }).catchError((error) {
      print('에러발생');
      dynamic code = "-10";
      return Map<String, dynamic>().putIfAbsent("err", code);
    });
  }

  Future<Map<String, dynamic>> reqCommonHTTP(url) async {
    var response;
    try{
      response = await http.get(url);
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