import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/components/commentActions.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shimmer_container/shimmer_container.dart';

import '../../../services/firebase/firebase_services.dart';
import '../../profile/bottomProfileModal.dart';

class CommentCard extends StatefulWidget {
  final String postID;
  final String commentID;
  final String comment;
  final String uploadedBy;
  final Timestamp uploadedOn;
  final int upVotes;
  final int downVotes;
  final FirebaseAuth currentUser;

  const CommentCard(
      {required this.postID,
      required this.commentID,
      required this.comment,
      required this.uploadedBy,
      required this.uploadedOn,
      required this.upVotes,
      required this.downVotes,
      required this.currentUser,
      super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final PostServices _postServices = PostServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _postServices.getUser(widget.uploadedBy),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Text("Error Loading Comment");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return SizedBox(height: 0,);
        }
        return Container(
          color: Colors.grey[200],
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showUserProfile();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                              backgroundColor: Colors.transparent,
                              radius: 15),
                          const SizedBox(width: 8.0),
                          Text(
                            snapshot.data!.userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            ("${DateTime.now().difference(widget.uploadedOn.toDate()).inHours}h"),
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                        ]),
                        IconButton(
                            onPressed: () {
                              showCommentPopUpMenu();
                            },
                            icon: const Icon(
                              Icons.menu_outlined,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(widget.comment),
                  const SizedBox(height: 8.0),
                  // CommentActions(
                  //     postID: widget.postID,
                  //     commentID: widget.commentID,
                  //     votes: widget.upVotes),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  showCommentPopUpMenu() {
    showModalBottomSheet(
        enableDrag: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: ListView(
                children: [
                  widget.uploadedBy == widget.currentUser.currentUser!.uid
                      ? TextButton.icon(
                          style: TextButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0)),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _postServices.deleteComment(widget.postID,
                                widget.commentID, widget.uploadedBy);
                            Provider.of<PostServices>(context, listen: false)
                                .notifyListeners();
                            Navigator.pop(context);
                          },
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.9),
                            child: const Text("Delete Comment",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ),
                        )
                      : const SizedBox(height: 0, width: 0)
                ],
              )),
            ],
          );
        });
  }



  showUserProfile() {
    showModalBottomSheet<dynamic>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
        ),
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8.0),
              physics: const ScrollPhysics(),
              child: BottomProfileModal(uploadedBy: widget.uploadedBy));
        });
  }
}
