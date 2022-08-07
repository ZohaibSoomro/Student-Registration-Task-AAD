import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/pages/signup.dart';

import '../custom_widgets/my_alert_box.dart';
import '../custom_widgets/rounded_button.dart';
import '../custom_widgets/rounded_text_field.dart';
import '../database/db_connection.dart';
import '../database/student_db_helper.dart';
import '../model/student.dart';
import '../students_info/students_info_provider.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String password = "";
  String email = "";
  bool emailValidated = false;
  bool passValidated = false;
  final studentDbHelper = StudentDbHelper();
  final MyAlertBox alertBox = MyAlertBox();

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Login',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          loginForm(),
        ],
      ),
    );
  }

  Form loginForm() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          children: [
            RoundedTextField(
              labelText: 'Email',
              autoFocus: true,
              suffixIcon: textFieldSuffixIcon(
                emailValidated,
                emailValidated
                    ? 'email is valid'
                    : EmailValidator.validate(email)
                        ? 'email not registered!'
                        : 'invalid email!',
                email,
              ),
              onChanged: emailValidator,
            ),
            RoundedTextField(
              labelText: 'Password',
              isPassword: true,
              suffixIcon: textFieldSuffixIcon(
                passValidated,
                'password length < 6.',
                password,
              ),
              onChanged: passwordValidator,
            ),
            const SizedBox(height: 20),
            RoundedButton(
              onPressed: onLoginButtonPressed,
              text: 'Login',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _initDb() async {
    try {
      await DbConnection.connection;
    } catch (e) {
      alertBox.showAlertBox(context, "Database creation error!",
          disposeAfterMillis: 800);
    }
  }

  Widget textFieldSuffixIcon(bool validated, String tooltip, String fieldName) {
    return validated
        ? Tooltip(
            message: tooltip,
            child: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          )
        : fieldName.isNotEmpty
            ? Tooltip(
                message: tooltip,
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              )
            : const Text('');
  }

  void emailValidator(value) async {
    email = value;
    if (EmailValidator.validate(email)) {
      final localListContains =
          Provider.of<StudentInfoProvider>(context, listen: false)
              .containsStudent(email);
      bool foundInDb = false;
      try {
        foundInDb = await studentDbHelper.containsStudent(email);
      } catch (e) {}
      if (localListContains || foundInDb) {
        emailValidated = true;
      } else {
        emailValidated = false;
      }
    } else {
      emailValidated = false;
    }
    setState(() {});
  }

  void passwordValidator(value) {
    setState(() {
      password = value;
      if (password.length >= 6) {
        passValidated = true;
      } else {
        passValidated = false;
      }
    });
  }

  void onLoginButtonPressed() async {
    if (email.trim() == "") {
      alertBox.showAlertBox(context, "Email can't be empty!");
      return;
    }
    if (!EmailValidator.validate(email)) {
      alertBox.showAlertBox(context, "Please provide a valid email!");
      return;
    }
    if (password.trim() == "") {
      alertBox.showAlertBox(context, "Password can't be empty!");
      return;
    }
    if (password.length < 6) {
      alertBox.showAlertBox(context, "Password length can't be less than 6.");
      return;
    }
    if (!emailValidated) {
      alertBox.showAlertBox(
        context,
        "No any student record found with the email '$email'.\nTry registering yourself.",
        showRegister: true,
      );
      return;
    }
    final result =
        await Provider.of<StudentInfoProvider>(context, listen: false)
            .findStudent(email, password);
    if (result is String) {
      if (result == StudentInfoProvider.passNotMatched) {
        alertBox.showAlertBox(
          context,
          'Incorrect password! try again.',
        );
      }
    } else {
      Student student = result as Student;
      bool foundInDb = false;
      try {
        foundInDb = await studentDbHelper.containsStudent(email);
      } catch (e) {}
      if (!foundInDb) {
        int? affectedRows = await studentDbHelper.insertStudent(student);
        if (affectedRows! > 0) {
          await alertBox.showAlertBox(
            context,
            'Data inserted from local into database.',
            labelColor: Colors.blue,
            disposeAfterMillis: 1300,
          );
          Provider.of<StudentInfoProvider>(context, listen: false)
              .removeStudent(student);
          setState(() {});
        }
      }
      await alertBox.showAlertBox(
        context,
        'Login Successful',
        labelColor: Colors.blue,
        disposeAfterMillis: 500,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            student: student,
          ),
        ),
      );
    }
  }
}
