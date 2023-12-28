import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/components/imageViewer.dart';
import 'package:reddit_app/pages/profile/profilePage.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import '../chat/chatRoom.dart';

class BottomProfileModal extends StatefulWidget {
  final String uploadedBy;
  const BottomProfileModal({required this.uploadedBy, super.key});

  @override
  State<BottomProfileModal> createState() => _BottomProfileModalState();
}



class _BottomProfileModalState extends State<BottomProfileModal> {




  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return FutureBuilder(
        future: PostServices().getUser(widget.uploadedBy),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }
          return Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.block)),
            ]),
            Column(children: [
              GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageViewer(url: snapshot.data!.imageUrl)));},
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                    minRadius: 60,
                    backgroundImage: NetworkImage(snapshot.data!.imageUrl)),
              ),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(uid: snapshot.data!.uid)));
                  },
                  child: Text(snapshot.data!.userName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
              const SizedBox(
                height: 8.0,
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text("1234",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("Social Score", style: TextStyle(color: Colors.grey))
                    ]),
                    Column(children: [
                      Text("1234",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("Followers", style: TextStyle(color: Colors.grey))
                    ]),

                  ],
                ),
              ),
              firebaseAuth.currentUser!.uid == widget.uploadedBy
                  ? const SizedBox(height: 0, width: 0)
                  : GestureDetector(
                      onTap: () {
                        ChatServices().getNewChatRoom().then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(receiver: snapshot.requireData,)));
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8.0),
                          decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: const Text("Send Message",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white))))
            ])
          ]);
        });
  }
}
