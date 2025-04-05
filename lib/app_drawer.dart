import 'package:flutter/material.dart';
import 'sailor/sailor_home.dart';
import 'sailor/sailor_guides_list.dart';
import 'sailor/sailor_my_bookings.dart';
import 'sailor/sailor_notifications.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(context, Icons.home, 'Home', HomePage()),
          _drawerItem(context, Icons.menu_book, 'Guides', GuidesPage()),
          _drawerItem(context, Icons.bookmark, 'My Bookings', MyBookingsPage()),
          _drawerItem(context, Icons.notifications, 'Notifications', NotificationsPage()),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
