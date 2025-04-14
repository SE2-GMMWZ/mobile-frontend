import 'package:book_and_dock_mobile/sailor/my_home.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import '../sailor/my_home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign In",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),

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
                      const Text("Email"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text("Password"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,
                               MaterialPageRoute(builder: (context) => HomePage())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Don't have an account yet?",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    child: const Text(
                      'Register',
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