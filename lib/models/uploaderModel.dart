import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UploaderModel {
  final String uid;
  final String email;
  final bool emailVerified;
  final bool isAnonymous;
  final String phoneNumber;
  final String photoUrl;
  final String userName;
  final String displayName;

  const UploaderModel({
  required this.uid,
  required this.email,
  required this.emailVerified,
  required this.isAnonymous,
  required this.phoneNumber,
  required this.photoUrl,
    required this.userName,
    required this.displayName,
});

factory UploaderModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
return UploaderModel(

  uid: document.get('uid'),
  email: document.get('email'),
  emailVerified: document.get('emailVerified'),
  isAnonymous: document.get('isAnonymous'),
  phoneNumber: document.get('phoneNumber'),
  photoUrl: document.get('photoUrl'),
  userName: document.get('userName'),
  displayName: document.get('displayName')
);


}


static List<UploaderModel> postFromJson(extractedData) {
return List<UploaderModel>.from(json.decode(extractedData).map((PostsModel) => PostsModel.fromJSON(PostsModel)));

}
}