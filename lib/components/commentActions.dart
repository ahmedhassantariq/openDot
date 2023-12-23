import 'package:flutter/material.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';

import '../services/posts/post_services.dart';


class CommentActions extends StatefulWidget {
  final String postID;
  final String commentID;
  late int votes;
  CommentActions({
    required this.postID,
    required this.commentID,
    required this.votes,
    super.key});

  @override
  State<CommentActions> createState() => _CommentActionsState();
}

class _CommentActionsState extends State<CommentActions> {
  final PostServices _postServices = PostServices();
  Color thumbUpColor = Colors.black;
  Color thumbDownColor = Colors.black;
  Color votesTextColor = Colors.black;
  int liked = 0;
  isLiked(){
    if(liked==-1) {
      liked+=2;
      widget.votes+=2;
      setState(() {
        thumbUpColor = Colors.blue;
        thumbDownColor = Colors.black;
        votesTextColor = thumbUpColor;
      });
    }else if(liked==1) {
      liked--;
      widget.votes--;
      setState(() {
        thumbUpColor = Colors.black;
        votesTextColor = Colors.black;
      });

    } else {
      liked++;
      widget.votes++;
      setState(() {
        thumbUpColor = Colors.blue;
        votesTextColor = thumbUpColor;
      });
    }
    _postServices.updateCommentVotes(widget.postID, widget.commentID, widget.votes);
  }

  isDisliked(){
    if(liked==1){
      liked-=2;
      widget.votes-=2;
      setState(() {
        thumbUpColor = Colors.black;
        thumbDownColor = Colors.red;
        votesTextColor = thumbDownColor;
      });
    } else if(liked==-1){
      liked++;
      widget.votes++;
      setState(() {
        thumbDownColor = Colors.black;
        votesTextColor = Colors.black;
      });

    } else {
      liked--;
      widget.votes--;
      setState(() {
        thumbDownColor = Colors.red;
        votesTextColor = thumbDownColor;
      });
    }
    _postServices.updateCommentVotes(widget.postID, widget.commentID, widget.votes);
  }


  @override
  Widget build(BuildContext) {
    return Container(
      decoration: const BoxDecoration(),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.thumb_up_alt_outlined, size: 20, color: thumbUpColor,),
            ),
            onTap: (){isLiked();},
          ),
          Text(widget.votes.toString(), style: TextStyle(color: votesTextColor),),
          const SizedBox(width: 5.0),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.thumb_down_alt_outlined, size: 20, color: thumbDownColor,),
            ),
            onTap: (){isDisliked();},
          ),
        ],
      ),
    );
  }
}
