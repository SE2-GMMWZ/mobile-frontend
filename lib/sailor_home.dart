import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'dock_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? fromDate;
  DateTime? toDate;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book&Dock'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar & Filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),

            // Date Pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: _datePickerBox('From', fromDate),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: _datePickerBox('To', toDate),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // List of Docking Options
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Example number
                itemBuilder: (context, index) {
                  return _dockItem(index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePickerBox(String label, DateTime? date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[300], // Light grey background
      ),
      child: Row(
        children: [
          Text(
            date == null ? label : date.toString().split(' ')[0],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.calendar_today, color: Colors.black),
        ],
      ),
    );
  }

  Widget _dockItem(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
      padding: EdgeInsets.all(12.0), // Add padding for better spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
        leading: Icon(Icons.image, size: 50), // Placeholder for image
        title: Text('Dock $index', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Location $index\n30/11/2024 - 01/12/2024'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '999 PLN',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black), // Black border
                backgroundColor: Colors.grey[300], // Light grey background
              ),
              child: Text('View Details >', style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
          ),
        ]
      ),
      ),
    );
  }
}
