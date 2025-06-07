import 'package:flutter/material.dart';

void showDockVisibleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Yay your Dock is now visible for Sailors!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: Text("[Your Docks summary]"),
      actions: [
        ElevatedButton(onPressed: () {}, child: Text("Manage your Docks")),
      ],
    ),
  );
}
