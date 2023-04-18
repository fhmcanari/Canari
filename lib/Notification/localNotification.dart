import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize(BuildContext context){
    final InitializationSettings initializationSettings = InitializationSettings(android:AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      // onSelectNotification: (String rout)async{
      //  if (rout!=null) {
      //    navigateTo(context, NotificationScreen());
      //  }
      // }
    );
  }
  static void display(RemoteMessage message)async{
    try{
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "canari",
            "canari channel",
            "this is our channel",
            importance: Importance.max,
            priority: Priority.high,
            color: Colors.red,
          )
      );
      await  _flutterLocalNotificationsPlugin.show(
        1,
        message.notification.title,
        message.notification.body,
        notificationDetails,
      );
    } on Exception catch (e){
      print(e.toString());
    }
  }
}