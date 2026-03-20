import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Setup')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(AppConstants.homeRoute),
          child: const Text('Skip / Done MOCK'),
        ),
      ),
    );
  }
}
