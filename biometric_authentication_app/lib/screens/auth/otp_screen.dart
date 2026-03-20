import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../providers/auth_provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthProvider>().login();
            context.go(AppConstants.biometricSetupRoute);
          },
          child: const Text('Verify & Continue'),
        ),
      ),
    );
  }
}
