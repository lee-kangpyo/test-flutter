import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  WebViewController? controller;
  final homeUrl = "http://www.yakollyeo.com/";

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.orange,
        title: Text("fluuter"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){

                // http://
                // 기본적으로 http를 막고 있다.
                // https://
                // https는 보안이 조금더 좋음


                print("클릭");
                if(controller == null){
                  return;
                }
                controller!.loadUrl(homeUrl);
              },
              icon: Icon(
                  Icons.home
              )
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: WebView(
            onWebViewCreated: (WebViewController controller){
              this.controller = controller;
            },
            initialUrl: homeUrl,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}


