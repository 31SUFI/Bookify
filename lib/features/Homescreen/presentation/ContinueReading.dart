// continue_reading.dart
import 'package:bookify/features/Homescreen/presentation/BookDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContinueReading extends StatelessWidget {
  const ContinueReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentlyReadingBook == null) {
      return Text('No book is currently being read.');
    }

    final book = currentlyReadingBook!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Continue Reading",
            style: GoogleFonts.merriweather(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromARGB(255, 240, 226, 213),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  book['image']!,
                  height: 60,
                  width: 40,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['bookName']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      book['authorName']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 138, 102, 89),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "4.6", // Adjust or fetch dynamically
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 138, 102, 89),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
