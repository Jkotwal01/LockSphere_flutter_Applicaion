import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sentinel Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Home', style: AppTextStyles.displayMd),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.doorControlRoute),
              child: const Text('Door Control'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.deviceSetupRoute),
              child: const Text('Device Setup'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.accessRoute),
              child: const Text('Access Management'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.logsRoute),
              child: const Text('Activity Logs'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.settingsRoute),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
