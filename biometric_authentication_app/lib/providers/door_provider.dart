import 'package:flutter/material.dart';

class DoorProvider extends ChangeNotifier {
  bool _isLocked = true;
  bool _isOnline = true;
  String _connectionType = 'Wi-Fi'; // or BLE

  bool get isLocked => _isLocked;
  bool get isOnline => _isOnline;
  String get connectionType => _connectionType;

  void toggleLock() {
    _isLocked = !_isLocked;
    notifyListeners();
  }
}
