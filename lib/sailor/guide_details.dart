import 'package:flutter/material.dart';
import '../models/guides_data.dart';
import '../services/api_service.dart';

class GuideDetailsPage extends StatefulWidget {
  final String guideId;
  final String title;
  final String description;

  GuideDetailsPage({
    required this.guideId,
    required this.title,
    required this.description,
  });

  @override
  _GuideDetailsPageState createState() => _GuideDetailsPageState();
}

class _GuideDetailsPageState extends State<GuideDetailsPage> {
  final ApiService _guidesService = ApiService();
  Guide? _guide;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize with the data we already have
    _guide = Guide(
      id: widget.guideId,
      title: widget.title,
      description: widget.description,
    );
    
    // Then fetch the complete details from the backend
    _fetchGuideDetails();
  }

  Future<void> _fetchGuideDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final guideDetails = await _guidesService.getGuideById(widget.guideId);
      
      if (guideDetails != null) {
        setState(() {
          _guide = guideDetails;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Could not load guide details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load guide details. Please try again.';
        _isLoading = false;
      });
      print('Error fetching guide details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_guide?.title ?? '')),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
                  ),
                  
                if (_guide?.imageUrl != null && _guide!.imageUrl!.isNotEmpty)
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      _guide!.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.image, size: 100));
                      },
                    ),
                  ),
                  
                SizedBox(height: 20),
                Text(
                  _guide?.title ?? widget.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                ),
                
                SizedBox(height: 10),
                Text(
                  _guide?.description ?? widget.description,
                  style: TextStyle(fontSize: 16)
                ),
                
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