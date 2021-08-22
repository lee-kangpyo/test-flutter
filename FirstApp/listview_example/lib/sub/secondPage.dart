import 'package:flutter/material.dart';
import '../animalItem.dart';

class SecondApp extends StatefulWidget{
  final List<Animal> list;
  SecondApp({required Key key, required this.list}) : super(key: key);
  @override
  State createState() => _SecondApp();
  /*
  @override
  State createState() {
    return _SecondApp();
  }
  */

}

class _SecondApp extends State<SecondApp> {
  final nameController = TextEditingController();
  int _radioValue = 0;
  bool flyExist = false;
  var _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Radio(value: 0, groupValue: _radioValue, onChanged:_radioChange),
                  Text("양서류"),
                  Radio(value: 1, groupValue: _radioValue, onChanged:_radioChange),
                  Text("파충류"),
                  Radio(value: 2, groupValue: _radioValue, onChanged:_radioChange),
                  Text("포유류")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("날수 있나요?"),
                  Checkbox(value: flyExist,
                    onChanged: (check){
                      setState(() {
                        flyExist = check!;
                      });
                    }
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Image.asset("repo/images/cow.png", width: 80,),
                    onTap: (){
                      _imagePath = "repo/images/cow.png";
                    },
                  ),
                  GestureDetector(
                    child:Image.asset("repo/images/pig.png", width: 80,),
                    onTap: (){
                      _imagePath = "repo/images/pig.png";
                    },
                  ),
                  GestureDetector(
                    child:Image.asset("repo/images/bee.png", width:80,),
                    onTap: (){
                      _imagePath = "repo/images/bee.png";
                    },
                  ),
                  GestureDetector(
                    child: Image.asset("repo/images/cat.png", width:80,),
                    onTap: (){
                      _imagePath = "repo/images/cat.png";
                    },
                  ),
                  GestureDetector(
                    child: Image.asset("repo/images/dog.png", width: 80,),
                    onTap: (){
                      _imagePath = "repo/images/dog.png";
                    },
                  ),

                ],
              ),
              ElevatedButton(onPressed: (){}, child: Text("동물 추가하기"))
            ],
          ),
        ),
      ),
    );
  }
  _radioChange(int? value){
    setState(() {
      _radioValue = value!;
      print(_radioValue);
    });
  }
}