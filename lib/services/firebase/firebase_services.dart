import 'dart:async';
import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/pages/webRTC.dart';

class FirebaseServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<String> getUrl(String pickedImageName) async {
    final storageReference = FirebaseStorage.instance.ref(
        "images/${pickedImageName}");
    String url = await storageReference.getDownloadURL();
    return url;
  }


  Future<String> getFcmToken() async {
    final notificationSettings = await FirebaseMessaging.instance.requestPermission();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken.toString();
  }

  void handMessage(RemoteMessage? message) async{
    if(message==null){
      return;
    }
    print(message.notification!.title);
    print(message.notification!.body);
    print(message.data['keyValue']);
    print("----------------------------------------");
  }



  Future initNotifications(BuildContext context) async {
    FirebaseMessaging.instance.setDeliveryMetricsExportToBigQuery(true);
    // FirebaseMessaging.instance.getInitialMessage().then(handMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handMessage);

  }



}
