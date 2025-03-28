import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'notifications.dart';

class MyBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          }),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _bookingItem('Dock 1', 'Real Address 12', '30/11/2024 - 30/11/2024'),
            _bookingItem('Docky', 'Bueno Street', '30/11/2024 - 01/11/2024'),
            _bookingItem('I’m Not', 'That Creative', '30/11/2024 - 01/11/2024'),
          ],
        ),
      ),
    );
  }

  Widget _bookingItem(String name, String location, String date) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.image, size: 50),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$location\n$date'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('999 PLN', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: () {}, child: Text('View Details >')),
          ],
        ),
      ),
    );
  }
}
