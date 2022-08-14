import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/students_info/products_provider_model.dart';
import 'package:student_registration_aad/students_info/students_info_provider.dart';

import 'pages/customer_login.dart';

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
        ChangeNotifierProvider(create: (context) => ProductsProviderModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CustomerLogin(),
      ),
    );
  }
}
