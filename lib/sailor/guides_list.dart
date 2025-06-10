import 'package:book_and_dock_mobile/data/guides_data.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import 'notifications.dart';
import '../profile/my_profile.dart';
import 'guide_item.dart';
import '../services/api_service.dart';

import '../notifications/notification_poller.dart';
import '../notifications/schedule_notifications.dart';

late NotificationPoller _notificationPoller;

class GuidesPage extends StatefulWidget {
  @override
  State<GuidesPage> createState() => _GuidesPageState();
}

class _GuidesPageState extends State<GuidesPage> {
  List<GuidesData> guides = [];
  List<GuidesData> filteredGuides = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGuides();
    _notificationPoller = NotificationPoller(context);
  _notificationPoller.start();
  scheduleLocalReminders(context);
  }

@override
void dispose() {
  _notificationPoller.stop();
  super.dispose();
}

  Future<void> _loadGuides() async {
    final fetched = await ApiService().getGuides();
    print('Fetched spots: ${fetched.length}');
    setState(() {
      guides = fetched;
      filteredGuides = fetched;
      isLoading = false;
    });
  }

  void _filterGuides(String query) {
    if (query.isEmpty) {
      // Show all if query is empty
      setState(() {
        searchQuery = '';
        filteredGuides = guides;
      });
      return;
    }

    final filtered = guides.where((guide) {
      return guide.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredGuides = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guides'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          }),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyProfilePage())); 
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
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterGuides,
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),
            // List of Guides
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredGuides.isEmpty
                      ? Center(child: Text('No matching docking spots.'))
                      : ListView(
                          children: filteredGuides
                              .map((guide) => GuideItem(guide: guide))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
