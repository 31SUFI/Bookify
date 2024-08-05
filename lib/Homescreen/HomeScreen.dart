import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_section.dart';
import 'categories_section.dart';
import 'trending_books_section.dart';
import 'authors_section.dart';
import 'ContinueReading.dart';
import 'package:bookify/AuthorRegistering/registerAuthor.dart';
import 'package:bookify/BookUploading/BookDetailUploading.dart';
import 'package:bookify/authentication/Login.dart';
import 'package:bookify/authentication/ProfileSection.dart';
import 'package:bookify/favoriteBooks.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late FirebaseFirestore db;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  final List<Category> categories = [
    Category(label: 'All', isSelected: true),
    Category(label: 'Nature'),
    Category(label: 'Psychology'),
    Category(label: 'Travel'),
    Category(label: 'Sci-fi'),
    Category(label: 'Technology'),
    Category(label: 'Fiction'),
    Category(label: 'Comedy'),
  ];

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;

    // Initialize the AnimationController and the SlideTransition
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        print('Animation Status: $status');
      });

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Slide from bottom
      end: Offset(0, 0), // To the original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> getBooksStream() {
    return db.collection("BookDetails").snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  Stream<List<Map<String, dynamic>>> getAuthorsStream() {
    return db.collection("AuthorDetails").snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookify",
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        ),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              _showDialogBox(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Muhammad Sufiyan"),
              accountEmail: Text("ksufi7350@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    AssetImage(" 'https://via.placeholder.com/150'"),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 174, 128, 1),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Register as an Author'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthorRegister()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Book'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookUpload()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteBooksPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);

                // Navigate back to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntroSection(),
                CategoriesSection(categories: categories),
                const SizedBox(height: 24),
                TrendingBooksSection(booksStream: getBooksStream()),
                const SizedBox(height: 24),
                AuthorsSection(authorStream: getAuthorsStream()),
                const SizedBox(height: 24),
                ContinueReading(
                  book: getBooksStream(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// notification dialog box
void _showDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enable Notifications'),
        content: Text('Do you want to receive latest updates about books?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print("Clicked Yes");
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
