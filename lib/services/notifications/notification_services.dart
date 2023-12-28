import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reddit_app/models/notificationsModel.dart';
import 'package:reddit_app/pages/chat/chatRoom.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_app/services/notifications/notificationContents.dart';
import 'package:reddit_app/services/notifications/notificationsController.dart';
import 'package:reddit_app/services/posts/post_services.dart';
class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
  final NotificationContents notificationContents = NotificationContents();
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");

    } else {
      print("User denied permission");
    }
  }

  void initAwesomeNotifications() async{
    _awesomeNotifications.initialize(null, [
      NotificationChannel(
          channelKey: 'channel',
          channelName: 'channel of calling',
          channelDescription: 'channel description',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      ),
    ]);


  }

  void handleAwesomeBackgroundNotifications(RemoteMessage message) async {
    initAwesomeNotifications();
    if(message.data['type'] == 'chat'){
      _awesomeNotifications.createNotification(content: notificationContents.messageNotification(message),);
    }
  }
  
  void handleAwesomeNotification(BuildContext context, RemoteMessage message) async{
    initAwesomeNotifications();
    _awesomeNotifications.setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        NotificationController.onActionReceivedMethod(context, receivedAction, message);
      },
      onNotificationCreatedMethod: (ReceivedNotification receivedNotification) async {
        NotificationController.onNotificationCreatedMethod(context, receivedNotification);
      },
      onNotificationDisplayedMethod: (ReceivedNotification receivedNotification) async {
        NotificationController.onNotificationDisplayedMethod(context, receivedNotification);
      },
      onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
        NotificationController.onDismissActionReceivedMethod(context, receivedAction, message);
      },
    );
    if(message.data['type'] == 'chat'){
      _awesomeNotifications.createNotification(content: notificationContents.messageNotification(message),);
    }
    if(message.data['type'] == 'call'){
      _awesomeNotifications.createNotification(content: notificationContents.callNotification(message),
        actionButtons: [
          NotificationActionButton(key: 'accept', label: 'Accept'),
          NotificationActionButton(key: 'dismiss', label: 'Dismiss'),
        ]
      );
    }

  }


  void initLocalNotifications(BuildContext context, RemoteMessage message){
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitialization,
        iOS: iosInitialization
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (payload){
      handleMessage(context, message);
    }
    );


  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if(defaultTargetPlatform == TargetPlatform.android){
        // initLocalNotifications(context, message);
        // showNotifications(message);
        handleAwesomeNotification(context, message);
      } else if(kIsWeb) {
        showWebNotifications(context,message);
      }
    });
  }

  Future<void> showWebNotifications(BuildContext context,RemoteMessage message) async{
    NotificationController().webNotificationMethod(context, message);
  }
  Future<void> showNotifications(RemoteMessage message) async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
      importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    String? fcmToken = await messaging.getToken();
    FirebaseServices().saveDeviceToken(fcmToken.toString());
    return fcmToken.toString();
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      FirebaseServices().saveDeviceToken(event.toString());
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async{
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage!=null){
      // handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // handleMessage(context, message);
      handleAwesomeNotification(context, message);
    });

  }

  Future<void> handleMessage(BuildContext context, RemoteMessage message) async {
    if(message.data['type']=='chat'){
            Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => FutureBuilder(
            future: PostServices().getUser(message.data['sender'].toString()),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Text("Loading");
              }
              if(snapshot.hasError){
                return const Text("Error Loading Message");
              }
              return ChatRoom(receiver: snapshot.requireData);
            },)));
    }
  }

  void sendNotification(NotificationsModel notification) async {
    FirebaseServices().getTokenFromUser(notification.to).then((fcmToken) async{
      print(fcmToken.toString());
  var data =
  {
    'to' : fcmToken.toString(),
    'priority': notification.priority,
    'notification':
    {
      'title': notification.title,
      'body': notification.body,
    },
    'data' :
    {
      'type': notification.type,
      'id': notification.id,
      'sender': FirebaseAuth.instance.currentUser!.uid,
      'payload': notification.payload
    }
  };
  await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
  body: jsonEncode(data),
  headers: {
  'Content-Type' : 'application/json',
  'Authorization' :'Key=AAAAX29LRcw:APA91bHMZGtk79tLwypFQmtKdaiwB2wHz-V7CDpO5lkbnzX1Zgnuc05gHBXGuA3267PKvx-2eFRdoIRcTj9kMEA6hzH8_yTeTPMyED8H376K0fOmO0pQy7VEK2Us1RM_CzNbXcmNXunl'
  });});
  }




}