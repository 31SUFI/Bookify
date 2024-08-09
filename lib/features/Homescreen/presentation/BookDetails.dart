import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookify/features/Homescreen/presentation/read%20now.dart'; // Adjust this import path as needed
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

// Declare this in a separate file later (e.g., globals.dart)
List<Map<String, dynamic>> favoriteBooks = [];
Map<String, dynamic>? currentlyReadingBook;

class BookDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  BookDetailsScreen({required this.book});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the book is already in the favorites
    isFavorite = favoriteBooks.contains(widget.book);
  }

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        favoriteBooks.remove(widget.book);
      } else {
        favoriteBooks.add(widget.book);
      }
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: toggleFavorite,
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.book['bookName'],
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.book['bookName'],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.book['image'],
                    height: 300, // Adjust height as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.book['bookName'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'By ${widget.book['authorName']}',
                style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
              ),
              SizedBox(height: 16),
              Text(
                '${widget.book['category']}',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _downloadFile(widget.book['pdfUrl'],
                          '${widget.book['bookName']}.pdf', context);
                    },
                    child: Text('DOWNLOAD'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Save the current book details for continue reading
                      currentlyReadingBook = widget.book;
                      print('Continuing reading: $currentlyReadingBook');

                      print('PdfUrl is: ${widget.book['pdfUrl']}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadNow(
                            pdfUrl: widget.book['pdfUrl'], // Pass the PDF URL
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
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

  Future<void> _downloadFile(
      String url, String fileName, BuildContext context) async {
    try {
      // Get the directory to store the file
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // Create a specific folder
      final folderName = 'DownloadedBooks';
      final folderPath = '$path/$folderName';

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      // Download the file
      final response = await http.get(Uri.parse(url));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Save the file in the specific folder
        final file = File('$folderPath/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        // Show a snackbar or toast to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $folderPath/$fileName')),
        );
      } else {
        // Handle the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download file')),
        );
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }
}
