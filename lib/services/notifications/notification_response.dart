import 'package:reddit_app/services/notifications/notification_services.dart';

import '../../models/notificationsModel.dart';

class NotificationResponses {
  final NotificationServices notificationServices = NotificationServices();


  void acceptCall(String userUID) {
    notificationServices.sendNotification(
        NotificationsModel(
            to: userUID,
            priority: 'high',
            title: 'Response',
            body: 'accept',
            type: 'acceptCall',
            id: '1',
            payload: 'accept'
        )
    );
  }
  void rejectCall(String userUID) {
    notificationServices.sendNotification(
        NotificationsModel(
            to: userUID,
            priority: 'high',
            title: 'Response',
            body: 'reject',
            type: 'rejection',
            id: '1',
            payload: 'reject'
        )
    );
  }
  void hangCall(String userUID) {
    notificationServices.sendNotification(
        NotificationsModel(
            to: userUID,
            priority: 'high',
            title: 'Response',
            body: 'hang',
            type: 'hangCall',
            id: '1',
            payload: 'hang'
        )
    );
  }
}