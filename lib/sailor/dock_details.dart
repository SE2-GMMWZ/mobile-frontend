import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_and_dock_mobile/dialogs/booking_complete_dialog.dart';
import '../data/docking_spot_data.dart';
import '../services/api_service.dart';
import '../data/comments_data.dart';
import '../data/reviews_data.dart';

class DockDetailsPage extends StatefulWidget {
  final DockingSpotData spot;

  const DockDetailsPage({super.key, required this.spot});

  @override
  _DockDetailsPageState createState() => _DockDetailsPageState();
}

class _DockDetailsPageState extends State<DockDetailsPage> {
  DateTime? fromDate;
  DateTime? toDate;
  int selectedPeople = 1;

  List<CommentData> _comments = [];
  bool _loadingComments = true;

  TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

 @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    setState(() {
      _loadingComments = true;
    });
    final comments = await ApiService().getComments();
    setState(() {
      _comments = comments.where((c) => c.guideId == widget.spot.dock_id).toList();
      _loadingComments = false;
    });
  }

  void _submitBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final sailorId = prefs.getString('sailor_id') ?? '';

    if (sailorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }

    final bookingData = {
      "dock_id": widget.spot.dock_id,
      "start_date": fromDate,
      "end_date": toDate,
      "payment_method": "card",
      "payment_status": "not",
      "people": selectedPeople,
      "sailor_id": sailorId,
    };

    try {
      await ApiService().submitBooking(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking submitted')));
      showBookingCompleteDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }


  double _calculateTotalPrice() {
    if (fromDate == null || toDate == null) return widget.spot.price_per_night;
    int days = toDate!.difference(fromDate!).inDays;
    return days > 0 ? days * widget.spot.price_per_night : widget.spot.price_per_night;
  }


Future<void> _submitReview() async {
  final prefs = await SharedPreferences.getInstance();
  final reviewerId = prefs.getString('sailor_id') ?? '';
  if (reviewerId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
    return;
  }

  final review = ReviewData(
    reviewId: '', // Let backend generate or use a UUID if needed
    reviewerId: reviewerId,
    comment: _reviewController.text,
    dateOfReview: DateTime.now().toIso8601String(),
    rating: _selectedRating,
  );

  final success = await ApiService().createReview(review);
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review submitted!')));
    _reviewController.clear();
    setState(() {
      _selectedRating = 0;
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit review')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.spot.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dock Image Placeholder
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(child: Icon(Icons.image, size: 100, color: Colors.grey[600])),
            ),
            SizedBox(height: 10),

            // Title & Location
            Text(widget.spot.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.spot.town, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 10),

            // Properties, Contact & Payment Options
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(widget.spot.description, style: TextStyle(fontSize: 16)),
                    ],
                  )
                ),

                
                Row(children: [
                  Text("Services:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Text(widget.spot.services, style: TextStyle(fontSize: 16)),
                ],),
                
                Row(children: [
                  Text("Price for services:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Text(widget.spot.services_pricing.toString(), style: TextStyle(fontSize: 16)),
                ],),
              ],
            ),
            SizedBox(height: 20),

            // Comments
            Text("Comments:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _loadingComments
                ? Center(child: CircularProgressIndicator())
                : (_comments.isEmpty
                    ? Text("No comments yet.")
                    : Column(
                        children: _comments
                            .map((c) => _commentItem(c.userId, c.content))
                            .toList(),
                      )),
            SizedBox(height: 20),

            // Date Pickers & Price
            Row(
              children: [
                Expanded(child: _datePickerBox("From", fromDate, true)),
                SizedBox(width: 10),
                Expanded(child: _datePickerBox("To", toDate, false)),
              ],
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                label: Text("Number Of People", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // lower height
              ),
              value: selectedPeople,
              style: TextStyle(fontSize: 14, color: Colors.black),
              dropdownColor: Colors.grey[200],
              items: List.generate(10, (index) => index + 1)
                  .map((num) => DropdownMenuItem(value: num, child: Text(num.toString())))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPeople = value;
                  });
                }
              },
            ),

            SizedBox(height: 10),

            // Price & Booking Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("${widget.spot.price_per_night} PLN/1 Day",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text("${widget.spot.price_per_person} PLN/ person",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                
                ElevatedButton(
                  onPressed: () {
                    _submitBooking();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Book", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),

            _reviewSection()
          ],
        ),
      ),
    );
  }

  Widget _commentItem(String user, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(text: "$user: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: comment),
          ],
        ),
      ),
    );
  }

  Widget _datePickerBox(String label, DateTime? date, bool isFrom) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFrom),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            Text(date == null ? label : "${date.day}/${date.month}/${date.year}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.calendar_today, color: Colors.black),
          ],
        ),
      ),
    );
  }

   Widget _reviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Leave review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          children: List.generate(5, (index) => IconButton(
            icon: Icon(
              index < _selectedRating ? Icons.star : Icons.star_border,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _selectedRating = index + 1;
              });
            },
          )),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _reviewController,
          decoration: InputDecoration(
            hintText: "Write your review...",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _selectedRating > 0 && _reviewController.text.isNotEmpty
              ? _submitReview
              : null,
          child: Text("Submit Review"),
        ),
      ],
    );
  }
}
