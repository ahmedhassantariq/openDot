import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/models/postModel.dart';
import 'package:reddit_app/pages/post/postCard.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
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
  final PostServices _postServices = PostServices();
  final StreamController<Stream<List<PostModel>>> streamController = StreamController();



  Future<void> refreshScrollView() async {
    setState(() {
      streamController.add(_postServices.getPostData());
    });
  }
  @override
  void initState() {
    streamController.add(_postServices.getPostData());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: _postServices.getPostData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: refreshScrollView,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return PostCard(
                  postModel: snapshot.data![index],
                );
              },
            ),
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
