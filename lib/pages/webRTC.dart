import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reddit_app/components/myTextfield.dart';

import '../services/signaling.dart';


class WebRTCPage extends StatefulWidget {
  WebRTCPage({Key? key}) : super(key: key);

  @override
  _WebRTCPageState createState() => _WebRTCPageState();
}

class _WebRTCPageState extends State<WebRTCPage> {
  WebRtcManager signaling = WebRtcManager();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    signaling.hangUp(_localRenderer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: <Widget>[
            MyTextField(controller: textEditingController, hintText: 'RoomID', obscureText: false,),
            SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  },
                  child: Text("Open"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    roomId = await signaling.createRoom(_localRenderer,_remoteRenderer);
                    textEditingController.text = roomId!;
                    setState(() {});
                  },
                  child: Text("Create"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add roomId
                    signaling.joinRoom(
                      textEditingController.text.trim(),_localRenderer,_remoteRenderer
                    );
                  },
                  child: Text("Join room"),
                ),
                ElevatedButton(
                  onPressed: () {
                    signaling.hangUp(_localRenderer);
                  },
                  child: Text("Hangup"),
                )
              ],
            ),
            SizedBox(height: 8),
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
