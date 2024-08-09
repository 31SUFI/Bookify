import 'dart:io';

import 'package:bookify/core/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String pdfUrl = '';
  String? pdfFileName;

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

  Future<void> _pickUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        return;
      }

      PlatformFile file = result.files.first;

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirFiles = referenceRoot.child("Books");
      Reference referenceFileToUpload = referenceDirFiles.child(fileName);

      await referenceFileToUpload.putFile(File(file.path!));
      pdfUrl = await referenceFileToUpload.getDownloadURL();

      // Update the state with the selected PDF file name
      setState(() {
        pdfFileName = file.name;
      });

      print('PDF URL: $pdfUrl');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Publish Your Book"),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickUploadFile,
                child: Text(
                  'Upload PDF',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
              // Display the PDF file name if a file has been selected
              if (pdfFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    ' File Name: $pdfFileName',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                        image: imageUrl,
                        pdfUrl: pdfUrl,
                      );
                      _dbservice.create(detailsPacket);
                      if (_bookImage != null) {
                        print('Image Path: ${_bookImage!.path}');
                      }
                      if (imageUrl.isNotEmpty) {
                        print('Image URL: $imageUrl');
                      }
                      if (pdfUrl.isNotEmpty) {
                        print('PDF URL: $pdfUrl');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Book Uploaded Successfully, you can clear form now'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text(
                      'Publish Now',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _bookNameController.clear();
                      _authorController.clear();
                      _categoryController.clear();
                      setState(() {
                        _bookImage = null;
                        imageUrl = '';
                        pdfUrl = '';
                        pdfFileName = null; // Clear PDF file name
                      });
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.grey,
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
  final String pdfUrl;

  Packet({
    required this.bookName,
    required this.authorName,
    required this.category,
    required this.image,
    required this.pdfUrl,
  });

  Map<String, dynamic> toMap() => {
        "bookName": this.bookName,
        "authorName": this.authorName,
        "category": this.category,
        "image": this.image,
        "pdfUrl": this.pdfUrl,
      };
}
