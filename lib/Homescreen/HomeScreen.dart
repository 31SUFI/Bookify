import 'package:bookify/BookUploading/BookDetailUploading.dart';
import 'package:bookify/Homescreen/ContinueReading.dart';
import 'package:bookify/authentication/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'intro_section.dart';
import 'categories_section.dart';
import 'trending_books_section.dart';
import 'authors_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseFirestore db;
  final List<Map<String, dynamic>> books = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataFromFireStore();
    });
  }

  getDataFromFireStore() async {
    await db.collection("BookDetails").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        books.add(doc.data());
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookify",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 174, 128, 1),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification button press (optional)
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
              currentAccountPicture: const CircleAvatar(
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
                // Handle profile tap
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
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate to the login screen after logout
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
              TrendingBooksSection(books: books),
              const SizedBox(height: 24),
              // Uncomment the following lines if these sections are needed
              // AuthorsSection(books: books),
              // const SizedBox(height: 24),
              // ContinueReading(book: books[0]), // Adjust this line to use an actual book from the list
            ],
          ),
        ),
      ),
    );
  }
}
