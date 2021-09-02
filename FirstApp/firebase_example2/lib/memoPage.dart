import 'package:firebase_example2/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';


class MemoPage extends StatefulWidget {
  @override
  State<MemoPage> createState() => _MemoPage();

}

class _MemoPage extends State<MemoPage> {
  late FirebaseDatabase _database;
  late DatabaseReference reference;
  String _databaseUrl = "https://yakollyeo-default-rtdb.firebaseio.com/";
  List<Memo> memos= [];


  late FirebaseMessaging _firebaseMessaging;

  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      _firebaseMessaging = FirebaseMessaging.instance;
      _database = FirebaseDatabase(databaseURL: _databaseUrl);
      reference = _database.reference().child('memo');

      reference.onChildAdded.listen((event) {
        print(event.snapshot.value.toString());
        setState(() {
          memos.add(Memo.fromSnapshot(event.snapshot));
        });
      });
      print("##################################################");
      String? token = await _firebaseMessaging.getToken();
      print(token);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        print("onMessage: $message");
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(notification.title!),
                subtitle: Text(notification.body!),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('ok')
                ),
              ],
            )
        );

      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("onMessageOpenedApp: $message");
      });


      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }


  @override
  void initState() {
    initializeFlutterFire();
    super.initState();

/*
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
      print("onBackgroundMessage: $message!");
    });

 */
    /*
    _firebaseMessaging.configure(
      onMessage:(Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ok')
                ),
              ],
            )
        );
      },
      onLaunch:(Map<String, dynamic> message) async {},
      onResume:(Map<String, dynamic> message) async {},
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메모앱"),),
      body: Container(
        child: Center(
          child: memos.length == 0
          ?CircularProgressIndicator()
          :GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index){
                return Card(
                  child: GridTile(
                    child: Container(
                      padding: EdgeInsets.only(top:20, bottom: 20),
                      child: SizedBox(
                        child: GestureDetector(
                          onTap: () async {
                            Memo memo = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemoDetailPage(reference, memos[index]) ));
                            if(memo != null){
                              setState(() {
                                memos[index].title = memo.title;
                                memos[index].content = memo.content;
                              });
                            }
                          },
                          onLongPress: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(memos[index].title),
                                  content: Text("삭제하시겠습니까?"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        reference.child(memos[index].key!).remove()
                                          .then((_){
                                            setState(() {
                                              memos.removeAt(index);
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        );
                                      },
                                      child: Text("예"),
                                    ),
                                    TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("아니오")),
                                  ],
                                );
                              }
                            );
                          },
                          child: Text(memos[index].content),
                        ),
                      ),
                    ),
                    header: Text(memos[index].title),
                    footer: Text(memos[index].createTime.substring(0,10)),
                  ),
                );
              },
            itemCount: memos.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MemoAddPage(reference)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
