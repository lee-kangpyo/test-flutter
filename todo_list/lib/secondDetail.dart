import 'package:flutter/material.dart';

class SecondDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("second Page"),),
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              )
              ,ElevatedButton(
                  child: Text("저장하기"),
                  onPressed: (){
                    Navigator.of(context).pop(controller.value.text);
                  },
              ),
            ],
          )
        ),
      ),
    );
  }
}
