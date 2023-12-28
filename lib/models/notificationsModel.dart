class NotificationsModel {
  final String to;
  final String priority;
  final String title;
  final String body;
  final String type;
  final String id;
  final String payload;

  const NotificationsModel({
    required this.to,
    required this.priority,
    required this.title,
    required this.body,
    required this.type,
    required this.id,
    required this.payload
  });
}