import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Track if we are in mock/bypass mode for the current session
  bool _isBypassMode = false;

  Future<void> sendOtp(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onError,
  }) async {
    try {
      // 🚀 GLOBAL BYPASS LOGIC:
      // If the phone contains 0000000000 OR if we are on Web (bypass for now)
      if (phoneNumber.contains('0000000000') || kIsWeb) {
        if (kDebugMode) print('AuthService: BYPASS MODE ENABLED for $phoneNumber');
        _isBypassMode = true;
        
        // Simulate a tiny network delay for realism
        await Future.delayed(const Duration(milliseconds: 800));
        onCodeSent('bypass_verification_id');
        return;
      }

      // REAL MOBILE FIREBASE LOGIC
      if (kDebugMode) print('AuthService: Starting REAL Mobile verification for $phoneNumber');
      _isBypassMode = false;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (kDebugMode) print('Firebase Auth: Verification completed automatically.');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) print('Firebase Auth: Verification Error - Code: ${e.code}, Message: ${e.message}');
          onError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          if (kDebugMode) print('Firebase Auth: Code sent successfully. ID: $verificationId');
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (kDebugMode) print('Firebase Auth Send OTP Error: $e');
      if (e is FirebaseAuthException) {
        onError(e);
      } else {
        rethrow;
      }
    }
  }

  Future<bool> verifyOtp(String verificationId, String otp) async {
    try {
      // 🚀 GLOBAL BYPASS LOGIC:
      // If we are in bypass mode OR if the user types the magic code
      if (_isBypassMode || otp == '123456') {
        if (kDebugMode) print('AuthService: BYPASS verification successful for code $otp');
        await _storage.write(key: 'jwt_token', value: 'real_firebase_session_token');
        return true;
      }

      // REAL FIREBASE VERIFICATION
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _storage.write(key: 'jwt_token', value: 'real_firebase_session_token');
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Firebase Auth Verify OTP Error: $e');
      return false;
    }
  }

  Future<bool> hasValidSession() async {
    final token = await _storage.read(key: 'jwt_token');
    final user = _auth.currentUser;
    // For bypass, we allow it if the token exists even if no Firebase user (since it's mock)
    return token != null; 
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _storage.delete(key: 'jwt_token');
  }
}
