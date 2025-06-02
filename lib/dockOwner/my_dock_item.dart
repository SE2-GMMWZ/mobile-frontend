import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/dockOwner/details_dock.dart';
import 'package:book_and_dock_mobile/dockOwner/edit_dock.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:flutter/material.dart';
import '../data/docking_spot_data.dart';

class MyDockItem extends StatelessWidget {
  final DockingSpotData spot;
  final Future<UserProfile?> currentUser;
  final VoidCallback? onUpdated;
  final VoidCallback? onDeleted;


  const MyDockItem({
    super.key,
    required this.spot,
    required this.currentUser,
    this.onUpdated,
    this.onDeleted,
  });

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
            SizedBox(height: 5),
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
                      side: BorderSide(color: Colors.black),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text('View Details', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Dock"),
                          content: const Text("Are you sure you want to delete this dock?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await ApiService().deleteDock(spot.dock_id!);
                          onDeleted?.call();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dock deleted.")));
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete dock.")));
                        }
                      }
                    },

                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text('Remove Dock', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditDockPage(dock: spot)),
                      );
                      if (onUpdated != null) onUpdated!();
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