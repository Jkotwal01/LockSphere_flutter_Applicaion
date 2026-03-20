import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
import 'providers/auth_provider.dart';
import 'providers/door_provider.dart';
import 'providers/access_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization, local storage retrieval, etc. will go here later
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DoorProvider()),
        ChangeNotifierProvider(create: (_) => AccessProvider()),
      ],
      child: const SentinelApp(),
    ),
  );
}

class SentinelApp extends StatelessWidget {
  const SentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sentinel Door Lock',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
    );
  }
}
