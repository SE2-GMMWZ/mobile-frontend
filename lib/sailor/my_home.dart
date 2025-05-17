import 'package:flutter/material.dart';
import '../app_drawer.dart';
import 'dock_details.dart';
import '../profile/my_profile.dart';
import 'notifications.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book&Dock'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          }),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyProfilePage())); 
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _dockItem('Dock 1', 'Beautiful seaside dock in Gdynia', '999 PLN', context),
            _dockItem('Dock 2', 'Exclusive yacht spot in Sopot', '1299 PLN', context),
            _dockItem('Dock 3', 'Cozy marina in Mazury', '899 PLN', context),
          ],
        ),
      ),
    );
  }

  Widget _dockItem(String name, String location, String price, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.image, size: 50), // Placeholder
              title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(location),
              trailing: Text(price, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DockDetailsPage(title: name, description: location),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text('View Details >', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
