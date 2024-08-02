import 'package:bookify/AuthorRegistering/registerAuthor.dart';
import 'package:bookify/BookUploading/BookDetailUploading.dart';
import 'package:bookify/Homescreen/ContinueReading.dart';
import 'package:bookify/Homescreen/authors_section.dart';
import 'package:bookify/authentication/Login.dart';
import 'package:bookify/authentication/ProfileSection.dart';
import 'package:bookify/favoriteBooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'intro_section.dart';
import 'categories_section.dart';
import 'trending_books_section.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseFirestore db;

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
                backgroundImage: AssetImage("assets/images/circleAvatar.jpeg"),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 174, 128, 1),
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
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
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
              AuthorsSection(authorStream: getAuthorsStream()), // Update here
              const SizedBox(height: 24),
              ContinueReading(
                  book:
                      getBooksStream()), // Adjust this line to use an actual book from the list
            ],
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
        content: Text('Do you want to recieve latest updates about books?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print("Cliked in yes");
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
