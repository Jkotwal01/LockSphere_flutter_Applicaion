import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkSession() async {
    _isAuthenticated = await _authService.hasValidSession();
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> sendOtp(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onError,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.sendOtp(
        phoneNumber,
        onCodeSent: onCodeSent,
        onError: onError,
      );

      // Safety timeout: If nothing happens for 30s, stop the loading spinner
      Future.delayed(const Duration(seconds: 30), () {
        if (_isLoading) {
          _isLoading = false;
          notifyListeners();
        }
      });

      // Note: We don't set loading back to false on general success here. Wait for codeSent.
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> verifyOtp(String verificationId, String otp) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.verifyOtp(verificationId, otp);
    if (success) _isAuthenticated = true;

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
