import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';

class DoorProvider extends ChangeNotifier {
  final MqttService _mqttService = MqttService();
  
  bool _isLocked = true;
  bool _isOnline = false;
  String _connectionType = 'Wi-Fi'; // or BLE
  bool _isLoading = false;

  final String _mockDeviceId = "esp32_device_01"; // Hardcoded for Phase 5 demo
  final String _mockJwtToken = "demo_jwt_token"; // Hardcoded for Phase 5 demo

  DoorProvider() {
    _initMqtt();
  }

  bool get isLocked => _isLocked;
  bool get isOnline => _isOnline;
  String get connectionType => _connectionType;
  bool get isLoading => _isLoading;

  Future<void> _initMqtt() async {
    _mqttService.onConnectionChange = (bool connected) {
      _isOnline = connected;
      _connectionType = 'Wi-Fi / MQTT';
      notifyListeners();
    };

    _mqttService.onStateChange = (bool locked) {
      _isLocked = locked;
      _isLoading = false;
      notifyListeners();
    };

    // Attempt connection
    await _mqttService.connect(_mockDeviceId);
  }

  Future<void> toggleLock() async {
    // If not online, maybe fallback to BLE in full prod. 
    // For now, we simulate success if offline to allow UI testing.
    
    _isLoading = true;
    notifyListeners();

    if (_isOnline) {
      // Send real MQTT command
      final action = _isLocked ? "UNLOCKED" : "LOCKED";
      bool sent = _mqttService.sendAction(_mockDeviceId, action, _mockJwtToken);
      
      if (!sent) {
        // Fallback or error
        _isLoading = false;
        notifyListeners();
      }
    } else {
      // Simulate fake delay if offline or MQTT fails to connect (Mock Demo mode)
      await Future.delayed(const Duration(seconds: 2));
      _isLocked = !_isLocked;
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }
}
