import 'package:flutter/material.dart';
import 'package:book_and_dock_mobile/sailor/my_bookings.dart'; 


void showBookingCompleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Yay your booking is complete!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: Text("[Booking summary]"),
      actions: [
        ElevatedButton(onPressed: () {
  Navigator.of(context).pop(); // Close the dialog first
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => MyBookingsPage()), // <-- class name here
  );
}, child: Text("Manage your bookings")),
      ],
    ),
  );
}
