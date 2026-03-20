import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary navigation to login after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go(AppConstants.loginRoute);
      }
    });

    return const Scaffold(
      body: Center(
        child: Text('Splash Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
