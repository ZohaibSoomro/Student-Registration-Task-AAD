import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/custom_widgets/rounded_button.dart';
import 'package:student_registration_aad/database/student_db_helper.dart';
import 'package:student_registration_aad/students_info/students_info_provider.dart';

import '../custom_widgets/rounded_text_field.dart';
import '../model/student.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String rollNo = "";
  String name = "";
  String email = "";
  String password = "";
  String address = "";
  Gender gender = Gender.Male;
  bool emailValidated = false;
  bool passValidated = false;
  final studentDbHelper = StudentDbHelper();

  int age = 0;
  final _ageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SizedBox()),
                const Expanded(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final studentsList = Provider.of<StudentInfoProvider>(
                                context,
                                listen: false)
                            .studentsList;
                        print(studentsList.length);
                        for (Student student in studentsList) {
                          int? affectedRows =
                              await studentDbHelper.insertStudent(student);
                          if (affectedRows! > 0) {
                            print(
                                'Record ${student.rollNo} Inserted into database.');
                          }
                        }
                        Provider.of<StudentInfoProvider>(context, listen: false)
                            .clearStudentsList();
                        showAlertBox(
                          'Database updated successfully.',
                          labelColor: Colors.blue,
                        );
                        setState(() {});
                      },
                      child: const Text('Update Database'),
                    ),
                    Text(
                        'Currently in list: ${Provider.of<StudentInfoProvider>(context, listen: false).length}')
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: signupForm(),
            ),
          ),
        ],
      ),
    );
  }

  Form signupForm() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          children: [
            RoundedTextField(
              labelText: 'Roll no',
              onChanged: (value) {
                setState(() {
                  rollNo = value;
                });
              },
            ),
            RoundedTextField(
              labelText: 'Name',
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Radio<Gender>(
                    groupValue: gender,
                    value: Gender.Male,
                    onChanged: onGenderSelected,
                  ),
                  TextButton(
                    onPressed: () => onGenderSelected(Gender.Male),
                    child: const Text(
                      'Male',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Radio<Gender>(
                    groupValue: gender,
                    value: Gender.Female,
                    onChanged: onGenderSelected,
                  ),
                  TextButton(
                    onPressed: () => onGenderSelected(Gender.Female),
                    child: const Text(
                      'Female',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            RoundedTextField(
              labelText: 'Email',
              suffixIcon: textFieldSuffixIcon(
                emailValidated,
                emailValidated
                    ? 'email is available'
                    : EmailValidator.validate(email)
                        ? 'email already in use!'
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
                passValidated ? 'password is valid' : 'password length < 6.',
                password,
              ),
              onChanged: passwordValidator,
            ),
            RoundedTextField(
              labelText: 'Age',
              onChanged: (value) {},
              controller: _ageTextController,
            ),
            RoundedTextField(
              labelText: 'Address',
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
            ),
            RoundedButton(
              onPressed: onSignupButtonPressed,
              text: 'Sign up',
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              text: 'Go to Login',
            ),
          ],
        ),
      ),
    );
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
      final foundInDb = await studentDbHelper.containsStudent(email);
      if (!localListContains && !foundInDb) {
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

  void onGenderSelected(Gender? newVal) {
    setState(() {
      gender = newVal!;
    });
  }

  void onSignupButtonPressed() async {
    if (rollNo.trim() == "") {
      showAlertBox("Rollno can't be empty!");
      return;
    }
    if (name.trim() == "") {
      showAlertBox("Name can't be empty!");
      return;
    }
    if (email.trim() == "") {
      showAlertBox("Email can't be empty!");
      return;
    }
    if (!EmailValidator.validate(email)) {
      showAlertBox("Please provide a valid email!");
      return;
    }
    if (password.trim() == "") {
      showAlertBox("Password can't be empty!");
      return;
    }
    if (password.length < 6) {
      showAlertBox("Password length can't be less than 6.");
      return;
    }
    if (_ageTextController.text.isEmpty) {
      showAlertBox('Please provide an age!');
      return;
    }
    if (address.trim() == "") {
      showAlertBox("Address can't be empty!");
      return;
    }
    try {
      age = int.parse(_ageTextController.text);
    } catch (e) {
      showAlertBox('Age should be a positive integer!');
      return;
    }
    Student student = Student(
      rollNo: rollNo,
      name: name,
      email: email,
      password: password,
      age: age,
      address: address,
      gender: gender.name,
    );
    Provider.of<StudentInfoProvider>(context, listen: false)
        .addStudent(student);
    showAlertBox(
      "Student record with roll no '$rollNo' inserted successfully.",
      labelColor: Colors.blue,
    );
    setState(() {});
  }

  void showAlertBox(String errorText, {Color labelColor = Colors.red}) {
    showDialog(
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
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }
}
