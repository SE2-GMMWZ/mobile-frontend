import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../profile/my_profile.dart';
import 'dock_item.dart';
import 'notifications.dart';
import '../data/docking_spot_data.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DockingSpotData> spots = [];
  List<DockingSpotData> filteredSpots = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDockingSpots();
  }

  Future<void> _loadDockingSpots() async {
    final fetched = await ApiService().getDockingSpots();
    print('Fetched spots: ${fetched.length}');
    setState(() {
      spots = fetched;
      filteredSpots = fetched;
      isLoading = false;
    });
  }

  void _filterSpots(String query) {
    if (query.isEmpty) {
      // Show all if query is empty
      setState(() {
        searchQuery = '';
        filteredSpots = spots;
      });
      return;
    }

    final filtered = spots.where((spot) {
      return spot.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredSpots = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book&Dock'),
        actions: [
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
              }),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage()));
              }),
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
                    onChanged: _filterSpots,
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // You can add more filters here
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredSpots.isEmpty
                      ? Center(child: Text('No matching docking spots.'))
                      : ListView(
                          children: filteredSpots
                              .map((spot) => DockItem(spot: spot))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}