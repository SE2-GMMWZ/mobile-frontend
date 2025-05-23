class NotificationData {
  final String message;
  final String notificationId;
  final String timestamp;
  final String userId;

  NotificationData({
    required this.message,
    required this.notificationId,
    required this.timestamp,
    required this.userId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['message'],
      notificationId: json['notification_id'],
      timestamp: json['timestamp'],
      userId: json['user_id'],
    );
  }
}