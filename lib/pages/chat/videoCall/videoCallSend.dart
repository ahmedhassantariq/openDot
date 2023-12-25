import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reddit_app/components/myTextfield.dart';
import 'package:reddit_app/services/chat/chat_services.dart';

import '../../../services/signaling.dart';


class VideoCallSend extends StatefulWidget {
  final String receiverID;
  const VideoCallSend({
    required this.receiverID,
    super.key,
  });
  @override
  _VideoCallSendState createState() => _VideoCallSendState();
}

class _VideoCallSendState extends State<VideoCallSend> {
  WebRtcManager signaling = WebRtcManager();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;

  sendMessage(String roomID) {
    if(roomId!=null) {
      ChatServices().sendMessage(widget.receiverID, roomID, "call");
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
            IconButton(onPressed: (){signaling?.switchToScreenSharing();}, icon: const Icon(Icons.screen_share, color: Colors.black,)),
            IconButton(onPressed: (){signaling?.switchCamera();}, icon: const Icon(Icons.switch_camera, color: Colors.black,))
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

            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
