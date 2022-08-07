import 'package:flutter/material.dart';

import '../pages/signup.dart';

class MyAlertBox {
  Future showAlertBox(
    BuildContext context,
    String errorText, {
    Color labelColor = Colors.red,
    bool showRegister = false,
    int? disposeAfterMillis,
  }) async {
    if (disposeAfterMillis != null) {
      Future.delayed(Duration(milliseconds: disposeAfterMillis), () {
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
