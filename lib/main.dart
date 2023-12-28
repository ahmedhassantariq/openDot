import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/services/auth/auth_gate.dart';
import 'package:reddit_app/services/auth/auth_service.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/firebase/firebase_options.dart';
import 'package:reddit_app/services/firebase/firebase_services.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';

import 'services/firebase/firebase_options.dart';


// -d chrome --web-renderer html





void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
      ChangeNotifierProvider(create: (context) => AuthService(),
        child: const MyApp(),
      )
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FirebaseServices>(create: (context)=>FirebaseServices()),
          ChangeNotifierProvider<PostServices>(create: (context)=>PostServices()),
          ChangeNotifierProvider<ChatServices>(create: (context)=>ChatServices()),
    ],
      child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open Dot',
      home: AuthGate(),
    ));
  }
}