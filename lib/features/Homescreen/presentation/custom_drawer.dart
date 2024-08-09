import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookify/features/AuthorRegistering/presentation/registerAuthor.dart';
import 'package:bookify/features/BookUploading/presentation/BookDetailUploading.dart';
import 'package:bookify/features/authentication/presentation/Login.dart';
import 'package:bookify/features/authentication/presentation/ProfileSection.dart';
import 'package:bookify/features/Homescreen/presentation/favoriteBooks.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _userName = 'User';
  String _userEmail = 'example@example.com';
  String _profileImage =
      'https://via.placeholder.com/150'; // Default placeholder

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userFullName') ?? 'User';
      _userEmail = prefs.getString('userEmail') ?? 'example@example.com';

      // You can also fetch and store a custom profile image URL from SharedPreferences if needed
      _profileImage =
          prefs.getString('PhotoUrl') ?? 'https://via.placeholder.com/150';
      print('heelo heeelo help me${_profileImage}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userName),
            accountEmail: Text(_userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_profileImage),
            ),
            decoration: const BoxDecoration(
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
