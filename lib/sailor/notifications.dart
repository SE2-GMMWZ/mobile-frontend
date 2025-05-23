import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../services/api_service.dart';
import '../data/notifications_data.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationData>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = ApiService().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<NotificationData>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications.'));
          }
          final notifications = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return Card(
                child: ListTile(
                  title: Text(n.message),
                  subtitle: Text(n.timestamp),
                ),
              );
            },
          );
        },
      ),
    );
  }
}