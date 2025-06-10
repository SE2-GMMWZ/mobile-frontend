import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotificationPoller with WidgetsBindingObserver {
  final BuildContext context;
  Timer? _timer;
  int _lastNotificationCount = 0;

  NotificationPoller(this.context);

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _startPolling();
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 30), (_) => _checkForNewNotifications());
  }

  Future<void> _checkForNewNotifications() async {
    final notifications = await ApiService().getNotifications();
    if (notifications.length > _lastNotificationCount) {
      _lastNotificationCount = notifications.length;
      _showSnackBar(notifications.last.message); // newest notification
    }
  }

  void _showSnackBar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForNewNotifications();
    }
  }
}
