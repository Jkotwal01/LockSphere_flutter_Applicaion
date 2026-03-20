class AppConstants {
  // API URLs
  static const String apiBaseUrl = 'https://api.yourdomain.com/v1';
  // MQTT URLs
  static const String mqttBrokerUrl = 'mqtt.yourdomain.com';
  static const int mqttBrokerPort = 8883; // Secure MQTT
  
  // BLE UUIDs
  static const String bleServiceUUID = "12345678-1234-1234-1234-1234567890ab";
  static const String bleCharacteristicUUID = "abcd1234-5678-1234-5678-abcdef123456";
  
  // Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String deviceIdKey = 'device_id';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String otpRoute = '/otp';
  static const String biometricSetupRoute = '/biometric-setup';
  static const String homeRoute = '/home';
  static const String deviceSetupRoute = '/device-setup';
  static const String doorControlRoute = '/door-control';
  static const String accessRoute = '/access';
  static const String addUserRoute = '/add-user';
  static const String logsRoute = '/logs';
  static const String notificationsRoute = '/notifications';
  static const String settingsRoute = '/settings';
}
