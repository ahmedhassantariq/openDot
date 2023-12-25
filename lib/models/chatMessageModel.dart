import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String messageID;
  final String senderID;
  final String receiverID;
  final String message;
  final String messageType;
  final bool isEdited;
  final Timestamp timestamp;

  ChatMessageModel(
      this.messageID,
      this.senderID,
      this.receiverID,
      this.message,
      this.messageType,
      this.isEdited,
      this.timestamp);


  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'messageType': messageType,
      'timestamp': timestamp,
    };
  }
}