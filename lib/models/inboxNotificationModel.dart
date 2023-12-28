import 'package:cloud_firestore/cloud_firestore.dart';

class InboxNotificationModel {
  final String notificationID;
  final String from;
  final String title;
  final String body;
  final Timestamp createdOn;

  const InboxNotificationModel({
    required this.notificationID,
    required this.from,
    required this.title,
    required this.body,
    required this.createdOn,

  });

  Map<String, dynamic> toMap() {
    return {
      'notificationID': notificationID,
      'from': from,
      'title': title,
      'body': body,
      'createdOn': createdOn,
    };
  }



}