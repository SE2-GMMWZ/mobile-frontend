import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../data/docking_spot_data.dart';
import '../services/user_storage.dart';

void scheduleLocalReminders(BuildContext context) async {
  final bookings = await ApiService().getBookings();
  final now = DateTime.now();
  final user = await UserStorage.currentUser;

  for (final booking in bookings) {
    DockingSpotData? dock = await ApiService().getDockById(booking.dockId);
    final dockName = dock?.name ?? 'your dock'; 
    //final startDate = DateTime.parse(booking.startDate); // adjust field name
    //final reminderTime = startDate.subtract(Duration(days: 1));
    final reminderTime = DateTime.now().add(Duration(seconds: 10));
    // Save the reminder as a notification in the backend
    if (user != null) {
      await ApiService().createNotification({
        "user_id": user.id,
        "message": "Reminder: You have a dock reservation tomorrow at $dockName.",
        "timestamp": DateTime.now().toIso8601String(),
      });
    }
    if (reminderTime.isAfter(now)) {
      final duration = reminderTime.difference(now);
      Timer(duration, () {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Reminder: You have a dock reservation tomorrow at $dockName.'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      });
    }
  }
}