import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/pages/drawer/settings/settingsPage.dart';
import 'package:reddit_app/services/posts/post_services.dart';


class EndDrawer extends StatefulWidget {
  const EndDrawer({super.key});

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder(
              future: PostServices().getUser(_firebaseAuth.currentUser!.uid),
              builder: (builder, snapshot){
                if(snapshot.hasError) {
                  return const Text("Error Loading");
                }
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return Column(
                  children: [
                    const SizedBox(height: 8.0),
                    CircleAvatar(
                      foregroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(snapshot.data!.imageUrl), minRadius: 50,),
                    const SizedBox(height: 8.0),
                    Text(snapshot.data!.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                  ],
                );
              }),
          const SizedBox(height: 8.0),
          TextButton.icon(
            onPressed: (){
              _firebaseAuth.signOut();
            }, icon: const Icon(Icons.logout_outlined, color: Colors.black,) , label: const Text("Sign Out", style: TextStyle(color: Colors.black),),),
          const SizedBox(height: 8.0),
          TextButton.icon(
            onPressed: (){
              Navigator.pop(context);
              showSettingsMenu();
            }, icon: const Icon(Icons.settings_outlined, color: Colors.black,) , label: const Text("Settings", style: TextStyle(color: Colors.black),),)
        ],
      ),
    );
  }
  showSettingsMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: SettingsPage());
        });
  }
}
