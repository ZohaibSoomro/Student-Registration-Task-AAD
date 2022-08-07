import 'package:flutter/foundation.dart';

import '../database/student_db_helper.dart';
import '../model/student.dart';

class StudentInfoProvider extends ChangeNotifier {
  final List<Student> _studentsList = [];
  static const notFound = "not found!";
  static const passNotMatched = "password not matched!";
  get studentsList => _studentsList;

  void addStudent(Student student) {
    _studentsList.add(student);
    notifyListeners();
  }

  int get length => _studentsList.length;

  void removeStudent(Student student) {
    _studentsList.removeWhere((std) => std.email == student.email);
    notifyListeners();
  }

  void clearStudentsList() {
    _studentsList.clear();
    notifyListeners();
  }

  Future<Object> findStudent(String email, String password) async {
    List foundStudents = _studentsList
        .where((Student student) => student.email == email)
        .toList();
    if (foundStudents.isEmpty) {
      foundStudents = await StudentDbHelper().getStudentsList();
    }
    if (foundStudents.isNotEmpty) {
      final student = foundStudents[0];
      if (student.password == password) {
        return student;
      } else {
        return passNotMatched;
      }
    }
    return notFound;
  }

  bool containsStudent(String email) {
    bool found = false;
    studentsList.any((student) => found = student.email == email);
    return found;
  }
}
