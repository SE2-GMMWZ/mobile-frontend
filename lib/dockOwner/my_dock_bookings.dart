import 'package:book_and_dock_mobile/data/bookings_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/sailor/booking_item.dart';
import 'package:book_and_dock_mobile/sailor/notifications.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../profile/my_profile.dart';
import '../services/api_service.dart';

class MyDockBookingsPage extends StatefulWidget {
  @override
  State<MyDockBookingsPage> createState() => _MyDockBookingsPageState();
}

class _MyDockBookingsPageState extends State<MyDockBookingsPage> {
  List<BookingsData> bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final fetched = await ApiService().getBookigs();

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