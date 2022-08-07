import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration_aad/custom_widgets/my_alert_box.dart';
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
  Gender? gender;
  bool emailValidated = false;
  bool passValidated = false;
  final studentDbHelper = StudentDbHelper();
  final MyAlertBox alertBox = MyAlertBox();
  int age = 0;
  final _rollNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final studentsList =
                        Provider.of<StudentInfoProvider>(context, listen: false)
                            .studentsList;
                    if (studentsList.isEmpty) {
                      return;
                    }
                    print(studentsList.length);
                    for (Student student in studentsList) {
                      try {
                        int? affectedRows =
                            await studentDbHelper.insertStudent(student);
                        if (affectedRows! > 0) {
                          print(
                              'Record ${student.rollNo} Inserted into database.');
                        }
                      } catch (e) {
                        alertBox.showAlertBox(context,
                            "Table '${StudentDbHelper.studentsTableName}' creation error!");
                        return;
                      }
                    }
                    Provider.of<StudentInfoProvider>(context, listen: false)
                        .clearStudentsList();
                    alertBox.showAlertBox(
                      context,
                      'Database updated successfully.',
                      labelColor: Colors.blue,
                    );
                    _clearTextFields();
                    setState(() {});
                  },
                  child: const Text('Update Database'),
                ),
                Text(
                    'Currently in list: ${Provider.of<StudentInfoProvider>(context, listen: false).length}')
              ],
            ),
          ),
          const Text(
            'Register',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
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
              controller: _rollNumberController,
              onChanged: (value) {
                setState(() {
                  rollNo = value;
                });
              },
            ),
            RoundedTextField(
              labelText: 'Name',
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 50),
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
              controller: _emailController,
              suffixIcon: textFieldSuffixIcon(
                emailValidated,
                emailValidated
                    ? 'email is available'
                    : EmailValidator.validate(email)
                        ? 'email is already in use!'
                        : 'invalid email!',
                email,
              ),
              onChanged: emailValidator,
            ),
            RoundedTextField(
              labelText: 'Password',
              isPassword: true,
              controller: _passwordController,
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
              controller: _addressController,
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
      alertBox.showAlertBox(context, "Roll no can't be empty!");
      return;
    }
    if (name.trim() == "") {
      alertBox.showAlertBox(context, "Name can't be empty!");
      return;
    }
    if (gender == null) {
      alertBox.showAlertBox(context, "Please select a gender!");
      return;
    }
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
    if (_ageTextController.text.isEmpty) {
      alertBox.showAlertBox(context, 'Please provide an age!');
      return;
    }
    if (address.trim() == "") {
      alertBox.showAlertBox(context, "Address can't be empty!");
      return;
    }
    try {
      age = int.parse(_ageTextController.text);
    } catch (e) {
      alertBox.showAlertBox(context, 'Age should be a positive integer!');
      return;
    }
    if (emailValidated) {
      Student student = Student(
        rollNo: rollNo,
        name: name,
        email: email,
        password: password,
        age: age,
        address: address,
        gender: gender!.name,
      );
      Provider.of<StudentInfoProvider>(context, listen: false)
          .addStudent(student);
      alertBox.showAlertBox(
        context,
        "Student record with roll no '$rollNo' inserted successfully.",
        labelColor: Colors.blue,
      );
      _clearTextFields();
    } else {
      alertBox.showAlertBox(
        context,
        "email '$email' is already in use!\ntry a different email.",
      );
    }
    setState(() {});
  }

  _clearTextFields() {
    _rollNumberController.clear();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _ageTextController.clear();
    _addressController.clear();
    setState(() {});
  }
}
