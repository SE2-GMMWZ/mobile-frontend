import 'package:book_and_dock_mobile/data/bookings_data.dart';
import 'package:book_and_dock_mobile/data/docking_spot_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/dialogs/details_mydock_booking.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:flutter/material.dart';


class MyDockBookingItem extends StatefulWidget {
  final BookingsData booking;
  final VoidCallback? onDeleted;

  const MyDockBookingItem({required this.booking, this.onDeleted});

  @override
  State<MyDockBookingItem> createState() => _MyDockBookingItemState();
}

class _MyDockBookingItemState extends State<MyDockBookingItem> {
  DockingSpotData? dock;
  UserProfile? sailorBook;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDock();
    _loadBooker();
  }

  Future<void> _loadDock() async {
    final result = await ApiService().getDockById(widget.booking.dockId);
    setState(() {
      dock = result;
      isLoading = false;
    });
  }

  Future<void> _loadBooker() async {
    final result = await ApiService().getUserById(widget.booking.sailorId);
    print("USER:\n${result}");

    setState(() {
      sailorBook = result;
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dock?.name ?? widget.booking.dockId, style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(sailorBook?.name ?? 'Unknown Sailor', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 5,),
                      Text(sailorBook?.surname ?? 'Unknown Sailor', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                  
                ],
              ),
              subtitle: Text(
                'Booking for ${widget.booking.people} person/s\n'
                '${DateTime.parse(widget.booking.startDate).toLocal().toString().split(' ')[0]} - '
                '${DateTime.parse(widget.booking.endDate).toLocal().toString().split(' ')[0]}',
              ),
              trailing: isLoading
                ? CircularProgressIndicator()
                : Text(
                    '${dock != null ? int.parse(widget.booking.people) * dock!.price_per_night : '?'} PLN',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Delete Booking"),
                          content: Text("Are you sure you want to delete this booking?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Delete")),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await ApiService().deleteBooking(widget.booking.bookingId ?? '');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking deleted')));
                          if (widget.onDeleted != null) widget.onDeleted!();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete booking')));
                        }
                      }
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
                    onPressed: () {
                      viewMyDockDetailsBooking(context, widget.booking, dock, sailorBook!);
                    },
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