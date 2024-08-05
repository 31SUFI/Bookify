import 'package:bookify/Homescreen/BookDetails.dart';
import 'package:bookify/Homescreen/detail_page.dart';
import 'package:bookify/Homescreen/shimmers_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingBooksSection extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> booksStream;

  TrendingBooksSection({required this.booksStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: booksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display shimmer effect while loading
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) => BookCardShimmer()).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No trending books available.'));
        } else {
          final books = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending Books',
                    style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                  ),
                  TextButton(
                    onPressed: () {
                      print(books); //for debugging
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(title: 'Trending Books', items: books),
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
                  children: books
                      .map((entry) => BookCard(
                          title: entry['bookName'],
                          author: entry['authorName'],
                          image: entry['image'],
                          category: entry['category'],
                          pdfUrl: entry['pdfUrl']))
                      .toList(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String image;
  final String category;
  final String pdfUrl;

  BookCard(
      {required this.title,
      required this.author,
      required this.image,
      required this.category,
      required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Navigating to BookDetailsScreen with:');
        print('Title: $title');
        print('Author: $author');
        print('Image: $image');
        print('Category: $category');
        print('pdfUrl: $pdfUrl');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: {
              'bookName': title,
              'authorName': author,
              'image': image,
              'category': category,
              'pdfUrl': pdfUrl,
            }),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              author,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
