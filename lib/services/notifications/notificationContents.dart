import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationContents {

  NotificationContent messageNotification(RemoteMessage message) {
    return NotificationContent(
      id: 123,
      channelKey: 'channel',
      color: Colors.blue,
      title: message.notification!.title,
      body: message.notification!.body,
      category: NotificationCategory.Message,
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      backgroundColor: Colors.orange,
    );
  }
  NotificationContent callNotification(RemoteMessage message) {
    return NotificationContent(
      id: 123,
      channelKey: 'channel',
      color: Colors.blue,
      title: message.notification!.title,
      body: message.notification!.body,
      category: NotificationCategory.Call,
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      backgroundColor: Colors.orange,
      showWhen: true,
      displayOnBackground: true,
      displayOnForeground: true,
    );
  }
}