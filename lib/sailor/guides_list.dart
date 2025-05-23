import 'package:flutter/material.dart';
import '../app_drawer.dart';
import 'guide_details.dart';
import 'notifications.dart';
import '../profile/my_profile.dart';
import '../models/guides_data.dart';
import '../services/api_service.dart';

class GuidesPage extends StatefulWidget {
  @override
  State<GuidesPage> createState() => _GuidesPageState();
}

class _GuidesPageState extends State<GuidesPage> {

final ApiService _guidesService = ApiService();
  List<Guide> _guides = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGuides();
  }

  Future<void> _fetchGuides() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final guides = await _guidesService.getGuides();
      
      setState(() {
        _guides = guides;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load guides. Please try again.';
        _isLoading = false;
      });
      print('Error fetching guides: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guides'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
          }),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyProfilePage())); 
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
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
            // List of Guides
            Expanded(
              child: _buildGuidesList(),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildGuidesList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchGuides,
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_guides.isEmpty) {
      return Center(child: Text('No guides available'));
    }

    return ListView.builder(
      itemCount: _guides.length,
      itemBuilder: (context, index) {
        final guide = _guides[index];
        return _guideItem(guide, context);
      },
    );
  }

  Widget _guideItem(Guide guide, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: guide.imageUrl != null && guide.imageUrl!.isNotEmpty
            ? Image.network(
                guide.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image, size: 50);
                },
              )
            : Icon(Icons.image, size: 50),
        title: Text(guide.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(guide.description),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailsPage(
                  guideId: guide.id,
                  title: guide.title,
                  description: guide.description,
                ),
              ),
            );
          },
          child: Text('Read more >'),
        ),
      ),
    );
  }
}
