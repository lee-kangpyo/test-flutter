import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Row(
            children: [
              Expanded(
                child:Container(
                  padding: EdgeInsets.all(5),
                  height: 200,
                  child: GestureDetector(
                    child: Card(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: [
                          Text("기주문", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          Text("배송요청", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                    ),
                    onTap: (){
                      Navigator.of(context).pushNamed("/preOrder");
                    },
                  ),
                ),
              ),
              Expanded(
                child:Container(
                  padding: EdgeInsets.all(5),
                  height: 200,
                  child: GestureDetector(
                    child: Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: [
                          Text("신규", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          Text("배송요청", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                    ),
                    onTap: (){
                        Navigator.of(context).pushNamed("/newOrder");
                      },
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}