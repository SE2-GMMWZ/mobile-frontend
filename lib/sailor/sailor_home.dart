import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../dock_details.dart';
import '../profile/my_profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book&Dock'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () { 
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyProfilePage()));
            }
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),

            // List of Docks
            Expanded(
              child: ListView(
                children: [
                  _dockItem('Dock 1', 'Beautiful seaside dock in Gdynia', '999 PLN', context),
                  _dockItem('Dock 2', 'Exclusive yacht spot in Sopot', '1299 PLN', context),
                  _dockItem('Dock 3', 'Cozy marina in Mazury', '899 PLN', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dockItem(String title, String description, String price, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.image, size: 50), // Placeholder for image
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(price, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DockDetailsPage(title: title, description: description),
                  ),
                );
              },
              child: Text('View Details >'),
            ),
          ],
        ),
      ),
    );
  }
}
