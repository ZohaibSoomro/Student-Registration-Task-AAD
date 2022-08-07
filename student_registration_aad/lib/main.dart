import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/pages/login.dart';
import 'package:student_registration_aad/students_info/students_info_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentInfoProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}
