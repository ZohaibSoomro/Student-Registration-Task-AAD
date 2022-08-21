import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
    this.maxChars,
  }) : super(key: key);

  final String label;
  final String hint;
  final int? maxChars;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFormText(label),
          const SizedBox(height: 5),
          TextFormField(
            maxLength: maxChars,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
              errorStyle: const TextStyle(
                fontSize: 8,
                letterSpacing: 0.5,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormText(String text,
      {double size = 15, double opacity = 1, bool bold = true}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black.withOpacity(opacity),
        fontSize: size,
        letterSpacing: 0.5,
        fontWeight: bold ? FontWeight.bold : null,
      ),
    );
  }
}
