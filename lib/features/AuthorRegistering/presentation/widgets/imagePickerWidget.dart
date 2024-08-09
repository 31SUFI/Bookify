import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final XFile? image;
  final VoidCallback onTap;

  ImagePickerWidget({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        height: 200,
        width: double.infinity,
        child: image == null
            ? Center(child: Text('Tap to select an image'))
            : Image.file(
                File(image!.path),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
