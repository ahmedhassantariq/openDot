import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';

import 'chatRoom.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatServices _chatServices = ChatServices();
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: _buildUserList(),
    );
  }



  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: _chatServices.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          }
          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          );
        },
        );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return FutureBuilder(
      future: PostServices().getUser(document.id),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Text("Error Loading Chat");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const SizedBox(height: 0);
        }
        return ListTile(

          leading: Image.network(snapshot.data!.imageUrl),
          minVerticalPadding: 20,
          title: Text(snapshot.data!.userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatRoom(receiverID: document.id)));},
          onLongPress: (){showChatDeletionMenu(document.id);},
        );
      }
    );

  }


  showChatDeletionMenu(String chatID) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton.icon(onPressed: (){
              _chatServices.deleteChat(chatID);
              Navigator.pop(context);
            }, icon: const Icon(Icons.delete), label: const Text("Hide Chat")),
          );
        });
  }


}
