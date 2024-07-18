import 'package:flutter/material.dart';
import 'detail_page.dart';

class AuthorsSection extends StatelessWidget {
  final Map<String, Map<String, String>> books;

  AuthorsSection({required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Authors',
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
                      title: 'Top Authors',
                      items: books.entries
                          .map((entry) => {
                                'author': entry.value['author']!,
                                'image': entry.value['authorImage']!
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
              return AuthorCard(
                name: book['author']!,
                image: book['authorImage']!,
              );
            }).toList(),
          ),
        ),
      ],
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
            backgroundImage: AssetImage(image),
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
