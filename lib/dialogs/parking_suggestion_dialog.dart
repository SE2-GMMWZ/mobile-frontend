import 'package:flutter/material.dart';

void showParkingSuggestionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Hey!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: Text("Since you’ve rented the office, maybe you'll be interested in renting a parking space nearby?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Not today")),
        ElevatedButton(onPressed: () {}, child: Text("Yes!")),
      ],
    ),
  );
}
