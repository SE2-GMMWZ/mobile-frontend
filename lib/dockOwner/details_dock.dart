import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
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
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
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

                    const Text("Availability"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButtonFormField<String>(
                        value: _availability,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'available', child: Text('Available')),
                          DropdownMenuItem(value: 'unavailable', child: Text('Unavailable')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _availability = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final updatedData = {
                            "name": widget.dock.name,
                            "location": {
                              "town": widget.dock.town ?? '',
                              "latitude": widget.dock.latitude,
                              "longitude": widget.dock.longitude,
                            },
                            "price_per_night": widget.dock.price_per_night,
                            "price_per_person": widget.dock.price_per_person,
                            "services": widget.dock.services ?? '',
                            "availability": _availability,
                          };

                          try {
                            await ApiService().updateDockingSpot(widget.dock.dock_id!, updatedData);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Dock updated successfully")),
                            );
                            Navigator.pop(context);
                          } catch (_) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to update dock")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Save Changes"),
                      ),
                    ),
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
