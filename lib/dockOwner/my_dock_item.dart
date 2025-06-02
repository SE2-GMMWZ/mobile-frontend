import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/dockOwner/details_dock.dart';
import 'package:book_and_dock_mobile/dockOwner/edit_dock.dart';
import 'package:flutter/material.dart';
import '../data/docking_spot_data.dart';

class MyDockItem extends StatelessWidget {
  final DockingSpotData spot;
  final Future<UserProfile?> currentUser;

  const MyDockItem({super.key, required this.spot, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(spot.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              trailing: Text('${spot.price_per_night} PLN/ per night', 
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
              ),
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
                          builder: (context) => MyDockDetailsPage(dock: spot)
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black), // Black border
                      backgroundColor: Colors.grey[300], // Light grey background
                    ),
                    child: Text('View Details', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
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
                        MaterialPageRoute(builder: (context) => EditDockPage(dock: spot,)));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black), 
                      backgroundColor: Colors.grey[300],
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
