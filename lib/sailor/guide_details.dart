import 'package:book_and_dock_mobile/data/guides_data.dart';
import 'package:book_and_dock_mobile/data/user_data.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:flutter/material.dart';

class GuideDetailsPage extends StatefulWidget {
  final GuidesData guide;

  const GuideDetailsPage({required this.guide});

  @override
  State<GuideDetailsPage> createState() => _GuideDetailsPageState();
}

class _GuideDetailsPageState extends State<GuideDetailsPage> {
  UserProfile? author;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthor();
  }

  Future<void> _loadAuthor() async {
    final result = await ApiService().getAuthorById(widget.guide.authorId);

    setState(() {
      author = result;
      isLoading = false;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.guide.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(widget.guide.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Date of publication: ${DateTime.parse(widget.guide.publicationDate).toLocal().toString().split(' ')[0]}'),   
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Written by ${author?.name} ${author?.surname}'),   
            ),
            SizedBox(height: 10),
            Text(widget.guide.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child:ElevatedButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("Back"),
              ),
            ),   
          ],
        ),
      ),
    );
  }
}
