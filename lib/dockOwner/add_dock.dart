import 'dart:convert';

import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';

class AddDockPage extends StatefulWidget 
{
  final Future<UserProfile?> currentUser;
  const AddDockPage({super.key, required this.currentUser});

  @override
  State<AddDockPage> createState() => _AddDockPageState();
}

class _AddDockPageState extends State<AddDockPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceNightController = TextEditingController();
  final _pricePersonController = TextEditingController();
  final _slotsController = TextEditingController();
  final _servicesController = TextEditingController();
  final _servicesPriceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _priceNightController.dispose();
    _pricePersonController.dispose();
    _slotsController.dispose();
    _servicesController.dispose();
    _servicesPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dock'),
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
                    const Text("Name"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Dock',
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
                        decoration: const InputDecoration(
                          hintText: 'Mazury',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Description"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _descriptionController,
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Enter a short description of the dock...',
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
                        decoration: const InputDecoration(
                          hintText: 'in PLN',
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
                        decoration: const InputDecoration(
                          hintText: 'in PLN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Number of available slots"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _slotsController,
                        decoration: const InputDecoration(
                          hintText: '20',
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
                        decoration: const InputDecoration(
                          hintText: 'water, electricity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Price for services"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _servicesPriceController,
                        decoration: const InputDecoration(
                          hintText: '10',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = await UserStorage.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must be logged in')));
                            return;
                          }

                          final dockingSpotData = {
                            "name": _nameController.text.trim(),
                            "location": {
                              "town": _locationController.text.trim(),
                              "latitude": 0.0,
                              "longitude": 0.0,
                            },                       
                            "description": _descriptionController.text.trim(),
                            "owner_id": user.id ?? "",                        
                            "services": _servicesController.text.trim(),
                            "services_pricing": double.tryParse(_servicesPriceController.text) ?? 0,
                            "price_per_night": double.tryParse(_priceNightController.text) ?? 0,
                            "price_per_person": double.tryParse(_pricePersonController.text) ?? 0,
                            "availability": "available",                      
                          };
                          try {
                            await ApiService().submitDockingSpot(dockingSpotData);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Dock added successfully!')),
                            );
                            Navigator.pop(context, true);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to add dock')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Add Dock"),
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