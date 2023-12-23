import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSettings extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void>getPostData() async {
    // print("Generating Response");
    // final String currentUserId = _firebaseAuth.currentUser!.uid;
    // DocumentSnapshot data = await _firestore.collection('reddit').doc(currentUserId).collection('settings').doc('user_profile').get().timeout(Duration(seconds: 10));
    // print(data.get(''));
  }

  Future<void>createPost() async {
    // final String currentUserId = _firebaseAuth.currentUser!.uid;
    try {
      await _firestore
          .collection('reddit').
          doc('posts').collection('user_posts').doc()
          .set(
          {
            "postId":'123',
            "uploadDate":'address',
            "firstName": 'ahmed',
            "lastName": 'tariq',
            "gender":'male',
            "phoneNumber": '123',
            "age": '123'
          });
    } catch(e) {
      print(e);
    }
  }




}
