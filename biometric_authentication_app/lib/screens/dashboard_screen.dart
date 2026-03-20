import 'package:flutter/material.dart';
import '../services/biometric_service.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String status = "Door is Locked";

  Future<void> unlockProcess() async {
    bool isAuthenticated = await BiometricService.authenticate();

    if (isAuthenticated) {
      bool unlocked = await ApiService.unlockDoor();

      setState(() {
        status = unlocked ? "Door Unlocked ✅" : "ESP32 Error ❌";
      });
    } else {
      setState(() {
        status = "Authentication Failed ❌";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Door Lock"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            Text(
              status,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: "Unlock Door",
              onPressed: unlockProcess,
            ),
          ],
        ),
      ),
    );
  }
}
