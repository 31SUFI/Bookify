import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello Sufi 👋',
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SizedBox(height: 8),
        Text(
          'Find your favourite category !',
          style: GoogleFonts.merriweather(textStyle: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
