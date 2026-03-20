import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import '../providers/auth_provider.dart';

// Import screens (assuming they exist as stubs)
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/biometric_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/device_setup/device_setup_screen.dart';
import '../screens/door_control/door_control_screen.dart';
import '../screens/access/access_management_screen.dart';
import '../screens/access/add_user_screen.dart';
import '../screens/logs/activity_logs_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.otpRoute,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: AppConstants.biometricSetupRoute,
        builder: (context, state) => const BiometricSetupScreen(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.deviceSetupRoute,
        builder: (context, state) => const DeviceSetupScreen(),
      ),
      GoRoute(
        path: AppConstants.doorControlRoute,
        builder: (context, state) => const DoorControlScreen(),
      ),
      GoRoute(
        path: AppConstants.accessRoute,
        builder: (context, state) => const AccessManagementScreen(),
      ),
      GoRoute(
        path: AppConstants.addUserRoute,
        builder: (context, state) => const AddUserScreen(),
      ),
      GoRoute(
        path: AppConstants.logsRoute,
        builder: (context, state) => const ActivityLogsScreen(),
      ),
      GoRoute(
        path: AppConstants.notificationsRoute,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppConstants.settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    // redirect: (context, state) {
    //   final authProvider = context.read<AuthProvider>();
    //   final isLoggedIn = authProvider.isLoggedIn;
    //   final isLoggingIn = state.matchedLocation == AppConstants.loginRoute || 
    //                       state.matchedLocation == AppConstants.otpRoute;
    //   
    //   // Note: In Phase 1 we will keep redirection simple or turned off 
    //   // so we can test routes easily. We will properly enable the guard later.
    //   return null; 
    // },
  );
}
