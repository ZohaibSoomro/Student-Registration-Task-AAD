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



db.stdsinfo.insertMany([
  {_id:'19SW42',name:'Zohaib',score:82,exam_type:'finals'},
  {_id:'19SW43',name:'Amrat',score:88,exam_type:'finals'},
  {_id:'19SW44',name:'Ahmed',score:89,exam_type:'finals'},
  {_id:'19SW45',name:'Uzair',score:95,exam_type:'finals'},
  {_id:'19SW39',name:'Gulwish',score:78,exam_type:'finals'},
  {_id:'19SW38',name:'Rumisa',score:99,exam_type:'finals'},
  {_id:'19SW37',name:'Pardeep',score:67,exam_type:'finals'},
  {_id:'19SW36',name:'Abuzar',score:85,exam_type:'finals'},
  ])