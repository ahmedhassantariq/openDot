import 'package:cloud_firestore/cloud_firestore.dart';

class PostInfoModel {
  final int upVotes;
  final int downVotes;
  final int isLiked;
  final int commentLength;

  const PostInfoModel({
    required this.upVotes,
    required this.downVotes,
    required this.isLiked,
    required this.commentLength,

});

  factory PostInfoModel.fromMap(DocumentSnapshot<Map<String, dynamic>>? documentSnapshot){
    return(
        PostInfoModel(
            upVotes: documentSnapshot?.get("upVotes"),
            downVotes: documentSnapshot?.get("downVotes"),
            isLiked: documentSnapshot?.get("isLiked"),
          commentLength: 0
        )
    );
  }



}