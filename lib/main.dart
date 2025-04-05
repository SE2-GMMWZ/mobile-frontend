import 'package:book_and_dock_mobile/sailor_home.dart';
import 'package:flutter/material.dart';
import 'deckOwner/my_docks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyDocksPage(),
    );
  }
}