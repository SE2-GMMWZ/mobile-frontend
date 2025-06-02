import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/dockOwner/my_dock_item.dart';
import 'package:book_and_dock_mobile/profile/my_profile.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../sailor/notifications.dart';
import 'add_dock.dart';

class MyDocksPage extends StatefulWidget {

  const MyDocksPage({super.key});

  @override
  State<MyDocksPage> createState() => _MyDocksPageState();
}

class _MyDocksPageState extends State<MyDocksPage> {
  late Future<UserProfile?> _currentUserFuture;
  List<DockingSpotData> spots = [];
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
      isLoading = false;
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
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage()));
          }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final user = await _currentUserFuture;
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDockPage(currentUser: _currentUserFuture),
                    ),
                  );

                  if (result == true) {
                    _loadDockingSpots(); 
                  }
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
                  : spots.isEmpty
                      ? Center(child: Text('No matching docking spots.'))
                      : ListView(
                          children: spots
                              .map((spot) => MyDockItem(
                                spot: spot,
                                currentUser: _currentUserFuture,
                                onUpdated: _loadDockingSpots,
                                onDeleted: _loadDockingSpots,
                              ))
                              .toList(),
                        ),
            ),
          ],
        ),
        
      ),
    );
  }
}
