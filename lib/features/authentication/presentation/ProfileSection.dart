import 'dart:io';
import 'package:bookify/features/Homescreen/presentation/HomeScreen.dart';
import 'package:bookify/features/authentication/presentation/Login.dart';
import 'package:bookify/core/databaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _dbservice = AuthDatabaseService();
  late FirebaseFirestore db;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? profileStream = null;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // Retrieve the stored email from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail');

    if (userEmail != null) {
      // Query Firestore for the user profile using the email
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
          .collection("ProfileDetails")
          .where("email", isEqualTo: userEmail)
          .get();

      // Iterate over the documents to find the relevant profile
      DocumentSnapshot<Map<String, dynamic>>? userProfileDoc;
      for (var doc in querySnapshot.docs) {
        if (doc['email'] == userEmail) {
          userProfileDoc = doc;
          break;
        }
      }

      // If the relevant profile is found, set up the stream
      if (userProfileDoc != null) {
        profileStream =
            db.collection("ProfileDetails").doc(userProfileDoc.id).snapshots();

        setState(() {});
      } else {
        // Handle case where no matching profile is found
        print('No profile found for the user');
      }
    }
  }

  Future<void> updateProfileInFirestore(ProfilePacket profilePacket) async {
    if (userEmail != null) {
      await db
          .collection("ProfileDetails")
          .where("email", isEqualTo: userEmail)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.first.reference.update(profilePacket.toMap());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditProfileBottomSheet(context);
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileStream != null
          ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: profileStream!,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No Profile Data'));
                }

                final userProfile = snapshot.data!.data()!;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                imageUrl: userProfile['image'] ??
                                    'https://via.placeholder.com/150',
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'profileImageHero',
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                userProfile['image'] ??
                                    'https://via.placeholder.com/150'),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        userProfile['name'] ?? 'No Name',
                        style: GoogleFonts.merriweather(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userProfile['email'] ?? 'No Email',
                        style: GoogleFonts.merriweather(
                            textStyle: TextStyle(
                                fontSize: 13, fontStyle: FontStyle.italic)),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            ProfileMenuItem(
                              icon: Icons.privacy_tip_outlined,
                              text: 'Privacy',
                              onTap: () {
                                // Add navigation logic here
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.history_outlined,
                              text: 'Purchase History',
                              onTap: () {
                                // Add navigation logic here
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.help_outlined,
                              text: 'Help & Support',
                              onTap: () {
                                // Add navigation logic here
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.settings_outlined,
                              text: 'Settings',
                              onTap: () {
                                // Add navigation logic here
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.person_add_outlined,
                              text: 'Invite a Friend',
                              onTap: () {
                                // Add navigation logic here
                              },
                            ),
                            ProfileMenuItem(
                              icon: Icons.logout_outlined,
                              text: 'Logout',
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isLoggedIn', false);

                                // Navigate back to the login screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: SizedBox(
                width: 100, // Adjust width as needed
                // Adjust height as needed
                child: LinearProgressIndicator(
                  color: Color.fromARGB(255, 174, 128, 1),
                ),
              ),
            ),
    );
  }

  void _showEditProfileBottomSheet(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    XFile? _profileImage;
    String profileImageUrl = '';

    final ImagePicker _picker = ImagePicker();

    Future<void> _pickImage() async {
      try {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile == null) {
          return;
        }
        _profileImage = pickedFile;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child("ProfileImages");
        Reference referenceImageToUpload = referenceDirImages.child(fileName);

        await referenceImageToUpload.putFile(File(pickedFile.path));
        profileImageUrl = await referenceImageToUpload.getDownloadURL();
        print('Profile Image URL: $profileImageUrl');
      } catch (e) {
        print('Error: $e');
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage == null
                          ? NetworkImage(profileImageUrl.isEmpty
                              ? 'https://via.placeholder.com/150'
                              : profileImageUrl)
                          : FileImage(File(_profileImage!.path))
                              as ImageProvider,
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final profilePacket = ProfilePacket(
                        name: _nameController.text,
                        email: _emailController.text,
                        image: profileImageUrl,
                      );
                      await updateProfileInFirestore(profilePacket);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Profile Updated Successfully'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Hero(
          tag: 'profileImageHero',
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.87,
        height: 55,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 229, 224, 224),
          borderRadius: BorderRadius.circular(40),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}

class ProfilePacket {
  final String name;
  final String email;
  final String image;

  ProfilePacket({
    required this.name,
    required this.email,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
        "name": this.name,
        "email": this.email,
        "image": this.image,
      };
}
