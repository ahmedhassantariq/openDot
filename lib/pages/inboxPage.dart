import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/inboxNotificationModel.dart';
import 'package:reddit_app/pages/post/postView.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InboxNotificationModel>>(
        stream: FirebaseServices().getInboxNotifications(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Text("Error Loading Inbox");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }
          if(snapshot.data!.isNotEmpty){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (builder, index) {
                  return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: const Align(alignment: Alignment.center, child: Icon(Icons.delete, color: Colors.white)),
                      ),
                      key: Key(snapshot.data![index].notificationID),
                      onDismissed: (direction) {
                        setState(() {
                          FirebaseServices().deleteInboxNotification(snapshot.data![index].notificationID);
                        });},
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                future: PostServices().getSinglePost(snapshot.data![index].notificationID),
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return const SizedBox();
                                  }
                                  if(snapshot.hasError){
                                    return const Text("Error Connecting Call");
                                  }
                                  return PostView(postModel: snapshot.requireData);
                                },)));
                          FirebaseServices().deleteInboxNotification(snapshot.data![index].notificationID);
                        },
                        child: ListTile(
                          title: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: const StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                text: snapshot.data![index].title),
                          ),
                          trailing: Text(("${DateTime.now().difference(snapshot.data![index].createdOn.toDate()).inHours}h"), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                        ),
                      )
                  );
                });
          }
          return const Center(child: Text("No Notification", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),));
        });
  }
}


