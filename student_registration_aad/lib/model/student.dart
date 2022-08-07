class Student {
  String rollNo;
  String name;
  String email;
  String password;
  int age;
  String address;
  String gender;

  Student({
    required this.rollNo,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.age,
    required this.address,
  });

  Map<String, Object> toJson() {
    return {
      "rollNo": rollNo,
      "name": name,
      "email": email,
      "password": password,
      "gender": gender,
      "age": age,
      "address": address,
    };
  }

  @override
  String toString() {
    final std = """{
    rollNo: $rollNo,
    name: $name,
    email: $email,
    gender: $gender,
    age: $age,
    address: $address,
  }""";
    return std;
  }
}

enum Gender { Male, Female }
