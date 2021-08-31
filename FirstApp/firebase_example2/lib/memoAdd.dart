import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoAddPage extends StatefulWidget {
  MemoAddPage(this.reference);

  final DatabaseReference reference;

  @override
  State<MemoAddPage> createState() => _MemoAddPage();
}

class _MemoAddPage extends State<MemoAddPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메모추가"),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextField(controller: titleController,decoration: InputDecoration(labelText: "제목", fillColor: Colors.blueAccent),),
              Expanded(
                child: TextField(
                  controller: contentController,
                  keyboardType: TextInputType.text,
                  maxLines: 100,
                  decoration: InputDecoration(labelText: "내용"),
                ),
              ),
              TextButton(
                onPressed: (){
                  widget.reference.push().set(
                      Memo(titleController.value.text, contentController.value.text, DateTime.now().toIso8601String()).toJson()
                  ).then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Text("저장하기"),
                style: TextButton.styleFrom(shape: StadiumBorder()),
              )
            ],
          ),
        ),
      ),
    );
  }
}