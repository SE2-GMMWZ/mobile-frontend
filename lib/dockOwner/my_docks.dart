import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../sailor/notifications.dart';
import 'add_dock.dart';
import '../sailor/dock_item.dart';

class MyDocksPage extends StatefulWidget {

  const MyDocksPage({super.key});

  @override
  State<MyDocksPage> createState() => _MyDocksPageState();
}

class _MyDocksPageState extends State<MyDocksPage> {
  late Future<UserProfile?> _currentUserFuture;
  List<DockingSpotData> spots = [];
  List<DockingSpotData> filteredSpots = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadDockingSpots();
  }

  void _loadUser() {
    _currentUserFuture = UserStorage.currentUser;
  }

  Future<void> _loadDockingSpots() async {
    final fetched = await ApiService().getOwnerDockingSpots();
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
        title: Text('My Docks'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          }),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDockPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add Dock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredSpots.isEmpty
                      ? Center(child: Text('No matching docking spots.'))
                      : ListView(
                          children: filteredSpots
                              .map((spot) => DockItem(spot: spot, currentUser: _currentUserFuture,))
                              .toList(),
                        ),
            ),
          ],
        ),
        
      ),
    );
  }
}
