import 'package:book_and_dock_mobile/data/bookings_data.dart';
import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:flutter/material.dart';

void viewMyDockDetailsBooking(BuildContext context, BookingsData booking, DockingSpotData? dock, UserProfile user) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        children: [
          Text(dock!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          Row(
            children: [
              Text(user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(width: 5,),
              Text(user.surname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
            ],
          ),  
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact (email): ${user.email}}'),
            SizedBox(height: 5),
            Text('Contact (phone): ${user.phone}}'),
            SizedBox(height: 10),
            Text(
              'Booking for ${booking.people} person/s\n'
              '${DateTime.parse(booking.startDate).toLocal().toString().split(' ')[0]} - '
              '${DateTime.parse(booking.endDate).toLocal().toString().split(' ')[0]}',
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close"),
        ),
      ],
    ),
  );
}