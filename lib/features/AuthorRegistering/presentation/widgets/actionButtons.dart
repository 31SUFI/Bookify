import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onClear;

  ActionButtons({required this.onRegister, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onRegister,
          child: Text('Register Now'),
        ),
        ElevatedButton(
          onPressed: onClear,
          child: Text('Clear'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
