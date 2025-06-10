import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../profile/my_profile.dart';
import 'dock_item.dart';
import 'notifications.dart';
import '../data/docking_spot_data.dart';
import '../services/api_service.dart';
import '../notifications/notification_poller.dart';
import '../notifications/schedule_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

 late NotificationPoller _notificationPoller;

class _HomePageState extends State<HomePage> {
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
    _notificationPoller = NotificationPoller(context);
    _notificationPoller.start();
    scheduleLocalReminders(context);
  }

  @override
  void dispose() {
    _notificationPoller.stop();
    super.dispose();
  }

  void _loadUser() {
    _currentUserFuture = UserStorage.currentUser;
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