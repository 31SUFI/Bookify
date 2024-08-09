import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bookify/core/databaseService.dart';
import 'package:bookify/features/AuthorRegistering/presentation/widgets/authorNameField.dart';
import 'package:bookify/features/AuthorRegistering/presentation/widgets/imagePickerWidget.dart';
import 'package:bookify/features/AuthorRegistering/presentation/widgets/actionButtons.dart';
import 'package:bookify/features/AuthorRegistering/data/models/authorModel.dart';

class AuthorRegister extends StatefulWidget {
  @override
  _AuthorRegisterState createState() => _AuthorRegisterState();
}

class _AuthorRegisterState extends State<AuthorRegister> {
  final _dbservice = DatabaseService2();
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

  void _registerAuthorProfile() {
    final profilePacket = AuthorProfilePacket(
        authorName: _authorController.text, image: imageUrl);
    _dbservice.createAuthorProfile(profilePacket);
    if (_authorImage != null) {
      print('Image Path: ${_authorImage!.path}');
    }
    if (imageUrl.isNotEmpty) {
      print('Image URL: $imageUrl');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Profile Registered Successfully, you can clear the form now'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearForm() {
    _authorController.clear();
    setState(() {
      _authorImage = null;
      imageUrl = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register Author Profile",
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
        ),
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
              AuthorNameField(controller: _authorController),
              SizedBox(height: 16),
              ImagePickerWidget(image: _authorImage, onTap: _pickImage),
              SizedBox(height: 24),
              ActionButtons(
                onRegister: _registerAuthorProfile,
                onClear: _clearForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
