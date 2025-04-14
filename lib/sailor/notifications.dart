import 'package:flutter/material.dart';
import '../app_drawer.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('11 December', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('Editor replied to your comment'),
                subtitle: Text('Thanks!!'),
                trailing: Text('Just now'),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('The details of your booking changed'),
                trailing: Text('5 hours ago'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
