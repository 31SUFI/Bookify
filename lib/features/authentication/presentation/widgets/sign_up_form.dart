// sign_up_form.dart
import 'package:bookify/features/Homescreen/presentation/HomeScreen.dart';
import 'package:bookify/features/authentication/data/repos/sign_up_repository.dart';
import 'package:bookify/features/authentication/presentation/Login.dart';
import 'package:bookify/features/authentication/presentation/widgets/custom_button.dart(signup).dart';
import 'package:flutter/material.dart';
import 'package:bookify/features/authentication/presentation/widgets/custom_text_field(signup).dart';

import 'package:bookify/features/authentication/presentation/widgets/slide_transition_widget.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  final SignUpRepository _signUpRepository = SignUpRepository();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransitionWidget(
      begin: Offset(-1, 0), // From the left
      end: Offset.zero, // To the center
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text(
              'Create',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Account!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sign up to get started and enjoy our services',
              style: TextStyle(
                color: const Color.fromARGB(255, 174, 128, 1),
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              hintText: 'Enter your email',
              prefixIcon: Icons.mail,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') && !value.contains('.com')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              obscureText: !_isPasswordVisible,
              isPasswordField: true,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm your password',
              prefixIcon: Icons.lock,
              obscureText: !_isConfirmPasswordVisible,
              isPasswordField: true,
              toggleVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            CustomButton(
              text: 'Sign up',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signUpRepository
                      .signUpWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context,
                  )
                      .then((user) {
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    }
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Center(child: Text('Or')),
            SizedBox(height: 16),
            CustomButton(
              text: 'Continue as Guest',
              backgroundColor: Colors.white,
              textColor: Color.fromARGB(255, 164, 132, 45),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 164, 132, 45),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
