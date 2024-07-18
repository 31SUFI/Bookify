import 'package:bookify/Homescreen/BookDetails.dart';
import 'package:bookify/Homescreen/detail_page.dart';
import 'package:flutter/material.dart';

class TrendingBooksSection extends StatelessWidget {
  final Map<String, Map<String, String>> books;

  TrendingBooksSection({required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending Books',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      title: 'Trending Books',
                      items: books.entries
                          .map((entry) => {
                                'title': entry.value['title']!,
                                'author': entry.value['author']!,
                                'image': entry.value['image']!,
                              })
                          .toList(),
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
            children: books.entries.map((entry) {
              final book = entry.value;
              return BookCard(
                title: book['title']!,
                author: book['author']!,
                image: book['image']!,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String image;

  BookCard({required this.title, required this.author, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: {
              'title': title,
              'author': author,
              'image': image,
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
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
