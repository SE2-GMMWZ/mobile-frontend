import 'package:book_and_dock_mobile/data/bookings_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'booking_item.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import 'notifications.dart';
import '../profile/my_profile.dart';
import '../services/api_service.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  List<BookingsData> bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final fetched = await ApiService().getBookings();

    print('Filtered bookings: ${fetched.length}');

    setState(() {
      bookings = fetched;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        actions: [
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()));
              }),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()));
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: bookings.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return BookingItem(booking: bookings[index], onDeleted: () async{ await _loadBookings();},);
                },
              ),
      ),
    );
  }
}