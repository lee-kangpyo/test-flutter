import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yakollyeo_delivery/module/fireBaseAnalytics.dart';
import 'package:yakollyeo_delivery/module/fileIo.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class MainApp extends StatefulWidget {
  @override
  State createState() => _MainApp();
}


class _MainApp extends State<MainApp> {
  Future<String?> userId = readStr("userId");

  MainApp(){
    this.userId.then((value)=>{
      sendAnalyticsEvent("login_complete", {"id":value}),
    });
  }


  @override
  void initState() {
    super.initState();
    initializeFlutterFMC(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                child: GestureDetector(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text("기주문 배송요청", style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold , color: Colors.black87), textAlign: TextAlign.center,),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xffF3F0D7),
                            border: Border.all(color: Color(0xff5E454B)),
                            shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black87,
                                    blurRadius: 5,
                                    offset: Offset(5, 5)
                                ),
                              ]
                          ),
                          child: Hero(tag: "preOrder", child: Image.asset("repo/images/pre_order.png", width: 120,)),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ),
                  onTap: (){
                    Navigator.of(context).pushNamed("/preOrder");
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Divider( color:  Color(0xff9D9D9D), thickness: 1,),
              ),
              Container(
                height: 300,
                width: 300,
                child: GestureDetector(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text("신규 배송요청", style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center,),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xffF7D59C),
                            border: Border.all(color: Color(0xff5E454B)),
                            shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black87,
                                    blurRadius: 5,
                                    offset: Offset(5, 5)
                                ),
                              ]
                          ),
                          child: Hero(tag: "newOrder", child: Image.asset("repo/images/new_order.png", width: 120,)),
                        )

                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ),
                  onTap: (){
                      Navigator.of(context).pushNamed("/newOrder");
                    },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}