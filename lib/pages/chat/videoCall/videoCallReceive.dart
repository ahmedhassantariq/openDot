import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reddit_app/components/myTextfield.dart';

import '../../../services/signaling.dart';


class VideoCallReceive extends StatefulWidget {
  final String roomID;
  const VideoCallReceive({
    required this.roomID,
    super.key,
  });

  @override
  _VideoCallReceiveState createState() => _VideoCallReceiveState();
}

class _VideoCallReceiveState extends State<VideoCallReceive> {
  WebRtcManager signaling = WebRtcManager();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.joinRoom(widget.roomID, _localRenderer, _remoteRenderer);
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
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                    Expanded(child: RTCVideoView(_remoteRenderer)),
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
