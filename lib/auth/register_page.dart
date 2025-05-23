import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import '../services/api_service.dart';
import '../data/user_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedType = 'sailor';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final newUser = UserProfile(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedType,
    );

    final success = await ApiService().register(newUser, _passwordController.text.trim());

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),

                // Profile image upload row omitted for brevity

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
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
                      const Text("Name"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Best',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text("Surname"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          controller: _surnameController,
                          decoration: const InputDecoration(
                            hintText: 'sailor',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter surname' : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text("Email"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'sailor@gmail.com',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text("Password"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: '••••••••',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (v) => (v == null || v.length < 6) ? 'Password min 6 chars' : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text("User Type"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedType,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() { _selectedType = newValue!; });
                              },
                              items: <String>['sailor', 'dock_owner']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Text("Phone Number"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            hintText: '+48',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter phone' : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

