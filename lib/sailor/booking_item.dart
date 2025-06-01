import 'package:book_and_dock_mobile/data/bookings_data.dart';
import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:flutter/material.dart';

class BookingItem extends StatelessWidget {
  final BookingsData booking;

  const BookingItem({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.image, size: 50),
              title: Text(booking.dockName ?? booking.dockId, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Booking for ${booking.people} person/s\n'
                '${DateTime.parse(booking.startDate).toLocal().toString().split(' ')[0]} - '
                '${DateTime.parse(booking.endDate).toLocal().toString().split(' ')[0]}',
              ),
              trailing: Text(
                '999 PLN', // replace with actual price if available
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text('Cancel Booking', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text('View Details >', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}