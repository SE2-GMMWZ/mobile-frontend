import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'services/api_service.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: {
        '/welcome': (context) => WelcomePage(),
      }, 
    );
  }
}
