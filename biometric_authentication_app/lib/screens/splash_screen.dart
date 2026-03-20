import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final authProvider = context.read<AuthProvider>();
    
    // Add artificial delay for splash branding
    await Future.delayed(const Duration(seconds: 2));
    
    await authProvider.checkSession();

    if (mounted) {
      if (authProvider.isAuthenticated) {
        context.go(AppConstants.homeRoute);
      } else {
        context.go(AppConstants.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fake logo placeholder
            Icon(Icons.shield_rounded, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 24),
            Text('Sentinel', style: AppTextStyles.displayMd),
            const SizedBox(height: 8),
            Text('Secure Door Access', style: AppTextStyles.bodyMd),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
