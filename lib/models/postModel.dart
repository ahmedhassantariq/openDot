
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postID;
  final String postTitle;
  final String postDescription;
  final Timestamp uploadedOn;
  final String uploadedBy;
  final int upVotes;
  final int downVotes;
  final List<dynamic> imageUrl;

  const PostModel({
    required this.postID,
    required this.postTitle,
    required this.uploadedBy,
    required this.postDescription,
    required this.uploadedOn,
    required this.upVotes,
    required this.imageUrl,
    required this.downVotes,
  });

  factory PostModel.fromMap(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    return(PostModel(
        postID: documentSnapshot.get('postID'),
        postTitle: documentSnapshot.get('postTitle'),
        uploadedBy: documentSnapshot.get('uploadedBy'),
        postDescription: documentSnapshot.get('postDescription'),
        uploadedOn: documentSnapshot.get('uploadedOn'),
        upVotes: documentSnapshot.get('upVotes'),
        imageUrl: documentSnapshot.get('imageUrl'),
        downVotes: documentSnapshot.get('downVotes'),
    ));
  }


}