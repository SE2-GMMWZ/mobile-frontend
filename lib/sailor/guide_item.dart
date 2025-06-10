import 'package:flutter/material.dart';
import '../data/guides_data.dart';
import 'guide_details.dart';

class GuideItem extends StatelessWidget {
  final GuidesData guide;

  const GuideItem({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final preview = guide.content.trim().split(' ').take(7).join(' ') + '...';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(guide.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(preview),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailsPage(guide: guide),
              ),
            );
          },
          child: Text('Read More >'),
        ),
      ),
    );
  }
}