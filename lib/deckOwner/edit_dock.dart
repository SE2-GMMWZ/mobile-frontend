import 'package:book_and_dock_mobile/dock_data.dart';
import 'package:flutter/material.dart';

class EditDockPage extends StatefulWidget {
  const EditDockPage({super.key});

  @override
  State<EditDockPage> createState() => _EditDockPageState();
}

final dock = DockData(
  name: "Dock 1", 
  location: "Niegocin Lake", 
  pricePerNight: 200, 
  pricePerPerson: 20, 
  numberOfSlots: 15, 
  services: "showers, toilets, restaurants",
);

class _EditDockPageState extends State<EditDockPage> {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(width: 10,),

                  Column(
                    children: [
                      const Text("Upload a dock picture", style: TextStyle(fontSize: 16),),

                      TextButton(
                        onPressed: (){},
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_box_rounded,
                              size: 20,
                              color: Colors.black,
                            ),

                            const Text("Add an image", style: TextStyle(fontSize: 16, color: Colors.black),),
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),
              

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
                        decoration: InputDecoration(
                          hintText: dock.name,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Location"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: dock.location,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Price per night"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: dock.pricePerNight.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Price per person"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText:  dock.pricePerPerson.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Number of available slots"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: dock.numberOfSlots.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Services"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: dock.services.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      
                      child: ElevatedButton(
                        onPressed: (){}, 
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