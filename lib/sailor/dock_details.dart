import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:book_and_dock_mobile/dialogs/booking_complete.dart';
import '../data/docking_spot_data.dart';
import '../services/api_service.dart';
import '../data/reviews_data.dart';

const stripeSecretKey = 'sk_test_51RQ47u2fvPZJA4JMDXOynqvaYiyryioapNmI1BKD4FRJN6nllgd6a4WZrsFmrevqSbAEHC8TwomV7GO2jua5AF2m00igKzTzo0'; // To jest nielegalne, tak sie nie robi NIGDY (oprocz dzisiaj) 

void showBookingSummaryDialog(BuildContext context, Map<String, dynamic> bookingData) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Booking Summary"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookingData.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text("${entry.key}: ${entry.value}"),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          child: Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

class DockDetailsPage extends StatefulWidget {
  final DockingSpotData spot;
  final Future<UserProfile?> currentUser;

  const DockDetailsPage({super.key, required this.spot, required this.currentUser});

  @override
  _DockDetailsPageState createState() => _DockDetailsPageState();
}

class _DockDetailsPageState extends State<DockDetailsPage> {
  DateTime? fromDate;
  DateTime? toDate;
  int selectedPeople = 1;
  UserProfile? _currentUser;

  List<ReviewData> _reviews = [];
  bool _loadingreviews = true;

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
    _fetchReviews();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

 Future<void> _loadCurrentUser() async {
    final user = await UserStorage.currentUser;
    setState(() {
      _currentUser = user;
    });
  }
  
  Future<String> _createPaymentIntent(int amountInPLN) async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': (amountInPLN * 100).toString(),
        'currency': 'pln',
        'payment_method_types[]': 'card',
      },
    );

    final jsonResponse = json.decode(response.body);
    if (jsonResponse['client_secret'] != null) {
      return jsonResponse['client_secret'];
    } else {
      throw Exception('Stripe error: ${jsonResponse['error']['message']}');
    }
  }


  Map<String, UserProfile> _userProfiles = {};

Future<void> _fetchReviews() async {
  setState(() {
    _loadingreviews = true;
  });

  try {
    final reviews = await ApiService().getReviews(widget.spot.dock_id!);

    // Fetch user profiles for all unique reviewerIds
    final uniqueIds = reviews.map((r) => r.reviewerId).toSet();
    final userProfiles = <String, UserProfile>{};
    for (final id in uniqueIds) {
      final user = await ApiService().getUserById(id);
      if (user != null) userProfiles[id] = user;
    }

    setState(() {
      _reviews = reviews;
      _userProfiles = userProfiles;
      _loadingreviews = false;
    });
  } catch (e) {
    print('Fetch reviews error: $e');
    setState(() {
      _reviews = [];
      _loadingreviews = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load reviews'))
    );
  }
}

  double _calculateTotalPrice() {
    if (fromDate == null || toDate == null) return widget.spot.price_per_night;
    int days = toDate!.difference(fromDate!).inDays;
    return days > 0 ? days * widget.spot.price_per_night : widget.spot.price_per_night;
  }


 Future<void> _submitReview() async {
  // Validate input
  if (_selectedRating == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select a rating'))
    );
    return;
  }
  
  if (_reviewController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please write a comment'))
    );
    return;
  }

  // Get current user
  final user = await UserStorage.currentUser;
  
  if (user == null || user.id == null || user.id!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in'))
    );
    return;
  }

  try {
    final review = ReviewData(
      reviewId: '', // Let backend generate this
      reviewerId: user.id!,
      comment: _reviewController.text.trim(),
      dateOfReview: DateTime.now().toUtc().toIso8601String(),
      rating: _selectedRating,
      dockingSpotId: widget.spot.dock_id!,
    );

    print('Submitting review: ${review.toJson()}');

    final success = await ApiService().createReview(review);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!'))
      );
      
      // Clear the form
      _reviewController.clear();
      setState(() {
        _selectedRating = 0;
      });
      
      // Refresh reviews
      await _fetchReviews();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review. Please try again.'))
      );
    }
  } catch (e) {
    print('Submit review error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting review: $e'))
    );
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

            // reviews
            Text("reviews:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _loadingreviews
                ? Center(child: CircularProgressIndicator())
                : (_reviews.isEmpty
                    ? Text("No reviews yet.")
                    : Column(
                        children: _reviews
                            .map((r) => _reviewItem(r))
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
                  onPressed: () async {
                    final user = await UserStorage.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must be logged in')));
                      return;
                    }

                    if (fromDate == null || toDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select both start and end dates.')));
                      return;
                    }
                    if (fromDate!.isAfter(toDate!)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start date must be before end date.')));
                      return;
                    }
                    if (fromDate!.isBefore(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start date cannot be in the past.'),));
                      return;
                    }
                    
                    try {
                      final days = toDate!.difference(fromDate!).inDays;
                      final totalPrice = days * widget.spot.price_per_night + selectedPeople * widget.spot.price_per_person;

                      final clientSecret = await _createPaymentIntent((totalPrice * 1).toInt());


                      await Stripe.instance.initPaymentSheet(
                        paymentSheetParameters: SetupPaymentSheetParameters(
                          paymentIntentClientSecret: clientSecret,
                          merchantDisplayName: 'Book & Dock Dev',
                        ),
                      );

                      await Stripe.instance.presentPaymentSheet();

                      final bookingData = {
                        "dock_id": widget.spot.dock_id,
                        "start_date": fromDate!.toUtc().toIso8601String(),
                        "end_date": toDate!.toUtc().toIso8601String(),
                        "payment_method": "online",
                        "payment_status": "paid",
                        "people": selectedPeople,
                        "sailor_id": user.id,
                      };

                      print(jsonEncode(bookingData));
                      await ApiService().submitBooking(bookingData);

                      final notificationData = {
                        "message": "Your stay in ${widget.spot.name} will start tomorrow",
                        "user_id": widget.spot.owner_id,
                        "timestamp": DateTime.now().toUtc().toIso8601String(),
                        //"timestamp": fromDate!.toUtc().subtract(Duration(days: 1)).toIso8601String(),
                      };

                      await ApiService().createNotification(notificationData);

                      showBookingCompleteDialog(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
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


  Widget _reviewItem(ReviewData review) {
    final user = _userProfiles[review.reviewerId];
    final displayName = user != null
      ? "${user.name} ${user.surname}"
      : "User ${review.reviewerId}";
      final isMine = review.reviewerId == (_currentUser?.id ?? '');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded( // Wrap the text in Expanded to prevent overflow
              child: Text(
                displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              ),
              Spacer(),
              //SizedBox(width: 8), // Add some spacing
              Row(
                children: List.generate(5, (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                )),
              ),
              if (isMine) ...[
              IconButton(
                icon: Icon(Icons.edit, size: 18),
                onPressed: () => _showEditReviewDialog(review),
                tooltip: "Edit",
              ),
              IconButton(
                icon: Icon(Icons.delete, size: 18),
                onPressed: () => _deleteReview(review),
                tooltip: "Delete",
              ),
            ]
            ],
          ),
          SizedBox(height: 4),
          Text(
            DateTime.parse(review.dateOfReview).toLocal().toString().split('.')[0],
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          SizedBox(height: 8),
          Text(review.comment, style: TextStyle(fontSize: 14), softWrap: true, ),// Ensure text wraps properly),
        ],
      ),
    );
  }

void _showEditReviewDialog(ReviewData review) {
  final controller = TextEditingController(text: review.comment);
  int rating = review.rating;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Edit Review"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(5, (index) => IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                rating = index + 1;
                (context as Element).markNeedsBuild();
              },
            )),
          ),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(hintText: "Edit your review..."),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final updated = ReviewData(
              reviewId: review.reviewId,
              reviewerId: review.reviewerId,
              comment: controller.text,
              dateOfReview: DateTime.now().toUtc().toIso8601String(),
              rating: rating,
              dockingSpotId: review.dockingSpotId,
            );
            await ApiService().updateReview(review.reviewId, updated);
            Navigator.pop(context);
            _fetchReviews();
          },
          child: Text("Save"),
        ),
      ],
    ),
  );
}
Future<void> _deleteReview(ReviewData review) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete Review"),
      content: Text("Are you sure you want to delete this review?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
      ],
    ),
  );
  if (confirmed == true) {
    await ApiService().deleteReview(review.reviewId);
    _fetchReviews();
  }
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
