import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  int currentIndex = 0;
   onTapped(int index){
     setState(() {
       currentIndex = index;
     });
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "Inbox", activeIcon: Icon(Icons.notifications)),
    ]);
  }


  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Color(0xff232f34),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: Color(0xff344955),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none, alignment: Alignment(0, 0),
                          children: <Widget>[
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                ListTile(
                                  title: const Text(
                                    "Inbox",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: const Icon(
                                    Icons.inbox,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: const Text(
                                    "Starred",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: const Icon(
                                    Icons.star_border,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: const Text(
                                    "Sent",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: const Text(
                                    "Trash",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: const Text(
                                    "Spam",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: const Text(
                                    "Drafts",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: const Icon(
                                    Icons.mail_outline,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            )
                          ],
                        ))),
                Container(
                  height: 56,
                  color: Color(0xff4a6572),
                )
              ],
            ),
          );
        });
  }
}