import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.100";

  Future<bool> registerDevice(String deviceIdentifier) async {
    // Simulate HTTP network latency
    await Future.delayed(const Duration(seconds: 2));
    
    // In production, we send the deviceIdentifier along with the AuthProvider JWT
    // return http.post('/devices', headers: {Authorization: Bearer <jwt>})
    
    return true; 
  }

  static Future<bool> unlockDoor() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/unlock"),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Phase 6: Access Management Mocks
  Future<List<Map<String, dynamic>>> getAccessList(String deviceId) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock latency
    // Mock Database response
    return [
      {
        'id': 'u_01',
        'name': 'Primary Owner',
        'phoneOrEmail': '+1234567890',
        'role': 'Owner',
        'startTime': null,
        'endTime': null,
      },
      {
        'id': 'u_02',
        'name': 'Family Member',
        'phoneOrEmail': '+1987654321',
        'role': 'Member',
        'startTime': null,
        'endTime': null,
      },
    ];
  }

  Future<bool> createAccess(String deviceId, Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock latency
    return true; // Simulate successful cloud write
  }

  Future<bool> revokeAccess(String accessId) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock latency
    return true; // Simulate successful cloud delete
  }

  // Phase 7: Activity Logs Mock
  Future<List<Map<String, dynamic>>> getLogs(String deviceId) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock Network Latency
    
    final now = DateTime.now();
    
    // Return sample timeline data
    return [
      {
        'id': 'log_01',
        'action': 'Unlocked',
        'method': 'App',
        'userName': 'Primary Owner',
        'timestamp': now.subtract(const Duration(minutes: 5)).toIso8601String(),
      },
      {
        'id': 'log_02',
        'action': 'Locked',
        'method': 'Auto-Lock',
        'userName': 'System',
        'timestamp': now.subtract(const Duration(minutes: 4)).toIso8601String(),
      },
      {
        'id': 'log_03',
        'action': 'Failed Attempt',
        'method': 'Biometrics',
        'userName': 'Unknown',
        'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'log_04',
        'action': 'Unlocked',
        'method': 'PIN',
        'userName': 'Family Member',
        'timestamp': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        'id': 'log_05',
        'action': 'Battery Low',
        'method': 'System',
        'userName': 'Device Status',
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];
  }

  // Phase 8: Notifications Mock
  Future<List<Map<String, dynamic>>> getNotifications(String deviceId) async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      {
        'id': 'notif_01',
        'title': 'Multiple Failed Attempts',
        'message': '5 failed biometric attempts detected at the Front Door.',
        'type': 'Alert',
        'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'isRead': false,
      },
      {
        'id': 'notif_02',
        'title': 'New Device Paired',
        'message': 'Family Member successfully paired a new iPhone.',
        'type': 'System',
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
        'isRead': true,
      },
      {
        'id': 'notif_03',
        'title': ' Firmware Update Available',
        'message': 'Sentinel v2.1.0 is available. Tap Settings to update.',
        'type': 'Info',
        'timestamp': now.subtract(const Duration(days: 2)).toIso8601String(),
        'isRead': true,
      },
    ];
  }
}
