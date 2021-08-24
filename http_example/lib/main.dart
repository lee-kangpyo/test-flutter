import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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


  @override
  void initState() {
    super.initState();
    data = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Http Example"),
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
                      child: Column(
                        children: [
                          Text(data[index]["title"].toString()),
                          Text(data[index]["authors"].toString()),
                          Text(data[index]["sale_price"].toString()),
                          Text(data[index]["status"].toString()),
                          Image.network(data[index]["thumbnail"], height: 100, width: 100, fit:BoxFit.contain,),

                        ],

                      ),

                    ),
                  );
                },
                itemCount: data.length,
            )

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getJSONData();
        },
        child: Icon(Icons.file_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> getJSONData() async {
    var url = 'https://dapi.kakao.com/v3/search/book?target=title&query=파이썬';
    var response = await http.get(Uri.parse(url), headers:{"Authorization": "KakaoAK 643407bfb8ee3aae480750d3857ba906"});

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON["documents"];
      data.addAll(result);
    });
    print(data);
    return response.body;
  }
}
