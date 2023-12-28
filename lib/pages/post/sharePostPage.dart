import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/inboxNotificationModel.dart';
import 'package:reddit_app/models/postModel.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';

class SharePost extends StatefulWidget {
  final PostModel postModel;
  const SharePost({
    required this.postModel,
    super.key
  });

  @override
  State<SharePost> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bodyTextController = TextEditingController();
  final ChatServices _firebaseServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StreamController<Stream<QuerySnapshot>> streamController = StreamController();
  final List<String> userList = [];

  @override
  void initState() {
    _searchController.addListener(() {searchUserName();});
    super.initState();
  }

  searchUserName(){
    setState(() {
      streamController.add(_firebaseServices.searchUserName(_searchController.text));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height-76,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close_outlined)),
                  ],
                ),
              ),
              TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(onPressed: (){_searchController.clear();},icon: const Icon(Icons.search_off_outlined),),
                      suffixIcon: IconButton(onPressed: (){
                        if(userList.isNotEmpty && _bodyTextController.text.isNotEmpty) {
                          Navigator.pop(context);
                          FirebaseServices().sendInboxNotification(
                              userList,
                              InboxNotificationModel(notificationID: widget.postModel.postID, from: _firebaseAuth.currentUser!.uid, title: widget.postModel.postTitle, body: _bodyTextController.text, createdOn: Timestamp.now())
                          );
                        }
                      }, icon: const Icon(CupertinoIcons.share_solid)),
                    hintText: "Search by Username"
                  ),
                cursorColor: Colors.grey,
              ),
              const SizedBox(height: 8.0),
              TextField(
                  controller: _bodyTextController,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(onPressed: (){_bodyTextController.clear();},icon: const Icon(Icons.search_off_outlined)),
                      hintText: "Body"
                  ),

              ),
              _buildUserList(),
              for(int i =0; i<userList.length; i++)
                FutureBuilder(
                    future: PostServices().getUser(userList[i]),
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return const Icon(Icons.error_outline);
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const LinearProgressIndicator();
                      }
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(snapshot.data!.imageUrl)),
                        title: Text(snapshot.data!.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: IconButton(
                            onPressed: (){
                              setState(() {
                                userList.removeWhere((element) => element == snapshot.data!.uid);
                              });
                            },
                            icon: const Icon(Icons.close)
                        ),
                      );
                    })
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream:  _firebaseServices.searchUserName(_searchController.text),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("User not Found");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 0,);
        }
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    if(userList.any((element) => element == document['uid']) || document['uid'] == _firebaseAuth.currentUser!.uid){
      return const SizedBox();
    }
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage("${document['photoUrl']}")),
      title: Text(document['userName']),
      onTap: () {
          setState(() {
            userList.add(document['uid']);
          });
      },
    );

  }
}
