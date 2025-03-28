import 'package:flutter/material.dart';
import 'app_drawer.dart';

class GuidesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guides'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
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
                      hintText: 'Search...',
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
            // List of Guides
            Expanded(
              child: ListView(
                children: [
                  _guideItem('Discover Dockify', 'Dockify connects sailors with premium docking spots.'),
                  _guideItem('Discover Harbor Haven', 'Harbor Haven offers a peaceful and luxurious docking experience.'),
                  _guideItem('Ahoy to The Boatyard', 'The Boatyard is your vibrant hub for docking and exploring Mazury.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideItem(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.image, size: 50), // Placeholder for image
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('Read more >'),
        ),
      ),
    );
  }
}
