import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications(String deviceId) async {
    _isLoading = true;
    notifyListeners();

    final data = await _apiService.getNotifications(deviceId);
    
    _notifications = data.map((item) => NotificationModel(
      id: item['id'],
      title: item['title'],
      message: item['message'],
      type: item['type'],
      timestamp: DateTime.parse(item['timestamp']),
      isRead: item['isRead'],
    )).toList();

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
