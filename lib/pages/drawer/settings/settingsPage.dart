import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/userDataModel.dart';
import 'package:reddit_app/pages/drawer/settings/userSettings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        TextButton.icon(onPressed: (){
          Navigator.pop(context);
          showUserSettingsMenu();
        }, icon: const Icon(CupertinoIcons.person, color: Colors.black,), label: const Text("User Settings", style: TextStyle(color: Colors.black),))
      ],
    );
  }

  showUserSettingsMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: UserSettings());
        });
  }
}
