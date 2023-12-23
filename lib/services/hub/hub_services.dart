import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:reddit_app/models/userDataModel.dart';

class HubServices extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getHubs() {
    return _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection("joinedHubs")
        .snapshots();
  }

  Stream<QuerySnapshot> getUserHubs() {
    return _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection("userHubs")
        .snapshots();
  }

  Future<void> createHub(String hubTitle,bool isPublic) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String docID = _firestore.collection('users').doc(currentUserId).collection("userHubs").doc().id;
     _firestore.collection("users").doc(currentUserId).collection("userHubs").doc(docID).set({
      "hubID":docID,
      "createdBy":currentUserId,
      "createdOn":Timestamp.now(),
      "hubTitle":hubTitle,
      "isPublic":isPublic
    });
    notifyListeners();
  }


}