import 'package:flutter/material.dart';

class GuideDetailsPage extends StatelessWidget {
  final String title;
  final String description;

  GuideDetailsPage({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
