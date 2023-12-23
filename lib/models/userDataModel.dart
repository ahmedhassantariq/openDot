import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredentialsModel {
  final String uid;
  final String displayName;
  final String userName;
  final String email;
  final String phoneNumber;
  final bool emailVerified;
  final bool isAnonymous;
  final String imageUrl;
  final Timestamp lastLogin;

  const UserCredentialsModel({
    required this.uid,
    required this.displayName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.emailVerified,
    required this.isAnonymous,
    required this.imageUrl,
    required this.lastLogin
});

  factory UserCredentialsModel.fromMap(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    return(UserCredentialsModel(
        displayName: documentSnapshot.get('displayName'),
        email: documentSnapshot.get('email'),
        emailVerified: documentSnapshot.get('emailVerified'),
        isAnonymous: documentSnapshot.get('isAnonymous'),
        lastLogin: documentSnapshot.get('lastLogin'),
        phoneNumber: documentSnapshot.get('phoneNumber'),
        imageUrl: documentSnapshot.get('photoUrl'),
        uid: documentSnapshot.get('uid'),
        userName: documentSnapshot.get('userName')));
  }
}