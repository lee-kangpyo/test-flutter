import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:marquee/marquee.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  _HttpApp createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result='';
  late List data;
  late TextEditingController _txtcontroller;
  int page = 1;
  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    data = [];
    _txtcontroller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange){
        print("bottom");
        page++;
        getJSONData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _txtcontroller,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요'),
        )
      ),
      body: Container(
        child: Center(
          child: data.length == 0 ?
            Text(
              "데이터가 없습니다.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )
            : ListView.builder(
                itemBuilder: (context, index){
                  return Card(
                    child: Container(
                      child: Row(
                        children: [
                          data[index]["thumbnail"] == ""?
                          Container(
                            width: 100,
                            height: 100,
                            //child:Text("X", style: TextStyle (fontSize: 20,), textAlign: TextAlign.center)
                            child: Row(children: [ Text("X", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),], mainAxisAlignment: MainAxisAlignment.center, )
                          )
                          :
                            Image.network(data[index]["thumbnail"], height: 100, width: 100, fit:BoxFit.contain,),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  data[index]["title"].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text("저자 :" + data[index]["authors"].toString()),
                              Text("가격 :" + data[index]["sale_price"].toString()),
                              Text("판매중 :" + data[index]["status"].toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: data.length,
                controller: _scrollController,
            )

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          data.clear();
          page = 1;
          getJSONData();
        },
        child: Icon(Icons.file_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> getJSONData() async {
    print(_txtcontroller.value.text);
    var url = 'https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${_txtcontroller.value.text}';
    var response = await http.get(Uri.parse(url), headers:{"Authorization": "KakaoAK 643407bfb8ee3aae480750d3857ba906"});

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON["documents"];
      data.addAll(result);

    });

    return response.body;
  }
}
