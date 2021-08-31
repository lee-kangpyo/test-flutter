import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoDetailPage extends StatefulWidget {
  MemoDetailPage(this.reference, this.memo);

  final DatabaseReference reference;
  final Memo memo;

  @override
  State createState() => _MemoDetailPage();
}

class _MemoDetailPage extends State<MemoDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.memo.title);
    contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.memo.title),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "제목", fillColor: Colors.blueAccent),),
              TextField(controller: contentController, decoration: InputDecoration(labelText: "내용"),),
              TextButton(
                onPressed: (){
                  Memo memo = Memo(titleController.value.text, contentController.value.text, widget.memo.createTime);
                  widget.reference.child(widget.memo.key!).set(memo.toJson()).then((_)=> Navigator.of(context).pop(memo));
                },
                child: Text("수정하기"),
                style: TextButton.styleFrom(shape: StadiumBorder()),
              ),

            ],
          ),
        ),
      ),
    );
  }


}