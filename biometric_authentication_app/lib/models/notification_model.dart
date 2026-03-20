class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'Alert', 'System', 'Info'
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  bool get isAlert => type == 'Alert';
}
