import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel{
  final String chatID;
  final String senderID;

  const ChatRoomModel({
    required this.chatID,
    required this.senderID,
});

  factory ChatRoomModel.fromMap(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    return(
        ChatRoomModel(
        senderID: documentSnapshot.get("senderID"),
        chatID: documentSnapshot.get("chatID")));
  }
}