import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/models/postModel.dart';
import 'package:reddit_app/pages/post/postCard.dart';
import 'package:reddit_app/services/posts/post_services.dart';
class ScrollViewPage extends StatefulWidget {
  const ScrollViewPage({
    super.key
  });

  @override
  State<ScrollViewPage> createState() => _ScrollViewPageState();
}

class _ScrollViewPageState extends State<ScrollViewPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
     Stream<QuerySnapshot<Map<String, dynamic>>> postStream = Provider.of<PostServices>(context).getPostData();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
          return const LinearProgressIndicator();
        }
      },
    );
  }
}
