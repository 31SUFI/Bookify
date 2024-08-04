import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookify/Homescreen/BookDetails.dart'; // Ensure favoriteBooks is accessible

class FavoriteBooksPage extends StatefulWidget {
  @override
  _FavoriteBooksPageState createState() => _FavoriteBooksPageState();
}

class _FavoriteBooksPageState extends State<FavoriteBooksPage> {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _notifierScroll = ValueNotifier(0.0);

  void _listener() {
    _notifierScroll.value = _pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_listener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();
    super.dispose();
  }

  void _removeBook(int index) {
    setState(() {
      favoriteBooks.removeAt(index); // Remove the book from the list
    });
  }

  void _showRemoveDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Book'),
          content: Text(
              'Are you sure you want to remove this book from your favorites?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeBook(index); // Remove the book
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookHeight = size.height * 0.45;
    final bookWidth = size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Favorite Books ❤',
          style: GoogleFonts.merriweather(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/images/Bg.png",
            fit: BoxFit.fill,
          )),
          PageView.builder(
            controller: _pageController,
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: bookHeight,
                            width: bookWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20,
                                  offset: Offset(5.0, 5.0),
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              _showRemoveDialog(
                                  context, index); // Show dialog on long press
                            },
                            child: Container(
                              height: bookHeight,
                              width: bookWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: NetworkImage(book['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 90),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['bookName'],
                          style: GoogleFonts.merriweather(
                              fontSize: 25,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "By ${book['authorName']}",
                          style: GoogleFonts.merriweather(
                              fontSize: 15, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
