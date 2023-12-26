import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:reddit_app/pages/drawer/endDrawer.dart';
import 'package:reddit_app/pages/scrollView.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';

import '../services/firebase/firebase_services.dart';
import 'chat/chatPage.dart';
import 'chat/createNewChat.dart';
import 'post/createPostPage.dart';
import 'drawer/frontDrawer.dart';
import 'inboxPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationServices notificationServices = NotificationServices();
  final FirebaseServices _postServices = FirebaseServices();
  int currentIndex = 0;
  onTapped(int index){
    setState(() {
      if(index==2){
        showPostMenu();
      } else {
        currentIndex = index;
      }
    });
  }

  final List<Widget> _widgets = [
    ScrollViewPage(),
    Container(),
    const CreatePostPage(),
    const ChatPage(),
    const Inbox(),
  ];

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _postServices.initNotifications();

    return Scaffold(
     appBar: _appBar(),
     drawer: const FrontDrawer(),
     endDrawer: const EndDrawer(),
     body: IndexedStack(index: currentIndex,children: _widgets),

     bottomNavigationBar: BottomNavigationBar(
         onTap: onTapped ,
         currentIndex: currentIndex,
         type: BottomNavigationBarType.fixed,
         selectedItemColor: Colors.black,
         unselectedItemColor: Colors.grey,
         showUnselectedLabels: true,
         items: const [
           BottomNavigationBarItem(icon: Icon(Icons.home_outlined, color: Colors.grey,), label: "Home", activeIcon: Icon(Icons.home)),
           BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Communities", activeIcon: Icon(Icons.people)),
           BottomNavigationBarItem(icon: Icon(Icons.add_outlined), label: "Create", activeIcon: Icon(Icons.add)),
           BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: "Chat", activeIcon: Icon(Icons.chat)),
           BottomNavigationBarItem(icon: Badge(label: Text("12"), child: Icon(Icons.notifications_outlined, color: Colors.grey)), label: "Inbox", activeIcon: Icon(Icons.notifications)),
         ]),

    );
  }

  showPostMenu() {
    showModalBottomSheet(
      isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
              child: CreatePostPage());
        });
      }

  showNewChatMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: CreateNewChat());
        });
  }



  PreferredSizeWidget _appBar() {

    List<Widget> list = [
      const SizedBox(height: 0,width: 0,),
      const SizedBox(height: 0,width: 0,),
      const SizedBox(height: 0,width: 0,),
      IconButton(padding: const EdgeInsets.symmetric(horizontal: 18.0),onPressed: (){showNewChatMenu();}, icon: const Icon(Icons.chat)),
      const SizedBox(height: 0,width: 0,),
    ];

    Widget _buildActions() {
      return list[currentIndex];
    }
    return AppBar(
      title: const Text("AppBar", style: TextStyle(color: Colors.black),),
      backgroundColor: HexColor("#FFFFFF"),
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        _buildActions(),
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){Scaffold.of(context).openEndDrawer();},
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://media.istockphoto.com/id/1288385045/photo/snowcapped-k2-peak.jpg?b=1&s=612x612&w=0&k=20&c=e1AiD8S8C5tvF8ZA24I2Q_5myDSgLdxwU385j_yzG-0="),

              ),
            ),
          );
        }
        ),
      ],
    );




  }
}




