import 'package:bookify/authentication/Login.dart';
import 'package:bookify/authentication/Signup.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 80), // Added space at the top

                // Text (Use a darker shade for better contrast)
                const Text(
                  'Greetings!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .black87, // Use a darker shade for better contrast
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Let\'s have a look.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 228, 221, 202),
                      ),
                    ),
                    Image.asset(
                      'assets/images/bookfinal.png',
                      width: 265,
                      height: 270,
                      //fit: BoxFit.cover,
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Sign In Button (Use a contrasting background color)
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal, // Use a contrasting color
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 11),
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Create an Account Button (Use a contrasting background color)
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 173, 131, 115), // Use a contrasting color
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 174, 128, 1),
                      shadowColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Need help with logging in?',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
