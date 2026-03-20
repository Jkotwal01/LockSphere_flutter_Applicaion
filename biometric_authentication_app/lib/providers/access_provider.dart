import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/access_model.dart';
import 'package:uuid/uuid.dart';

class AccessProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<AccessModel> _accessList = [];
  bool _isLoading = false;

  List<AccessModel> get accessList => _accessList;
  bool get isLoading => _isLoading;

  Future<void> loadAccessList(String deviceId) async {
    _isLoading = true;
    notifyListeners();

    final data = await _apiService.getAccessList(deviceId);
    
    _accessList = data.map((item) => AccessModel(
      id: item['id'],
      name: item['name'],
      phoneOrEmail: item['phoneOrEmail'],
      role: item['role'],
      startTime: item['startTime'] != null ? DateTime.parse(item['startTime']) : null,
      endTime: item['endTime'] != null ? DateTime.parse(item['endTime']) : null,
    )).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addAccess(String deviceId, String name, String contact, String role, DateTime? start, DateTime? end) async {
    _isLoading = true;
    notifyListeners();

    // Mock API call
    final payload = {
      'name': name,
      'phoneOrEmail': contact,
      'role': role,
      'startTime': start?.toIso8601String(),
      'endTime': end?.toIso8601String(),
    };
    
    final success = await _apiService.createAccess(deviceId, payload);
    if (success) {
      // Optimistic UI update
      _accessList.add(AccessModel(
        id: const Uuid().v4(), // generate mock id
        name: name,
        phoneOrEmail: contact,
        role: role,
        startTime: start,
        endTime: end,
      ));
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> revokeAccess(String accessId) async {
    final success = await _apiService.revokeAccess(accessId);
    if (success) {
      _accessList.removeWhere((item) => item.id == accessId);
      notifyListeners();
    }
    return success;
  }
}
