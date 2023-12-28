import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reddit_app/models/userDataModel.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';

import '../../../models/notificationsModel.dart';
import '../../../services/chat/signaling.dart';


class VideoCallSend extends StatefulWidget {
  final UserCredentialsModel receiver;
  const VideoCallSend({
    required this.receiver,
    super.key,
  });
  @override
  _VideoCallSendState createState() => _VideoCallSendState();
}

class _VideoCallSendState extends State<VideoCallSend> {
  WebRtcManager signaling = WebRtcManager();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;

  sendMessage(String roomID) {
    if(roomId!=null) {
      NotificationServices().sendNotification(
          NotificationsModel(
              to: widget.receiver.uid,
              priority: 'high',
              title: 'Call',
              body: "Calling",
              type: 'call',
              id: '1',
              payload: roomID
          )
      );
    }
  }

  sendInvite() async{
    roomId = await signaling.createRoom(_localRenderer,_remoteRenderer);
    sendMessage(roomId!);
    setState(() {
    });
  }
  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    sendInvite();

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){Navigator.pop(context);signaling.hangUp(_localRenderer);}, icon: const Icon(Icons.arrow_back, color: Colors.black,)),
          actions: [
            defaultTargetPlatform == TargetPlatform.android
                ?
            IconButton(onPressed: (){signaling?.switchCamera();}, icon: const Icon(Icons.switch_camera, color: Colors.black,))
                :
            const SizedBox()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.red,
          child: CupertinoButton(
              onPressed: (){
                signaling.hangUp(_localRenderer);
                Navigator.pop(context);
              }, child: const Text("Hang Up", style: TextStyle(color: Colors.white),)),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: RTCVideoView(
                          _localRenderer,
                          mirror:
                          true,
                        )),
                    Expanded(
                        child: RTCVideoView(_remoteRenderer)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
