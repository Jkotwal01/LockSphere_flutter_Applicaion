import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      bool canCheck = await _auth.canCheckBiometrics;

      if (!canCheck) {
        return false;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to unlock the door',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      return authenticated;
    } catch (e) {
      return false;
    }
  }
}
