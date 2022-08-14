import 'package:student_registration_aad/database/student_db_connection.dart';
import 'package:student_registration_aad/model/student.dart';

class StudentDbHelper {
  static const String studentsTableName = 'students';
  static const notFound = "not found!";
  static const passNotMatched = "password not matched!";
  Future<int?> insertStudent(Student student) async {
    final connection = await StudentDbConnection.connection;
    await connection.query(_tableCreationQuery);
    print('Table $studentsTableName created successfully.');
    final result = await connection.query('''
     INSERT INTO $studentsTableName 
     Values('${student.rollNo}','${student.name}','${student.gender}',
     '${student.email}','${student.password}',${student.age},'${student.address}'
     )
    ''');
    return result.affectedRows;
  }

  final String _tableCreationQuery = '''
    CREATE TABLE IF NOT EXISTS students(
    rollNo varchar(10),
    name varchar(30),
    gender varchar(8), 
    email varchar(20),
    password varchar(20),
    age int,
    address varchar(100),
    PRIMARY KEY(email)
    )
    ''';
  Future<List<Student>> getStudentsList() async {
    List<Student> studentsList = [];
    final connection = await StudentDbConnection.connection;
    final records = await connection.query('SELECT * FROM $studentsTableName');
    for (var record in records) {
      Student student = Student(
        rollNo: record[0],
        name: record[1],
        gender: record[2],
        email: record[3],
        password: record[4],
        age: record[5],
        address: record[6],
      );
      studentsList.add(student);
    }
    return studentsList;
  }

  Future<bool> containsStudent(String email) async {
    final studentsList = await getStudentsList();
    bool found = false;
    studentsList.any((student) => found = student.email == email);
    return found;
  }

  // Object findStudent(String email, String password) async {
  //   final studentsList = await getStudentsList();
  //   final foundStudents = studentsList
  //       .where((Student student) => student.email == email)
  //       .toList();
  //   if (foundStudents.isNotEmpty) {
  //     final student = foundStudents[0];
  //     if (student.password == password) {
  //       return student;
  //     } else {
  //       return passNotMatched;
  //     }
  //   }
  //   return notFound;
  // }
}
