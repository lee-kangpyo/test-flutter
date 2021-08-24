import 'package:flutter/cupertino.dart';
import './isoSub/cupertinoFirstPage.dart';
import './animalItem.dart';


class CupertinoMain extends StatefulWidget{
  @override
  State createState() {
    return _CupertinoMain();
  }
}

class _CupertinoMain extends State<CupertinoMain>{
  late CupertinoTabBar tabBar;
  List<Animal> animalList = [];

  @override
  void initState() {
    super.initState();
    tabBar = CupertinoTabBar(items: [
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.add)),
    ]);

    animalList.add(Animal(animalName: "벌", kind: "곤충", imagePath: "repo/images/bee.png"));
    animalList.add(Animal(animalName: "고양이", kind: "포유류", imagePath: "repo/images/cat.png"));
    animalList.add(Animal(animalName: "그뉵소", kind: "포유류", imagePath: "repo/images/cow.png"));
    animalList.add(Animal(animalName: "강아지", kind: "포유류", imagePath: "repo/images/dog.png"));
    animalList.add(Animal(animalName: "여우", kind: "포유류", imagePath: "repo/images/fox.png"));
    animalList.add(Animal(animalName: "원숭이", kind: "영장류", imagePath: "repo/images/monkey.png"));
    animalList.add(Animal(animalName: "도야지", kind: "포유류", imagePath: "repo/images/pig.png"));
    animalList.add(Animal(animalName: "늑대", kind: "포유류", imagePath: "repo/images/wolf.png"));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoTabScaffold(
        tabBar:tabBar,
        tabBuilder:(context, value){
          if(value == 0){
            return CupertinoFirstPage(animalList: animalList, key: UniqueKey(),);
          }else{
            return Container(
              child: Center(
                child: Text("cupertino tab 2"),
              ),
            );
          }
        },
      ),
    );
  }
}