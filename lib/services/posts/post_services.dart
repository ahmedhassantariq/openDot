import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:reddit_app/models/postInfoModel.dart';
import 'package:reddit_app/models/userDataModel.dart';

class PostServices extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredentialsModel> getUser(String userUID) async {
    DocumentSnapshot<Map<String, dynamic>> userCredentials = await _firestore
        .collection('users').doc(userUID).get();
    return UserCredentialsModel.fromMap(userCredentials);
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> getPostData() {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = _firestore.collection('posts')
        .orderBy('uploadedOn', descending: true).get().asStream();
    return data;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserPostData(String userID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = _firestore.collection('posts')
        .where("uploadedBy", isEqualTo: userID)
        .get().asStream();
    return data;
  }

  Future<void> createPost(String postTitle, String postBody, List<dynamic> imageUrl) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String docID = _firestore.collection('reddit').doc('posts').collection("user_posts").doc().id;
    await _firestore
        .collection('posts')
        .doc(docID)
        .set(
        {
          "postID": docID,
          "uploadedBy": currentUserId,
          "uploadedOn": Timestamp.now(),
          "postTitle": postTitle,
          "postDescription": postBody,
          "upVotes": 0,
          "downVotes": 0,
          "imageUrl": imageUrl
        });
    notifyListeners();
  }


  Future<void> updatePost(String postID,String postTitle, String postBody, List<dynamic> imageUrl) async {
    await _firestore
        .collection('posts')
        .doc(postID)
        .update(
        {
          "postTitle": postTitle,
          "postDescription": postBody,
          "imageUrl": imageUrl
        });
    notifyListeners();
  }


  Future<void> deletePost(String postID, String uploadedBy) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    if (currentUserId == uploadedBy) {
      await _firestore
          .collection('posts')
          .doc(postID)
          .delete();
    }
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentData(String postID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = _firestore.collection(
        'posts').doc(postID).collection(
        'comments').orderBy('uploadedOn').get().asStream();
    return data;
  }

  Future<void> createComment(String postID, String commentBody) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String commentID = _firestore.collection('posts').doc(postID).collection('comments').doc().id;
    await _firestore
        .collection('posts')
        .doc(postID).collection('comments').doc(commentID).set({
      "commentID": commentID,
      "uploadedBy": currentUserId,
      "uploadedOn": Timestamp.now(),
      "upVotes": 0,
      "downVotes": 0,
      "comment": commentBody
    });
    notifyListeners();
  }


  Future<void> deleteComment(String postID, String commentID, String uploadedBy) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    if (currentUserId == uploadedBy) {
      await _firestore
          .collection('posts')
          .doc(postID)
          .collection('comments')
          .doc(commentID)
          .delete();
    }
  }


  Future<String>uploadImage(String pickedImageName, Uint8List img) async {
    final storageReference = FirebaseStorage.instance.ref(
        "images/${pickedImageName}");
    final TaskSnapshot task = await storageReference.putData(img);
    print(task.totalBytes);
    print(task.bytesTransferred);

    return await task.ref.getDownloadURL();
  }

  Future<PostInfoModel> getPostInfo(String postID) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> voteData = await _firestore.collection('users').doc(currentUserId).collection('votes').doc(postID).get();
    DocumentSnapshot<Map<String, dynamic>> upVotes = await _firestore.collection('posts').doc(postID).get();

    CollectionReference commentLength = _firestore.collection("posts").doc(postID).collection("comments");
     var snapshot =  await commentLength.get();
     var count = snapshot.size;
      return PostInfoModel(upVotes: upVotes.get('upVotes') , downVotes: 0, isLiked: voteData.get('liked'), commentLength: count);
  }


  Future<void> updateVotes(String postID, int votes, int liked) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    await _firestore
        .collection('posts')
        .doc(postID).update({
      "upVotes": votes
    });
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('votes')
        .doc(postID)
        .set(
        {
          'postID': postID,
          'liked': liked,
        }
    );
  }

  Future<void> updateCommentVotes(String postID, String commentID, int votes) async {
    await _firestore
        .collection('posts')
        .doc(postID).collection('comments').doc(commentID).update(
        {"upVotes": votes});
  }


  Stream<QuerySnapshot> searchComment(String postID,String comment ) {
    return _firestore
        .collection('posts').doc(postID).collection("comments")
        .snapshots();
  }

}