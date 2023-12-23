import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../models/chatMessageModel.dart';

class ChatServices extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getChatRooms() {
    String currentUserID = _firebaseAuth.currentUser!.uid;
    Stream<QuerySnapshot> stream = _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("chats")
        .snapshots();
    return stream;
  }


  Stream<QuerySnapshot> getChatRoomMessages(String userID){
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(userID)
        .collection("messages").orderBy("timestamp", descending: false)
        .snapshots();
  }


  Future<String> getNewChatRoom() async{
    String roomID = _firestore.collection('chats').doc().id;
    return roomID;
  }

  Future<void> sendChatInvite(String roomID,List<String> inviteesList) async{
    final String currentUserID = _firebaseAuth.currentUser!.uid;

    inviteesList.add(currentUserID);
    _firestore.collection('chat').doc('chatRooms').collection(roomID).doc("Settings").set({
      "roomName":"New Chat",
      "adminUid":currentUserID,
      "members":inviteesList,
      "imageUrl":"https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg?size=626&ext=jpg&ga=GA1.1.1546980028.1702252800&semt=sph"
    });
    for(int i=0;i<inviteesList.length;i++){
      _firestore.collection("reddit")
          .doc('users').collection("user_credentials")
          .doc(inviteesList[i]).collection("userChat").doc(roomID).set({});
    }
  }

  Future<void> deleteChat(String userID) async{
    await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection("chats").doc(userID).delete();
  }

  Future<void> sendMessage(String receiverID, String message) async{
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    String docID =  _firestore.collection("users").doc(currentUserID).collection("chats").doc(receiverID).collection("messages").doc().id;

    ChatMessageModel messageModel = ChatMessageModel(docID,currentUserID, receiverID, message, false, Timestamp.now());
    DocumentReference senderDoc = _firestore.collection("users").doc(currentUserID).collection("chats").doc(receiverID);
    DocumentReference receiverDoc = _firestore.collection("users").doc(receiverID).collection("chats").doc(currentUserID);

    senderDoc.get().then((docSnap) {
      if(!docSnap.exists){
        _firestore.collection("users").doc(currentUserID).collection("chats").doc(receiverID).set({"createOn": Timestamp.now()});
      }
    });
    await _firestore.collection("users").doc(currentUserID).collection("chats").doc(receiverID).collection("messages").doc(docID).set(messageModel.toMap());

    receiverDoc.get().then((docSnap) {
      if(!docSnap.exists){
        _firestore.collection("users").doc(receiverID).collection("chats").doc(currentUserID).set({"createOn": Timestamp.now()});
      }
    });
    await _firestore.collection("users").doc(receiverID).collection("chats").doc(currentUserID).collection("messages").doc(docID).set(messageModel.toMap());
  }

  Future<void> deleteMessage(String userID, String messageID) async{
    await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection("chats").doc(userID).collection("messages").doc(messageID).delete()
        .then((value) {
      _firestore.collection('users').doc(userID).collection("chats").doc(_firebaseAuth.currentUser!.uid).collection("messages").doc(messageID).delete();

        });

  }

  Future<void> editMessage(String userID, String messageID, String message) async{
    await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection("chats").doc(userID).collection("messages").doc(messageID).update({
          "message":message,
          "isEdited":true
        })
        .then((value) {
      _firestore.collection('users').doc(userID).collection("chats").doc(_firebaseAuth.currentUser!.uid).collection("messages").doc(messageID).update({
        "message":message,
        "isEdited":true
      });
      print("deleted");
    });

  }

  Stream<QuerySnapshot> searchUserName(String userName) {
    return _firestore
        .collection('users')
        .where('userName', isLessThanOrEqualTo: userName)
        .snapshots();
  }

}
