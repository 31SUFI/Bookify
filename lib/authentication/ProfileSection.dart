import 'dart:io';
import 'package:bookify/Homescreen/HomeScreen.dart';
import 'package:bookify/databaseService.dart';
import 'package:bookify/favoriteBooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _dbservice = DatabaseService();
  late FirebaseFirestore db;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    // Replace 'userProfileDocId' with the actual document ID
    profileStream =
        db.collection("ProfileDetails").doc("2A7hm7vZ7OFpBLLCHVcq").snapshots();
  }

  Future<void> updateProfileInFirestore(ProfilePacket profilePacket) async {
    await db
        .collection("ProfileDetails")
        .doc("2A7hm7vZ7OFpBLLCHVcq")
        .update(profilePacket.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: profileStream,
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userProfile['image'] ??
                        'https://via.placeholder.com/150'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userProfile['name'] ?? 'No Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    userProfile['email'] ?? 'No Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  // SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Add upgrade logic here
                  //   },
                  //   child: Text('Upgrade to PRO'),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.orange,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 32),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip,
                    text: 'Privacy',
                    onTap: () {
                      // Add navigation logic here
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.help,
                    text: 'Help & Support',
                    onTap: () {
                      // Add navigation logic here
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    onTap: () {
                      // Add navigation logic here
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
                  SizedBox(height: 16),
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ListTile(
            leading: Icon(icon),
            title: Text(text),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: onTap,
          ),
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
