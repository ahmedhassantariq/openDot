import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:reddit_app/components/messageTextField.dart';
import 'package:reddit_app/pages/chat/videoCall/videoCallReceive.dart';
import 'package:reddit_app/pages/chat/videoCall/videoCallSend.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import 'package:http/http.dart' as http;

class ChatRoom extends StatefulWidget {
  final String receiverID;
  const ChatRoom({
    required this.receiverID,
    super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _commentEditingController = TextEditingController();
  final TextEditingController _messageEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FocusNode focusNode = FocusNode();
  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if(_controller.hasClients){
          _scrollDown();
        }}
    );});
  }

  submitMessage(){
    if(_messageEditingController.text.isNotEmpty) {
      _chatServices.sendMessage(widget.receiverID, _messageEditingController.text, 'text').then((value) => _scrollDown());
      _messageEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:const Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {Navigator.pop(context);},),
        title: FutureBuilder(
          future: PostServices().getUser(widget.receiverID),
          builder: (context,snapshot) {
            if(snapshot.hasError){
              return const Text("Error Loading Info");
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const SizedBox(height: 0, width: 0);
            }
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(snapshot.data!.imageUrl)),
                const SizedBox(width: 8.0),
                Text(snapshot.data!.userName,style: const TextStyle(color: Colors.black)),
              ],
            );
          },

        ),
        actions: [
          IconButton(onPressed: (){
            notificationServices.getDeviceToken().then((value)async {
              print(value.toString());
              var data = {
                'to' : value.toString(),
                'priority': 'high',
                'notification': {
                  'title':'Ahmed',
                  'body':'Hello',
                },
                'data' : {
                  'type': 'chat',
                  'id': '1'
                }
              };
              await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              body: jsonEncode(data),
                headers: {
                'Content-Type' : 'application/json',
                  'Authorization' :'Key=AAAAX29LRcw:APA91bHMZGtk79tLwypFQmtKdaiwB2wHz-V7CDpO5lkbnzX1Zgnuc05gHBXGuA3267PKvx-2eFRdoIRcTj9kMEA6hzH8_yTeTPMyED8H376K0fOmO0pQy7VEK2Us1RM_CzNbXcmNXunl'
                }
              );
            });
          }, icon: Icon(Icons.notifications, color: Colors.black,)),
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallSend(receiverID: widget.receiverID)));}, icon: const Icon(Icons.video_call, color: Colors.black,)),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList()),
          Column(
            children: [
              MessageTextField(
                onIconPress: (){submitMessage();},
                onSubmitted: (e){
                  submitMessage();
                  },
                  controller: _messageEditingController,
                focusNode: focusNode,
                icon: const Icon(Icons.send),
              ),

            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatServices.getChatRoomMessages(widget.receiverID),
        builder: (context, snapshots) {
      if(snapshots.hasError) {
        return const Text("Has Error");
      }
      if(snapshots.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      return ListView(
        controller: _controller,
        children: snapshots.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderID'] == FirebaseAuth.instance.currentUser!.uid)
    ?
    Alignment.bottomRight
        :
    Alignment.centerLeft;
    Color color = (data['senderID'] == FirebaseAuth.instance.currentUser!.uid)
    ?
        Colors.blue.shade300
    :
        Colors.green.shade300;
    Timestamp timestamp = data['timestamp'];
    final time = DateFormat('hh:mm');
    final difference = DateTime.now().difference(timestamp.toDate());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
        // difference.inHours>24
        //     ?
        // Align(
        //     alignment: Alignment.center,
        //     child: Text("${timestamp.toDate().day.toString()}/${timestamp.toDate().month}/${timestamp.toDate().year}")) : SizedBox(),
        Text(time.format(timestamp.toDate()), style: const TextStyle(fontWeight: FontWeight.w600),),
          data['messageType']=='call' ?
          GestureDetector(
            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallReceive(roomID: data['message'])));},
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
                child: const Text("Video Call",softWrap: true,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
          )
              :
          GestureDetector(
              onLongPress: (){ (difference.inDays <= 1 && _firebaseAuth.currentUser!.uid == data['senderID']) ?
              showCommentDeletionMenu(data['messageID']) :
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot Delete Message")));
              },
              onDoubleTap: () {
                (difference.inDays <= 1 &&
                    _firebaseAuth.currentUser!.uid == data['senderID']) ?
                showCommentEditMenu(data['messageID'], data['message']) :
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cannot Edit Message")));
              },
            child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: Text(data['message'],softWrap: true,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
          )
        ]),
    );
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }


  showCommentDeletionMenu(String documentID) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton.icon(onPressed: (){
                  _chatServices.deleteMessage(widget.receiverID, documentID);
                  Navigator.pop(context);
                  }, icon: const Icon(Icons.delete), label: const Text("Delete Comment")),
          );
        });
  }


  showCommentEditMenu(String documentID, String message) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton.icon(onPressed: (){
              Navigator.pop(context);
              showEditingMenu(documentID, message);
            }, icon: const Icon(Icons.edit), label: const Text("Edit Comment")),
          );
        });

  }

  showEditingMenu(String documentID, String message) {

    submitComment(){
    if(_commentEditingController.text.isNotEmpty) {
      _chatServices.editMessage(widget.receiverID, documentID, _commentEditingController.text);
      Navigator.pop(context);
      _commentEditingController.clear();
    }
  }


    _commentEditingController.text = message;
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MessageTextField(
              onIconPress: (){submitComment();},
              controller: _commentEditingController,
              focusNode: FocusNode(),
              onSubmitted: (String e) {
                submitComment();
              },
              icon: Icon(Icons.edit),
            ),
          );
        });
  }

}



