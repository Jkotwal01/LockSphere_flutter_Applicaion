class AccessModel {
  final String id;
  final String phoneOrEmail;
  final String name;
  final String role; // 'Owner', 'Member', 'Guest'
  final DateTime? startTime;
  final DateTime? endTime;

  AccessModel({
    required this.id,
    required this.phoneOrEmail,
    required this.name,
    required this.role,
    this.startTime,
    this.endTime,
  });

  bool get isTemporary => startTime != null && endTime != null;
  
  bool get isValidNow {
    if (!isTemporary) return true;
    final now = DateTime.now();
    return now.isAfter(startTime!) && now.isBefore(endTime!);
  }

  // Factory JSON parsing will go here in production
}
