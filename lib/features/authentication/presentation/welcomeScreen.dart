import 'package:bookify/features/Homescreen/presentation/HomeScreen.dart';
import 'package:bookify/features/authentication/presentation/Login.dart';
import 'package:bookify/features/authentication/presentation/Signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 100, // Adjust width as needed
                // Adjust height as needed
                child: LinearProgressIndicator(
                  color: Color.fromARGB(255, 174, 128, 1),
                ),
              ),
            ),
          );
        } else if (snapshot.data == true) {
          return HomeScreen();
        } else {
          return WelcomeScreen();
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Slide from bottom
      end: Offset(0, 0), // To the original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
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
                      color: Colors.black87,
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
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Sign In Button (Use a contrasting background color)
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
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
                      color: const Color.fromARGB(255, 173, 131, 115),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
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
      ),
    );
  }
}
