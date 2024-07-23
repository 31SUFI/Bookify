import 'dart:io';

import 'package:bookify/BookUploading/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookUpload extends StatefulWidget {
  @override
  _BookUploadState createState() => _BookUploadState();
}

class _BookUploadState extends State<BookUpload> {
  final _dbservice = Databaseservice();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  XFile? _bookImage;
  String imageUrl = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _bookNameController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
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
        _bookImage = pickedFile;
      });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child("Tasaaweer");
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Your Book here',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Make your book accessible to the World!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _bookNameController,
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
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
                  child: _bookImage == null
                      ? Center(child: Text('Tap to select an image'))
                      : Image.file(
                          File(_bookImage!.path),
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
                      final detailsPacket = Packet(
                          bookName: _bookNameController.text,
                          authorName: _authorController.text,
                          category: _categoryController.text,
                          image: imageUrl);
                      _dbservice.create(detailsPacket);
                      if (_bookImage != null) {
                        print('Image Path: ${_bookImage!.path}');
                      }
                      if (imageUrl.isNotEmpty) {
                        print('Image URL: $imageUrl');
                      }
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.brown[700],
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _bookNameController.clear();
                      _authorController.clear();
                      _categoryController.clear();
                      setState(() {
                        _bookImage = null;
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

class Packet {
  final String bookName;
  final String authorName;
  final String category;
  final String image;

  Packet({
    required this.bookName,
    required this.authorName,
    required this.category,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
        "bookName": this.bookName,
        "authorName": this.authorName,
        "category": this.category,
        "image": this.image,
      };
}
