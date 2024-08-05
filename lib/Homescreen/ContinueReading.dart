import 'package:bookify/Homescreen/shimmers_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContinueReading extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> book;

  const ContinueReading({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: book,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display shimmer effect while loading
              return ContinueReadingShimmer();
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final firstBook = snapshot.data![0]; // Get the first book

              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        Color.fromARGB(255, 240, 226, 213), // Background color
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        firstBook['image']!,
                        height: 60,
                        width: 40,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstBook['bookName']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            firstBook['authorName']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(
                                  255, 138, 102, 89), // Text color
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
                                "4.6",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(
                                      255, 138, 102, 89), // Text color
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
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Text('No data available');
            }
          },
        ),
      ],
    );
  }
}
