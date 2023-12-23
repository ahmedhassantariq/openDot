import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String messageID;
  final String senderID;
  final String receiverID;
  final String message;
  final bool isEdited;
  final Timestamp timestamp;

  ChatMessageModel(
      this.messageID,
      this.senderID,
      this.receiverID,
      this.message,
      this.isEdited,
      this.timestamp);


  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}