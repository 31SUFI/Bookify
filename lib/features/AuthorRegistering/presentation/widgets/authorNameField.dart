import 'package:flutter/material.dart';

class AuthorNameField extends StatelessWidget {
  final TextEditingController controller;

  AuthorNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Author Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
}
