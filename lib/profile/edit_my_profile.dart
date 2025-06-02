import 'package:flutter/material.dart';
import 'my_profile.dart';
import '../data/user_data.dart';
import '../services/user_storage.dart';
import '../services/api_service.dart';

class EditMyProfilePage extends StatefulWidget {
  const EditMyProfilePage({super.key});

  @override
  State<EditMyProfilePage> createState() => _EditMyProfilePageState();
}

class _EditMyProfilePageState extends State<EditMyProfilePage> {
  late Future<UserProfile?> _currentUserFuture;
  UserProfile? _currentUser;

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = UserStorage.currentUser;
    _currentUserFuture.then((user) {
      if (user != null) {
        setState(() {
          _currentUser = user;
          _populateFields(user);
        });
      }
    });
  }


  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(UserProfile user) {
    _currentUser = user;
    _nameController.text = user.name;
    _surnameController.text = user.surname;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
  }

  Future<void> _saveChanges() async {
    if (_isSaving || _currentUser == null) return;
    setState(() => _isSaving = true);

    final updatedUser = UserProfile(
      id: _currentUser!.id,
      role: _currentUser!.role,
      name: _nameController.text,
      surname: _surnameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );

    final api = ApiService();
    final success = await api.updateUser(updatedUser);
    if (success) {
      await api.getUser();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<UserProfile?>(
          future: _currentUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text('Error: ${snapshot.error ?? 'No user found'}'),
              );
            }
            final currentUser = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
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
                        const Text('Name'),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Text('Surname'),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _surnameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Text('Email'),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Text('Phone Number'),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                                child: const Text('Discard Changes', style: TextStyle(fontSize: 13)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.black, width: 2),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Save Changes', style: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

