import 'package:bookify/Homescreen/HomeScreen.dart';
import 'package:bookify/authentication/Signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isChecked = false;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and the SlideTransition
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addStatusListener((status) {
        print('Animation Status: $status');
      });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // Slide from right
      end: const Offset(0, 0), // To the original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'back!',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign in to access your package history and get real-time updates on all your shipments',
                  style: TextStyle(
                    color: Color.fromARGB(255, 174, 128, 1),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.mail),
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 174, 128, 1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 164, 132, 45),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Or',
                    //style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 174, 128, 1),
                            ),
                          ),
                        )
                      : Image.asset(
                          'assets/images/google_logo.jpeg',
                          height: 40,
                        ),
                  label: const Text('Continue with Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 21, 21, 21),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                        color: Color.fromARGB(255, 174, 128, 1)),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          TextSpan(
                              text: "Create account",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
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

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save login state in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      // Sign-in successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in successful'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Error: ${e.message}';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the signed-in user
      final User? user = userCredential.user;

      if (user != null) {
        // Print the user's email to the terminal
        print('Signed in with Google: ${user.email}');

        // Save login state and email in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userEmail', user.email ?? '');

        // Sign-in successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In successful'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: ${e.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }
}
