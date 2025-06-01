import 'package:flutter/material.dart';
import '../data/guides_data.dart';
import 'guide_details.dart';

class GuideItem extends StatelessWidget {
  final GuidesData guide;

  const GuideItem({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(guide.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(guide.content),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GuideDetailsPage(title: guide.title, description: guide.content),
            ),
          );
          },
          child: Text('Read more >'),
        ),
      ),
    );
  }
}
