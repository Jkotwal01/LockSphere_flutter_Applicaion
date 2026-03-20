import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

class AccessManagementScreen extends StatelessWidget {
  const AccessManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Management')),
      body: const Center(
        child: Text('User List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppConstants.addUserRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}
