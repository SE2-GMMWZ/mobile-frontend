import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../services/api_service.dart';
import '../data/notifications_data.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationData> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }


  Future<void> _loadNotifications() async {
    final fetched = await ApiService().getNotifications();
    print('Fetched spots: ${fetched.length}');
    setState(() {
      notifications = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('No notifications.'))
              : ListView.builder(
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
                ),
    );
  }
}