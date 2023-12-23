
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postID;
  final String? postTitle;
  final String? postDescription;
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




}