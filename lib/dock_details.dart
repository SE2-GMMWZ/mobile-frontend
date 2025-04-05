import 'package:flutter/material.dart';

class DockDetailsPage extends StatefulWidget {
  final String title;
  final String description;

  DockDetailsPage({required this.title, required this.description});

  @override
  _DockDetailsPageState createState() => _DockDetailsPageState();
}

class _DockDetailsPageState extends State<DockDetailsPage> {
  DateTime? fromDate;
  DateTime? toDate;
  int pricePerDay = 888;

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

  int _calculateTotalPrice() {
    if (fromDate == null || toDate == null) return pricePerDay;
    int days = toDate!.difference(fromDate!).inDays;
    return days > 0 ? days * pricePerDay : pricePerDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.title),
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
            Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Location: Port Mikołajki 2", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 20),

            // Properties, Contact & Payment Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn("Properties", [
                  "• Boats up to 15m length",
                  "• On-site fueling station",
                  "• Free boat cleaning services",
                  "• 24/7 surveillance"
                ]),
                _infoColumn("Contact", [
                  "• Dockmaster Dave",
                  "• +48 999 999 90",
                  "• dockmaster.dave@sail.com"
                ]),
                _infoColumn("Payment Options", [
                  "• On site",
                  "• BLIK"
                ]),
              ],
            ),
            SizedBox(height: 20),

            // Comments
            Text("Comments:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _commentItem("Anna_Sailor87", "Loved this guide!"),
            _commentItem("Captain_Jack", "This guide inspired my trip!"),
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

            // Price & Booking Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_calculateTotalPrice()} PLN\n/1 Day(s)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Book", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Leave a Review
            _reviewSection()
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String title, List<String> details) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          ...details.map((detail) => Text(detail, style: TextStyle(fontSize: 14))),
        ],
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
        // Review Header
        Text("Leave review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("example text", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(height: 5),

        // Star Rating (Static for now)
        Row(
          children: List.generate(5, (index) => Icon(Icons.star_border, color: Colors.black, size: 28)),
        ),
        SizedBox(height: 10),

        // Review Input Box
        TextField(
          decoration: InputDecoration(
            hintText: "Write your review...",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 10),

        // Review Submission (Static User)
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[400],
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Reviewer name", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Date", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
