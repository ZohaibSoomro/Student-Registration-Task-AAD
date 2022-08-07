import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    required this.onChanged,
    required this.labelText,
    this.isPassword = false,
    this.controller,
    this.suffixIcon,
  });
  final Function(String) onChanged;
  final String labelText;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
