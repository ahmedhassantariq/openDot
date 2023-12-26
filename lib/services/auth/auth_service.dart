import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';
class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();


  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
    _googleAuthProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    _googleAuthProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLogin' :Timestamp.now(),
      });
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, password) async {
    String fcmToken = "";

    await NotificationServices().getDeviceToken().then((value) => fcmToken = value);
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'userName':"stickOctopus",
        'email': userCredential.user!.email,
        'photoUrl':"https://upload.wikimedia.org/wikipedia/commons/0/0e/Basic_red_dot.png",
        'displayName':"NewUser",
        'phoneNumber':"0123456789",
        'fcmToken': fcmToken,
        'emailVerified':userCredential.user!.emailVerified,
        'isAnonymous':userCredential.user!.isAnonymous,
        'lastLogin': Timestamp.now(),
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithGoogleProvider() async{
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    String fcmToken = "";
    await NotificationServices().getDeviceToken().then((value) => fcmToken = value);
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithPopup(_googleAuthProvider);
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'userName':"stickOctopus",
        'email': userCredential.user!.email,
        'photoUrl':userCredential.user!.photoURL,
        'displayName':userCredential.user!.displayName,
        'phoneNumber':userCredential.user!.phoneNumber,
        'emailVerified':userCredential.user!.emailVerified,
        'fcmToken': fcmToken,
        'isAnonymous':userCredential.user!.isAnonymous,
        'lastLogin': Timestamp.now(),
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGoogleProvider() async{
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithPopup(_googleAuthProvider);
      _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLogin': Timestamp.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  Future<void> signOut () async {
    return await FirebaseAuth.instance.signOut();
  }




}