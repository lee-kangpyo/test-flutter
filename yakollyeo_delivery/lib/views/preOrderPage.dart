import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:yakollyeo_delivery/module/fireBaseAnalytics.dart';
import 'package:yakollyeo_delivery/module/fileIo.dart';
import 'package:yakollyeo_delivery/module/urlIfo.dart';
import 'package:yakollyeo_delivery/module/alert.dart';
import 'package:yakollyeo_delivery/vo/orderVo.dart';


class PreOrderApp extends StatefulWidget {
  @override
  State<PreOrderApp> createState() => _PreOrderApp();
}

class _PreOrderApp extends State<PreOrderApp> {

  late var NAMESPACE;                           // modeItemList에서 mode에 해당하는 데이터만 뽑아냄
  late Future<Map<String, dynamic>> _data;     // 서버에서 가져오는 jsonResponse
  late Future<String?> cstCo;                 // 로그인할때 저장한 cstCo
  late Future<String?> userId;                // 로그인할때 저장한 userId
  var items;


  @override
  void initState() {
    super.initState();
    sendAnalyticsScreen("preOrderPage");
    cstCo = readCstco();
    userId = readStr("userId");
    NAMESPACE = {"title":"기주문 배송요청", "build":"", "urlPath":getUrlPath("preOrder"), "backColor": Color(0xffF3F0D7)};
    _data = reqHTTP(NAMESPACE);
  }

  @override
  Widget build(BuildContext context) {
    return fncPreOrder();
  }

  Widget fncPreOrder() {
    return Scaffold(
      appBar: AppBar(
          title:Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(NAMESPACE["title"]),
              ),
              Hero(tag: "preOrder", child: Image.asset("repo/images/pre_order.png", width: 30,)),
            ],
          ), backgroundColor: NAMESPACE["backColor"], foregroundColor: Colors.black87
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: _data,
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
              items = snapshot.data["result"];
              bool isBtn = true;
              int len = items.length;
              return len > 0 ?
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Colors.amber,
                      child: Center(
                          child:
                          Text("주문접수 상태의 주문만 조회됩니다.\n현재 특별/광역시 내에서만 서비스 가능합니다.")
                      )
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(10),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          var sZip = item["sZipAddr"].split(" ");
                          var pZip = item["pZipAddr"].split(" ");
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [Text("[주문번호 : "+item["ORDNO"].toString()+"] ", ),
                                        (sZip[0].trim() == pZip[0].trim()) ? Text("신청 가능", style: TextStyle(color: Colors.blueAccent),) : Text("신청 불가능", style: TextStyle(color: Colors.red),),],
                                      ),
                                      Text(item["ORDNA"]),
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
                                //출발지와 도착지의 시가 같으면 ex) 서울시 = 서울시
                                (sZip[0].trim() == pZip[0].trim()) ?
                                  // 버튼 클릭 여부
                                  (item["isReq"] == "N")?
                                    ButtonBar(
                                      children: [
                                        TextButton(
                                          onPressed: (){
                                            userId.then((value)=>{
                                              _showCommonDialog(
                                                commomConfirm(
                                                    context: context,
                                                    title: "배송 요청 하시겠습니까?",
                                                    content: "${item["ORDNA"]}",
                                                    callback: (){
                                                      reqShipping(Order(ordNo: item["ORDNO"].toString(), sCstNa: item["sCstNa"], sMngNa: item["sMngNa"], sMngHpNo: item["sMngHpNo"], sZipAddr: item["sZipAddr"], sAddr: item["sAddr"], sZipNo: item["sZipNo"], pCstNa: item["pCstNa"], pMngNa: item["pMngNa"], pMngHpNo: item["pMngHpNo"], pZipAddr: item["pZipAddr"], pAddr: item["pAddr"], pZipNo: item["pZipNo"], userId: value));
                                                    },
                                                )
                                              ),
                                            });
                                          },
                                          child: Text("배송요청"),
                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10), primary: Color(0xff26c998), onPrimary: Colors.white),
                                        )
                                      ],
                                    )
                                  :
                                  ButtonBar(
                                    children: [
                                      TextButton(
                                        onPressed: (){
                                          _showCommonDialog(
                                            commomAlert(context: context, title: "신청 완료", content: "이미 신청 하셨습니다.", btnName: "닫기")
                                          );
                                        },
                                        child: Text("신청 완료"),
                                        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10), primary: Colors.grey, onPrimary: Colors.white),
                                      )
                                    ],
                                  )
                                :
                                  Text(""),
                              ],
                            )
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) { return Divider(); },
                      ),
                    ),
                  ],
                )
              :
              LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minHeight:constraint.maxHeight),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("조회 결과가 없습니다."),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
          },
        ),
      ),
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

  Future _refreshData() async {
    print("call _refreshData()");
    setState(() {
      _data = reqHTTP(NAMESPACE);
    });

  }

  void reqShipping(Order ord) async {
    var url = Uri.http(getHost (), getUrlPath("reqShipping"), ord.toJson());
    Future<Map<String, dynamic>> response = reqCommonHTTP(url);
    response.then((value) => {
      print(value),
      _refreshData(),
    });

  }

  Future<Map<String, dynamic>> reqHTTP(NP) async {
    print("call reqHTTP()");
    return await cstCo.then((value) async {
      var url = Uri.http(getHost (), NP["urlPath"], {"cstCo":value});
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