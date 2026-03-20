import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  // This will eventually hold a User object
  Object? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  Object? get currentUser => _currentUser;

  // For testing splash / router
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
