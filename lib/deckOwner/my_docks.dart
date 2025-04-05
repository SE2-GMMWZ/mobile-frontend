import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../notifications.dart';
import 'add_dock.dart';
import 'edit_dock.dart';

class MyDocksPage extends StatefulWidget {
  const MyDocksPage({super.key});

  @override
  State<MyDocksPage> createState() => _MyDocksPageState();
}

class _MyDocksPageState extends State<MyDocksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Docks'),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDockPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add Dock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            _dockItem('Dock 1', 'Real Address 12', '30/11/2024 - 30/11/2024'),
            _dockItem('Docky', 'Bueno Street', '30/11/2024 - 01/11/2024'),
            _dockItem('I’m Not', 'That Creative', '30/11/2024 - 01/11/2024'),
          ],
        ),
        
      ),
    );
  }

  Widget _dockItem(String name, String location, String date) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.image, size: 50),
              title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$location\n$date'),
              trailing: Text('999 PLN', 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black), // Black border
                      backgroundColor: Colors.grey[300], // Light grey background
                    ),
                    child: Text('Remove Dock', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditDockPage()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black), // Black border
                      backgroundColor: Colors.grey[300], // Light grey background
                    ),
                    child: Text('Change Details >', style: TextStyle(color: Colors.black)),
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
