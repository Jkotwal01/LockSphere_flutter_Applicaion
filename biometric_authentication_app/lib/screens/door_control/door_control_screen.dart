import 'package:flutter/material.dart';

class DoorControlScreen extends StatelessWidget {
  const DoorControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Door Control')),
      body: const Center(
        child: Text('Unlock via BLE / MQTT'),
      ),
    );
  }
}
