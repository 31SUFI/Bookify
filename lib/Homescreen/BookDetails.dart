// Add this import (if you haven't already)
import 'package:bookify/read%20now.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(book['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: book['title'],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    book['image'],
                    height: 300, // Adjust height as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                book['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'By ${book['author']}',
                style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
              ),
              SizedBox(height: 16),
              Text(
                'FREE',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('DOWNLOAD'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadNow(
                            book: book,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent),
                    child: Text('READ NOW'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Divider(),
              Text(
                'Rate this book',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 30, shadows: [
                    Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(0, 0))
                  ]),
                  Icon(Icons.star, color: Colors.yellow, size: 30, shadows: [
                    Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(0, 0))
                  ]),
                  Icon(Icons.star, color: Colors.yellow, size: 30, shadows: [
                    Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(0, 0))
                  ]),
                  Icon(Icons.star, color: Colors.yellow, size: 30, shadows: [
                    Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(0, 0))
                  ]),
                  Icon(Icons.star, color: Colors.white, size: 30, shadows: [
                    Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(0, 0))
                  ]),
                ],
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Write a review',
                    selectionColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'MORE INFO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Category:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Chip(label: Text('Detective')),
                  SizedBox(width: 8),
                  Chip(label: Text('Mystery')),
                  SizedBox(width: 8),
                  Chip(label: Text('Fantasy')),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Publisher:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Chip(label: Text('My library')),
                ],
              ),
              Row(
                children: [
                  Text(
                    'ISBN:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 35),
                  Chip(label: Text('1496782937')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
