import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookify/AuthorRegistering/registerAuthor.dart';
import 'package:bookify/BookUploading/BookDetailUploading.dart';
import 'package:bookify/authentication/Login.dart';
import 'package:bookify/authentication/ProfileSection.dart';
import 'package:bookify/favoriteBooks.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Muhammad Sufiyan"),
            accountEmail: Text("ksufi7350@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(" 'https://via.placeholder.com/150'"),
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
    );
  }
}
