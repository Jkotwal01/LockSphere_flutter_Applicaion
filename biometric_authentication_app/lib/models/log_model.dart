class LogModel {
  final String id;
  final String action; // 'Unlocked', 'Locked', 'Failed Attempt', 'Battery Low'
  final String method; // 'Biometrics', 'App', 'PIN', 'NFC'
  final String userName;
  final DateTime timestamp;

  LogModel({
    required this.id,
    required this.action,
    required this.method,
    required this.userName,
    required this.timestamp,
  });

  // Determines the type of icon to show in the UI list
  bool get isSuccess => action == 'Unlocked' || action == 'Locked';
  bool get isWarning => action == 'Battery Low';
  bool get isError => action == 'Failed Attempt';
}
