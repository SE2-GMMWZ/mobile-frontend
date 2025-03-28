import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'notifications.dart';

class GuideDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guide Details'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discover Dockify: Your Gateway to Seamless Docking in Mazury!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.image, size: 50),
                Icon(Icons.image, size: 50),
                Icon(Icons.image, size: 50),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Dockify connects sailors with premium docking spots, offering real-time availability, secure online booking, and top-notch amenities like Wi-Fi, fueling stations, and dining options—all in one easy-to-use platform.',
            ),
            SizedBox(height: 20),
            Text('📍 Location', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('💬 Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Anna_Sailor87'),
              subtitle: Text('Loved this guide!'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Captain_Jack'),
              subtitle: Text('This guide inspired my trip!'),
            ),
          ],
        ),
      ),
    );
  }
}
