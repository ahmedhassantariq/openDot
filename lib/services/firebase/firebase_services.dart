import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<String> getUrl(String pickedImageName) async {
    final storageReference = FirebaseStorage.instance.ref(
        "images/${pickedImageName}");
    String url = await storageReference.getDownloadURL();
    return url;
  }


  Future<void> cloudMessaging() async {
    final notificationSettings = await FirebaseMessaging.instance.requestPermission();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("TOKEN -> ${fcmToken.toString()}");
  }

  void handMessage(RemoteMessage? message){
    if(message==null){
      return;
    }
  }

  Future initNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handMessage);
  }



}

