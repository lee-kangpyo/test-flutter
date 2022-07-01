import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

Future<void> sendAnalyticsEvent(String eventName, Map <String, dynamic> body) async {
  print("##############"+eventName);
  await analytics.logEvent(
    name: eventName,
    parameters: body,
  );
}

Future<void> sendAnalyticsScreen(String screenName) async {
  await analytics.setCurrentScreen(
    screenName: screenName,
    //screenClassOverride: screenClassOverride,
  );
}

Future<String?> getToken() async {
  try {
    // Wait for Firebase to initialize and set `_initialized` state to true
    await Firebase.initializeApp();
    var _firebaseMessaging = FirebaseMessaging.instance;
    String token = (await _firebaseMessaging.getToken())!;
    return token;
  } catch(e) {
    sendAnalyticsEvent("firebase_token_error", {"error":e.toString()});
  }
}


Future<void> initializeFlutterFMC(context) async {
  try {
    // Wait for Firebase to initialize and set `_initialized` state to true
    await Firebase.initializeApp();
    var _firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );



    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      //print("onMessage: $message");
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

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

  } catch(e) {

  }
}
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}


