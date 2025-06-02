import 'package:book_and_dock_mobile/dockOwner/my_dock_bookings.dart';
import 'package:book_and_dock_mobile/dockOwner/my_docks.dart';
import 'package:book_and_dock_mobile/services/user_storage.dart';
import 'package:flutter/material.dart';
import 'sailor/my_home.dart';
import 'sailor/guides_list.dart';
import 'sailor/my_bookings.dart';
import 'sailor/notifications.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final user = await UserStorage.currentUser;
    setState(() {
      _role = user?.role;
    });
  }
  
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
          if (_role == 'sailor') ...[
            _drawerItem(context, Icons.home, 'Home', HomePage()),
            _drawerItem(context, Icons.menu_book, 'Guides', GuidesPage()),
            _drawerItem(context, Icons.bookmark, 'My Bookings', MyBookingsPage()),
            _drawerItem(context, Icons.notifications, 'Notifications', NotificationsPage()),
          ] else if (_role == 'dock_owner') ...[
            _drawerItem(context, Icons.home, 'Home', MyDocksPage()),
            _drawerItem(context, Icons.bookmark, 'My Bookings', MyDockBookingsPage()),
            _drawerItem(context, Icons.notifications, 'Notifications', NotificationsPage()),
          ],
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
