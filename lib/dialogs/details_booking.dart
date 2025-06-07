import 'package:book_and_dock_mobile/data/bookings_data.dart';
import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:flutter/material.dart';

void viewDetailsBooking(BuildContext context, BookingsData booking, DockingSpotData? dock) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        dock?.name ?? "Dock Details",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${dock?.description ?? "-"}'),
            SizedBox(height: 10),
            Text(
              'Booking for ${booking.people} person/s\n'
              '${DateTime.parse(booking.startDate).toLocal().toString().split(' ')[0]} - '
              '${DateTime.parse(booking.endDate).toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Available services: ${dock?.services ?? "-"}'),
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