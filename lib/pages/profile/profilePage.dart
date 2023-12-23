import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/pages/scrollView.dart';
import 'package:reddit_app/services/posts/post_services.dart';

import '../../models/postModel.dart';
import '../post/postCard.dart';


class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({
    required this.uid,
    super.key
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String userName = "";
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userName),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Colors.black, Colors.blue]),
    ),
    ),
    ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: PostServices().getUser(widget.uid),
            builder: (context, snapshot){
              Stream<QuerySnapshot<Map<String, dynamic>>> postStream = Provider.of<PostServices>(context).getUserPostData(widget.uid);
              if(snapshot.hasError){
                return const Icon(Icons.error_outline);
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return const LinearProgressIndicator();
              }
                userName = snapshot.data!.userName;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                      maxRadius: 120,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Text(snapshot.data!.userName, style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600 ,color: Colors.black)),
                  const SizedBox(width: 16.0),
                   const Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                     SizedBox(width: 8.0),
                     Column(children: [
                       Text("1234",
                           style: TextStyle(
                               fontSize: 16, fontWeight: FontWeight.w500)),
                       Text("Social Score", style: TextStyle(color: Colors.grey))
                     ]),
                     SizedBox(width: 32.0),
                     Column(children: [
                       Text("1234",
                           style: TextStyle(
                               fontSize: 16, fontWeight: FontWeight.w500)),
                       Text("Followers", style: TextStyle(color: Colors.grey))
                     ])
                     ]),
                  const SizedBox(height: 8.0),
                   _firebaseAuth.currentUser!.uid == widget.uid
                       ? const SizedBox(height: 0, width: 0)
                       : GestureDetector(
                       onTap: () {},
                       child: Container(
                           padding: const EdgeInsets.symmetric(
                               horizontal: 20, vertical: 8.0),
                           decoration: const BoxDecoration(
                               color: Colors.blueAccent,
                               borderRadius:
                               BorderRadius.all(Radius.circular(15))),
                           child: const Text("Follow",
                               style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.w500,
                                   color: Colors.white
                               )
                           )
                       )
                   ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(

                    stream: postStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            PostModel postModel = PostModel(
                                postID: snapshot.data!.docs[index].get("postID"),
                                postTitle: snapshot.data!.docs[index].get('postTitle').toString(),
                                postDescription: snapshot.data!.docs[index].get('postDescription'),
                                uploadedOn: snapshot.data!.docs[index].get('uploadedOn'),
                                uploadedBy: snapshot.data!.docs[index].get('uploadedBy'),
                                imageUrl: snapshot.data!.docs[index].get('imageUrl'),
                                upVotes: snapshot.data!.docs[index].get('upVotes'),
                                downVotes: snapshot.data!.docs[index].get('downVotes'));
                            return PostCard(
                              postModel: postModel,
                              currentUser: _firebaseAuth,
                            );
                          },
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return const SizedBox(height: 0);
                      }
                    },
                  ),
                ],
              );
            }
            ),
      ),
    );
  }
}
