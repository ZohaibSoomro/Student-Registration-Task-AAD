import 'package:flutter/material.dart';

class RoundedBlackButton extends StatelessWidget {
  const RoundedBlackButton(
      {Key? key, required this.onPressed, required this.label})
      : super(key: key);
  final VoidCallback onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
