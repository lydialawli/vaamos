import 'dart:convert';

class Student {
  final String name;
  final String email;
  final DateTime dob;
  final bool isYoung;

  Student(this.name, this.email, this.dob, this.isYoung);

  static String toJson(Student s) {
    Map<String, dynamic> map() => {
          'name': s.name,
          'email': s.email,
          'dob': s.dob.toIso8601String(),
          'isYoung': s.isYoung
        };

    String result = jsonEncode(map());
    return result;
  }

  static Student fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    String name = json['name'];
    String email = json['email'];
    DateTime dob = DateTime.parse(json['dob']);
    bool isYoung = json['isYoung'];

    Student s = new Student(name, email, dob, isYoung);
    return s;
  }
  
}



