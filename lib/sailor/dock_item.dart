import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:flutter/material.dart';
import '../data/docking_spot_data.dart';
import 'dock_details.dart';

class DockItem extends StatelessWidget {
  final DockingSpotData spot;
  final Future<UserProfile?> currentUser;

  const DockItem({super.key, required this.spot, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.image, size: 50), // Placeholder
              title: Text(spot.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(spot.town),
              trailing: Text(
                '${spot.price_per_night} \$',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DockDetailsPage(spot: spot, currentUser: currentUser,),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('View Details >', style: TextStyle(color: Colors.black)),
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
