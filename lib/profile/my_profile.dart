import 'package:book_and_dock_mobile/sailor/my_home.dart';
import 'package:book_and_dock_mobile/services/api_service.dart';
import 'package:flutter/material.dart';

import 'edit_my_profile.dart';
import '../auth/sign_in_page.dart';
import '../sailor/my_bookings.dart';
import '../app_drawer.dart';
import '../data/user_data.dart';
import '../services/user_storage.dart';
import '../notifications/schedule_notifications.dart';
import '../notifications/notification_poller.dart';

late NotificationPoller _notificationPoller;


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Future<UserProfile?> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _notificationPoller = NotificationPoller(context);
  _notificationPoller.start();
  scheduleLocalReminders(context);
  }

  void _loadUser() {
    _currentUserFuture = UserStorage.currentUser;
  }

@override
void dispose() {
  _notificationPoller.stop();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              setState(() {
                _loadUser();
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: FutureBuilder<UserProfile?>(
          future: _currentUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: \${snapshot.error}'));
            }
            final currentUser = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          setState(() {
                            _loadUser();
                          });
                        },
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyBookingsPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black, width: 1),
                          ),
                          child: const Text(
                            'My Bookings',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField(label: 'Name', value: currentUser.name),
                        const SizedBox(height: 15),
                        _buildField(label: 'Surname', value: currentUser.surname),
                        const SizedBox(height: 15),
                        _buildField(label: 'Email', value: currentUser.email),
                        const SizedBox(height: 15),
                        _buildField(label: 'Phone Number', value: currentUser.phone),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditMyProfilePage(),
                                ),
                              );
                              setState(() {
                                _loadUser();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // Logout button at the bottom
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show logout confirmation dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    
                                    // Perform logout
                                    try {
                                      await ApiService().logout();
                                      Navigator.of(context).pop(); // Close dialog
                                      
                                      // Navigate to login screen and clear navigation stack
                                     Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const SignInPage(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                      // Show success message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Logged out successfully')),
                                      );
                                    } catch (e) {
                                      // Show error message if logout fails
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Logout failed: ${e.toString()}')),
                                      );
                                    }
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.red.shade900, width: 2),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({required String label, String? value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value ?? 'Unknown',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

