import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/hubModel.dart';
import 'package:reddit_app/pages/hub/createHub.dart';
import 'package:reddit_app/pages/hub/hubPage.dart';
import 'package:reddit_app/services/hub/hub_services.dart';


class FrontDrawer extends StatefulWidget {
  const FrontDrawer({super.key});

  @override
  State<FrontDrawer> createState() => _FrontDrawerState();
}

class _FrontDrawerState extends State<FrontDrawer> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final HubServices _hubServices = HubServices();

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        TextButton.icon(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(vertical: 15),),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CreateHub()));
            }, icon: const Icon(Icons.add, color: Colors.black,) , label: const Text("Create your Hub", style: TextStyle(color: Colors.black))),
        const SizedBox(height: 8.0),
        const Text("Your Hubs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
        const SizedBox(height: 8.0),
        _buildUserHubList(),
        const SizedBox(height: 8.0),
        const Text("Joined Hubs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
        const SizedBox(height: 8.0),
        _buildHubList(),
      ],
      )
    );
  }

  Widget _buildHubList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _hubServices.getHubs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 0,);
        }
        return ListView(
          shrinkWrap: true,
          children:
          snapshot.data!.docs
              .map<Widget>((doc) => _buildHubItem(doc))
              .toList(),
        );
      },
    );
  }


  Widget _buildUserHubList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _hubServices.getUserHubs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 0,);
        }
        return ListView(
          shrinkWrap: true,
          children:
          snapshot.data!.docs
              .map<Widget>((doc) => _buildHubItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildHubItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      return TextButton.icon(
          style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(vertical: 15),),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=> HubPage(hubModel: HubModel(
                    hubID: data['hubID'],
                    hubTitle: data['hubTitle'],
                    createdBy: data['createdBy'],
                    createdOn: data['createdOn'],
                    isPublic: data['isPublic']
                ))));
          },
          icon: const Icon(Icons.hub_outlined, color: Colors.black,) , label: Text(data['hubTitle'], style: const TextStyle(color: Colors.black)));
  }
}


