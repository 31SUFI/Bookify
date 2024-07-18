import 'package:bookify/Homescreen/ContinueReading.dart';
import 'package:bookify/authentication/Login.dart';
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
  final Map<String, Map<String, String>> books = {
    'book1': {
      'title': 'The Mind of a Leader',
      'author': 'Kevin Anderson',
      'authorImage': 'assets/images/circleAvatar.jpeg',
      'image': 'assets/images/lor.jpeg',
    },
    'book2': {
      'title': 'Infinite Country',
      'author': 'Patricia Engel',
      'authorImage': 'assets/images/circleAvatar.jpeg',
      'image': 'assets/images/bookfinal.png',
    },
    'book3': {
      'title': 'The Domestic Goddess',
      'author': 'Sophie Kinsella',
      'authorImage': 'assets/images/circleAvatar.jpeg',
      'image': 'assets/images/HarryPotter.jpeg',
    },
    'book4': {
      'title': 'The Domestic Goddess',
      'author': 'Sophie Kinsella',
      'authorImage': 'assets/images/circleAvatar.jpeg',
      'image': 'assets/images/1984.jpeg',
    },
  };

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookify",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 174, 128, 1),
        // backgroundColor: Colors.transparent,
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
            icon: const Stack(
              children: [
                Icon(Icons.circle_rounded,
                    color: Colors.white), // Placeholder icon
                Positioned(
                  top: 0.0, // Adjust positioning as needed
                  left: 0.0,
                  child: CircleAvatar(
                    radius: 12.0, // Adjust radius based on desired size
                    backgroundColor:
                        Colors.white, // Background color for avatar
                    child: Icon(
                      Icons
                          .person_2_rounded, // Placeholder icon for avatar (optional)
                      color: Colors.black, // Color for avatar icon (optional)
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
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
                backgroundImage: AssetImage(
                    "assets/images/circleAvatar.jpeg"), // Replace with your profile image URL
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
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle settings tap
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
              AuthorsSection(books: books),
              const SizedBox(
                height: 24,
              ),
              ContinueReading(book: books['book1']!),
            ],
          ),
        ),
      ),
    );
  }
}
