import 'package:flutter/material.dart';

void showBookingCompleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Yay your booking is complete!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: Text("[Booking summary]"),
      actions: [
        ElevatedButton(onPressed: () {}, child: Text("Manage your bookings")),
      ],
    ),
  );
}
