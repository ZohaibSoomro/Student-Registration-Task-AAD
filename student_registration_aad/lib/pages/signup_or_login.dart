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
    try {
      await DbConnection.connection;
    } catch (e) {
      showAlertBox("Database creation error!", disposeAfter: 800);
    }
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

  Future showAlertBox(
    String errorText, {
    Color labelColor = Colors.red,
    bool showRegister = false,
    int? disposeAfter,
  }) async {
    if (disposeAfter != null) {
      Future.delayed(Duration(milliseconds: disposeAfter), () {
        Navigator.pop(context);
      });
    }
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.blue),
        ),
        elevation: 2,
        title: Text(
          errorText,
          style: TextStyle(color: labelColor),
        ),
        actions: [
          if (showRegister)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              },
              child: const Text('Register'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
