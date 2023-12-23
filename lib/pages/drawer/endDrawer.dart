import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
          TextButton.icon(
            onPressed: (){
              _firebaseAuth.signOut();
            }, icon: const Icon(Icons.login_outlined, color: Colors.black,) , label: const Text("Sign Out", style: TextStyle(color: Colors.black),),)
        ],
      ),
    );
  }
}
