import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/inboxNotificationModel.dart';

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

  Future<String> getTokenFromUser(String userUID) async {
    DocumentSnapshot<Map<String, dynamic>> userCredentials = await _firestore
        .collection('users').doc(userUID).get();
    return userCredentials.get('fcmToken');
  }

  Future<void> deleteInboxNotification(String notificationID) async {
    _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('inbox').doc(notificationID).delete();
  }

  Future<void> sendInboxNotification(List<String> userList, InboxNotificationModel model) async {
    for(int i=0;i < userList.length;i++){
      await _firestore.collection('users').doc(userList[i]).collection('inbox').doc(model.notificationID).set(model.toMap());
    }
  }

  Stream<List<InboxNotificationModel>> getInboxNotifications() {
    Stream<QuerySnapshot> stream = _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('inbox').snapshots();
    Stream<List<InboxNotificationModel>> model = stream.map((event) => event.docs.map((e) =>
        InboxNotificationModel(from: e.get('from'), title: e.get('title'), body: e.get('body'), createdOn: e.get('createdOn'), notificationID: e.get('notificationID'))).toList());
   return model;
  }

  Future<int> getInboxLength() async {
    CollectionReference commentLength = _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection("inbox");
    var snapshot = await commentLength.get();
    return snapshot.size;
  }

  void deleteAllNotifications() {
    _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection('inbox')
        .get()
        .then((res) => {res.docs.forEach((element) => element.reference.delete())
    });
  }

}
