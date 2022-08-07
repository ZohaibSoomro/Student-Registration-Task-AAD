import 'package:flutter/material.dart';
import 'package:student_registration_aad/model/student.dart';

class Home extends StatefulWidget {
  const Home({required this.student});
  final Student student;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome ${widget.student.name}',
          style: const TextStyle(fontSize: 40, color: Colors.blue),
        ),
      ),
    );
  }
}
