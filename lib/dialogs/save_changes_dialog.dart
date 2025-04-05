import 'package:flutter/material.dart';

void showSaveChangesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ahoy!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: Text("Do you want to save your changes?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Not today")),
        ElevatedButton(onPressed: () {}, child: Text("Yes!")),
      ],
    ),
  );
}
