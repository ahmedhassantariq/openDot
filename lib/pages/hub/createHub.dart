import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/components/postTextfield.dart';
import 'package:reddit_app/pages/hub/hubPage.dart';
import 'package:reddit_app/services/hub/hub_services.dart';

class CreateHub extends StatefulWidget {
  const CreateHub({super.key});

  @override
  State<CreateHub> createState() => _CreateHubState();
}



class _CreateHubState extends State<CreateHub> {
  TextEditingController _hubTitleController = TextEditingController();
  bool _switchValue = true;

  createHub(){
    HubServices hubServices = HubServices();
    hubServices.createHub(_hubTitleController.text, _switchValue);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a new Hub")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            PostTextField(controller: _hubTitleController, hintText: "Title", obscureText: false, fontSize: 16,fontWeight: FontWeight.w700),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_switchValue ? "Public" : "Private",style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                CupertinoSwitch(dragStartBehavior: DragStartBehavior.down,activeColor: Colors.blue,value: _switchValue, onChanged: (value){
                  setState(() {
                    _switchValue = value;
                  });
                }),
              ],
            ),
            const SizedBox(height: 8.0),
            CupertinoButton(onPressed: (){
                if(_hubTitleController.text.isNotEmpty){
                  createHub();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title is Empty")));
                }
            }, color: Colors.blue, child: const Text("Create Hub"))
          ],
        ),
      ),
    );
  }
}
