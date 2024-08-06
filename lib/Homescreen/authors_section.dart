import 'package:bookify/Homescreen/AuthorsDetailsPage.dart';
import 'package:bookify/Homescreen/shimmers_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthorsSection extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> authorStream;

  const AuthorsSection({super.key, required this.authorStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: authorStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display shimmer effect while loading
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  List.generate(5, (index) => AuthorCardShimmer()).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No authors available'));
        }

        final authorData = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Authors',
                  style: GoogleFonts.merriweather(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthorsDetailsPage(
                          authors: authorData,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: authorData.map((author) {
                  return AuthorCard(
                    name: author['authorName']!,
                    image: author['image']!,
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AuthorCard extends StatelessWidget {
  final String name;
  final String image;

  AuthorCard({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(image),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
