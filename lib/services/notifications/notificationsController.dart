import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/pages/chat/videoCall/videoCallReceive.dart';

import '../posts/post_services.dart';

class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(BuildContext context, ReceivedNotification receivedNotification) async {
    print("Created");
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(BuildContext context, ReceivedNotification receivedNotification) async {
    print("Displayed");
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(BuildContext context, ReceivedAction receivedAction, RemoteMessage message) async {
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(BuildContext context, ReceivedAction receivedAction, RemoteMessage message) async {
    if(message.data['type']== 'call' && receivedAction.buttonKeyPressed.toString() == 'accept'){
      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => FutureBuilder(
            future: PostServices().getUser(message.data['sender'].toString()),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const SizedBox();
              }
              if(snapshot.hasError){
                return const Text("Error Connecting Call");
              }
              return VideoCallReceive(receiver: snapshot.requireData, message: message, isVideo: false,);
            },)));
    }
  }


  void webNotificationMethod(BuildContext context, RemoteMessage message) {
    if(message.data['type']== 'call'){
      showModalBottomSheet(
          isScrollControlled: false,
          enableDrag: true,
          isDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ListView(
              children: [
                FutureBuilder(
                  future: PostServices().getUser(message.data['sender'].toString()),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const SizedBox();
                    }
                    if(snapshot.hasError){
                      return const Text("Error Loading Message");
                    }
                    return Column(children: [
                      Text(snapshot.data!.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8.0),
                      CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.imageUrl), minRadius: 48,),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> VideoCallReceive(receiver: snapshot.requireData, message: message, isVideo: false,)));
                          }, icon: const Icon(Icons.call, color: Colors.green,size: 32,)),
                          IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.call_end, color: Colors.red,size: 32,))
                      ],),
                      const SizedBox(height: 8.0)
                    ]);
                  },),
              ],
            );
          });
    }
    if(message.data['type']== 'chat'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message: ${message.notification!.body.toString()}")));
    }
  }


}