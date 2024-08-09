import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthorRegister extends StatefulWidget {
  @override
  _AuthorRegisterState createState() => _AuthorRegisterState();
}

class _AuthorRegisterState extends State<AuthorRegister> {
  final _dbservice = DatabaseService();
  final TextEditingController _authorController = TextEditingController();
  XFile? _authorImage;
  String imageUrl = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }
      setState(() {
        _authorImage = pickedFile;
      });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child("AuthorImages");
      Reference referenceImageToUpload = referenceDirImages.child(fileName);

      await referenceImageToUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image URL: $imageUrl');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Author Profile"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 174, 128, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register Author Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Make your author profile accessible to the World!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  height: 200,
                  width: double.infinity,
                  child: _authorImage == null
                      ? Center(child: Text('Tap to select an image'))
                      : Image.file(
                          File(_authorImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final profilePacket = ProfilePacket(
                          authorName: _authorController.text, image: imageUrl);
                      _dbservice.createAuthor(profilePacket);
                      if (_authorImage != null) {
                        print('Image Path: ${_authorImage!.path}');
                      }
                      if (imageUrl.isNotEmpty) {
                        print('Image URL: $imageUrl');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Profile Registered Successfully, you can clear the form now'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text('Register Now'),
                    style: ElevatedButton.styleFrom(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _authorController.clear();
                      setState(() {
                        _authorImage = null;
                        imageUrl = '';
                      });
                    },
                    child: Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePacket {
  final String authorName;
  final String image;

  ProfilePacket({
    required this.authorName,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
        "authorName": this.authorName,
        "image": this.image,
      };
}

class DatabaseService {
  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  void createAuthor(ProfilePacket packet) {
    try {
      _fire.collection("AuthorDetails").add(packet.toMap());
    } catch (e) {
      print(e.toString()); // Log the error message
    }
    print('Profile updated with details: ${packet.toMap()}');
  }
}
