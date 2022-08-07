import 'package:flutter/material.dart';
import 'package:student_registration_aad/database/db_connection.dart';
import 'package:student_registration_aad/pages/signup.dart';

import '../custom_widgets/rounded_button.dart';
import 'login.dart';

class SignupOrLogin extends StatefulWidget {
  const SignupOrLogin({Key? key}) : super(key: key);

  @override
  State<SignupOrLogin> createState() => _SignupOrLoginState();
}

class _SignupOrLoginState extends State<SignupOrLogin> {
  @override
  void initState() {
    super.initState();
    _initDb();
  }

  void _initDb() async {
    await DbConnection.connection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            text: 'Login',
          ),
          const SizedBox(height: 5),
          RoundedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Signup()));
            },
            text: 'Signup',
          ),
        ],
      ),
    ));
  }
}
