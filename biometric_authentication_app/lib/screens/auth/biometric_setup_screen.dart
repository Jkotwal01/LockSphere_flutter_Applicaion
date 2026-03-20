import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/biometric_service.dart';

class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key});

  void _enableBiometric(BuildContext context) async {
    final success = await BiometricService.authenticate();
    if (success && context.mounted) {
      // In a real app we'd save this preference
      context.go(AppConstants.homeRoute);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication failed or canceled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint_rounded, size: 100, color: AppTheme.primary),
              const SizedBox(height: 40),
              Text('Fast, Secure\nAccess', textAlign: TextAlign.center, style: AppTextStyles.displayMd),
              const SizedBox(height: 16),
              Text(
                'Enable biometric authentication (Fingerprint or Face ID) for seamless access to Sentinel.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLg,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _enableBiometric(context),
                  child: const Text('Enable Biometrics', style: TextStyle(color: AppTheme.surface)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(AppConstants.homeRoute),
                child: Text('Skip for now', style: AppTextStyles.bodyMd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
