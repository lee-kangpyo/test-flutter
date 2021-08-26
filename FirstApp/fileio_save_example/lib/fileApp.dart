import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FileApp extends StatefulWidget{

  @override
  State<FileApp> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  int _count = 0;
  List<String> itemList = [];
  late TextEditingController txtController;

  @override
  void initState() {
    super.initState();
    readCountFile();
    initData();
  }

  void initData() async {
    txtController = TextEditingController();
    var result = await readListFile();
    setState(() {
      itemList.addAll(result);
    });
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Example")),
      body: Container(
        child: Center(
          child: Text('$_count', style: TextStyle(fontSize: 40),),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            _count++;
          });
          writeCountFile(_count);
        },
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Example")),
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: txtController,
                keyboardType: TextInputType.text,
              ),
              Expanded(
                child:ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(
                        child: Text(itemList[index], style: TextStyle(fontSize: 30),),
                      ),
                    );
                  },
                  itemCount: itemList.length,
                ),
              ),
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          writeFruit(txtController.value.text);
          setState(() {
            itemList.add(txtController.value.text);
          });
        },
      ),

    );
  }

  void writeFruit(String fruit) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File(dir.path + "/fruit.txt").readAsStringSync();
    file = file + '\n' + fruit;
    File(dir.path + '/fruit.txt').writeAsStringSync(file);
  }


  Future<List<String>> readListFile() async {
    var key = 'first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstCheck = pref.getBool(key);

    var dir = await getApplicationDocumentsDirectory();
    bool fileExists = await File(dir.path+"/fruit.txt").exists();

    if(firstCheck == null || firstCheck == false || fileExists == false){
      pref.setBool(key, true);
      var file = await DefaultAssetBundle.of(context).loadString("repo/fruit.txt");
      File(dir.path + '/fruit.txt').writeAsStringSync(file);
      return getItemList(file);
    }else{
      var file = await File(dir.path + "/fruit.txt").readAsStringSync();
      return getItemList(file);
    }
  }

  List<String> getItemList(var file){
    List<String> itemList = [];
    var array = file.split("\n");
    for(var item in array){
      print(item);
      itemList.add(item);
    }
    return itemList;
  }

  // 파일 읽어오기
  void writeCountFile(int count) async{
    var dir = await getApplicationDocumentsDirectory();
    File(dir.path + '/count.txt').writeAsStringSync(count.toString());
  }
  // 파일 쓰기
  void readCountFile() async{
    try {
      var dir = await getApplicationDocumentsDirectory();
      var file = await File(dir.path + '/count.txt').readAsString();
      print(file);
      setState(() {
        _count = int.parse(file);
      });
    }catch (e) {
      print(e.toString());
    }
  }


}
