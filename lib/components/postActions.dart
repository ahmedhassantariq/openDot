import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/postInfoModel.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';

class PostActions extends StatefulWidget {
  final String postID;
  final onTap;


  PostActions({
    required this.postID,
    this.onTap,
    super.key
  });



  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  late Future<PostInfoModel> postInfoModel;
  final PostServices _postServices = PostServices();
  int liked = 0;
  @override
  void initState() {
    postInfoModel = _postServices.getPostInfo(widget.postID);
    super.initState();
  }



  @override
  Widget build(BuildContext) {
    return FutureBuilder(
      future: _postServices.getPostInfo(widget.postID),
      builder: (context, snapshot) {
        Color thumbUpColor = Colors.black;
        Color thumbDownColor = Colors.black;
        Color votesTextColor = Colors.black;
        int votes = 0;

        if(snapshot.hasError){
          return const Text("Error Loading");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const SizedBox(height: 0,);
        }

        if(snapshot.data!.isLiked==-1){
          thumbDownColor = Colors.red;
          votesTextColor = thumbDownColor;
          liked = snapshot.data!.isLiked;
        }
        if(snapshot.data!.isLiked==1){
          thumbUpColor = Colors.blue;
          votesTextColor = thumbUpColor;
          liked = snapshot.data!.isLiked!;
        }

        if(snapshot.data!.isLiked==-1){
          thumbDownColor = Colors.red;
          votesTextColor = thumbDownColor;
          liked = snapshot.data!.isLiked;
        }


        isLiked(){
          if(liked==-1) {
            liked+=2;
            votes+=2;
            setState(() {
              thumbUpColor = Colors.blue;
              thumbDownColor = Colors.black;
              votesTextColor = thumbUpColor;
            });
          }else if(liked==1) {
            liked--;
            votes--;
            setState(() {
              thumbUpColor = Colors.black;
              votesTextColor = Colors.black;
            });

          } else {
            liked++;
            votes++;
            setState(() {
              thumbUpColor = Colors.blue;
              votesTextColor = thumbUpColor;
            });
          }
          _postServices.updateVotes(widget.postID, votes, liked);
        }

        isDisliked(){
          if(liked==1){
            liked-=2;
            votes-=2;
            setState(() {
              thumbUpColor = Colors.black;
              thumbDownColor = Colors.red;
              votesTextColor = thumbDownColor;
            });
          } else if(liked==-1){
            liked++;
            votes++;
            setState(() {
              thumbDownColor = Colors.black;
              votesTextColor = Colors.black;
            });

          } else {
            liked--;
            votes--;
            setState(() {
              thumbDownColor = Colors.red;
              votesTextColor = thumbDownColor;
            });
          }
          _postServices.updateVotes(widget.postID, votes, liked);
        }





        return Container(
          decoration: const BoxDecoration(),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(50))
                ),
                child: Row(
                    children: [
                      GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Icon(Icons.thumb_up_alt_outlined, size: 20, color: thumbUpColor),
                                const SizedBox(width: 5.0),
                                // Text(snapshot.data!.upVotes.toString(), style: TextStyle(color: votesTextColor),),
                              ],
                            ),
                          ),
                          onTap: (){isLiked();},
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 3.0,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                            height: 20.0,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.thumb_down_alt_outlined, size: 20, color: thumbDownColor,),
                          ),
                          onTap: (){isDisliked();},
                      ),
                    ]),

              ),
              const SizedBox(width: 8.0),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(25))
                ),
                child:
                      GestureDetector(
                        onTap: widget.onTap,
                        child:  Padding(
                          padding: const EdgeInsets.all(5.0),
                            child: Row(children: [
                              const Icon(Icons.mode_comment_outlined, size: 20, color: Colors.black,),
                              const SizedBox(width: 5.0),
                              Text(snapshot.data!.commentLength.toString(), style: const TextStyle(color: Colors.black),),
                            ]),

                        ),
                      ),

              ),
            ],
          ),
        );
      }
    );
  }
}
