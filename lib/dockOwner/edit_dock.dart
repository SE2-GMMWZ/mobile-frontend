import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:flutter/material.dart';

class EditDockPage extends StatefulWidget {
  final DockingSpotData dock;

  const EditDockPage({super.key, required this.dock});

  @override
  State<EditDockPage> createState() => _EditDockPageState();
}

class _EditDockPageState extends State<EditDockPage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _priceNightController;
  late TextEditingController _pricePersonController;
  late TextEditingController _servicesController;
  late String _availability;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dock.name);
    _locationController = TextEditingController(text: widget.dock.town ?? '');
    _priceNightController = TextEditingController(text: widget.dock.price_per_night.toString());
    _pricePersonController = TextEditingController(text: widget.dock.price_per_person.toString());
    _servicesController = TextEditingController(text: widget.dock.services ?? '');
    _availability = widget.dock.availability ?? "available";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceNightController.dispose();
    _pricePersonController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Details'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {}
          ),
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
                    const Text("Name"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: widget.dock.name,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Location"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: widget.dock.latitude,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Price per night"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),   
                      child: TextField(
                        controller: _priceNightController,
                        decoration: InputDecoration(
                          hintText: widget.dock.price_per_night.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Price per person"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _pricePersonController,
                        decoration: InputDecoration(
                          hintText:  widget.dock.price_per_person.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Services"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _servicesController,
                        decoration: InputDecoration(
                          hintText: widget.dock.services.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

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
                            "name": _nameController.text.trim(),
                            "location": {
                              "town": _locationController.text.trim(),
                              "latitude": widget.dock.latitude,
                              "longitude": widget.dock.longitude,
                            },
                            "description": widget.dock.description ?? '', 
                            "owner_id": widget.dock.owner_id,
                            "services": _servicesController.text.trim(),
                            "services_pricing": widget.dock.services_pricing ?? 0,
                            "price_per_night": double.tryParse(_priceNightController.text) ?? 0,
                            "price_per_person": double.tryParse(_pricePersonController.text) ?? 0,
                            "availability": _availability,
                          };

                          try {
                            await ApiService().updateDockingSpot(widget.dock.dock_id!, updatedData);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dock updated successfully")));
                            Navigator.pop(context);
                          } catch (_) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update dock")));
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