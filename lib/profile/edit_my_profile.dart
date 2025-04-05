import 'package:flutter/material.dart';
import 'my_profile.dart';
import '../user_data.dart';

class EditMyProfilePage extends StatefulWidget {
  const EditMyProfilePage({super.key});

  @override
  State<EditMyProfilePage> createState() => _EditMyProfilePageState();
}

String selectedValue = 'Sailor';

final tempUser = UserProfile(
  name: 'Kasia',
  surname: 'Kowalska',
  email: 'kkowalska@gmail.com',
  userType: 'Sailor',
  phone: '+48 123 456 789',
);

class _EditMyProfilePageState extends State<EditMyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () { 
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyProfilePage()));
            }
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(width: 10,),

                  Column(
                    children: [
                      const Text("Upload a profile picture", style: TextStyle(fontSize: 16),),

                      TextButton(
                        onPressed: (){},
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_box_rounded,
                              size: 20,
                              color: Colors.black,
                            ),

                            const Text("Add an image", style: TextStyle(fontSize: 16, color: Colors.black),),
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),
              

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
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: tempUser.name,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Surname"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: tempUser.surname,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Email"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: tempUser.email,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Phone Number"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: tempUser.phone,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MyProfilePage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.black, width: 1),
                            ),
                            child: const Text(
                              'Discard Changes',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        SizedBox(
                          width: 140,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        )



                    ],)
                    
                  ],
                ),
              ),    
            ],
          ),
        ),
      ),

    );
  }
}