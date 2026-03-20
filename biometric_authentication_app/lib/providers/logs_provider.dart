import 'package:flutter/material.dart';
import '../models/log_model.dart';
import '../services/api_service.dart';

class LogsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<LogModel> _logs = [];
  bool _isLoading = false;

  List<LogModel> get logs => _logs;
  bool get isLoading => _isLoading;

  Future<void> fetchLogs(String deviceId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getLogs(deviceId);
      
      _logs = data.map((json) => LogModel(
        id: json['id'],
        action: json['action'],
        method: json['method'],
        userName: json['userName'],
        timestamp: DateTime.parse(json['timestamp']),
      )).toList();
      
      // Sort newest first
      _logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      // Handle error natively
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
