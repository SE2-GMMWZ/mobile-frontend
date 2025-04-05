import 'package:flutter/material.dart';

void showPublishDockDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ahoy!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: Text("Are you sure you want to publish your Dock so that sailors can book it?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Not today")),
        ElevatedButton(onPressed: () {}, child: Text("Yes!")),
      ],
    ),
  );
}
