import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSection extends StatefulWidget {
  @override
  _IntroSectionState createState() => _IntroSectionState();
}

class _IntroSectionState extends State<IntroSection> {
  String _userName = '';
  // String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ??
          'User'; // Default to 'User' if no name is found
      // _userEmail = prefs.getString('userEmail') ?? 'email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hello, ',
                style: GoogleFonts.merriweather(
                  color: Colors.black,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              TextSpan(
                text: '\t $_userName 👋',
                style: GoogleFonts.merriweather(
                    color: Colors.black,
                    fontSize: 18), // Remove fontWeight for unbold
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Find your favourite category!',
          style: GoogleFonts.merriweather(textStyle: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
