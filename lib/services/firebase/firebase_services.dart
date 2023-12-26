import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../notifications/notification_services.dart';

class FirebaseServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<String> getUrl(String pickedImageName) async {
    final storageReference = FirebaseStorage.instance.ref(
        "images/${pickedImageName}");
    String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<void> saveDeviceToken(String fcmToken) async {
    try{
      _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
        'fcmToken': fcmToken,
      });
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

}
