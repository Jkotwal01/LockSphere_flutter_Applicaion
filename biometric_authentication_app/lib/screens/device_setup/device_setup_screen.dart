import 'package:flutter/material.dart';

class DeviceSetupScreen extends StatelessWidget {
  const DeviceSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Setup')),
      body: const Center(
        child: Text('Scan & Connect to ESP32'),
      ),
    );
  }
}
