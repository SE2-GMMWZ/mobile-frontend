import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:book_and_dock_mobile/profile/my_profile.dart';
import 'package:book_and_dock_mobile/sailor/notifications.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:flutter/material.dart';

class MyDockDetailsPage extends StatefulWidget {
  final DockingSpotData dock;

  const MyDockDetailsPage({super.key, required this.dock});

  @override
  State<MyDockDetailsPage> createState() => _DockDetailsPageState();
}

class _DockDetailsPageState extends State<MyDockDetailsPage> {
  late String _availability;

  @override
  void initState() {
    super.initState();
    _availability = widget.dock.availability ?? "available";
  }

  Widget buildDisplayField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Details'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          }),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage()));
          }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDisplayField("Name", widget.dock.name),
                    buildDisplayField("Location", widget.dock.town ?? ''),
                    buildDisplayField("Latitude", widget.dock.latitude.toString()),
                    buildDisplayField("Longitude", widget.dock.longitude.toString()),
                    buildDisplayField("Price per night", widget.dock.price_per_night.toString()),
                    buildDisplayField("Price per person", widget.dock.price_per_person.toString()),
                    buildDisplayField("Services", widget.dock.services ?? ''),
                    buildDisplayField("Availability", _availability ?? 'available'),                  
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
