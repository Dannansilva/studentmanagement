class Student {
  final String id;
  final String name;
  final String email;
  final String course;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.course,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'course': course};
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      course: json['course'],
    );
  }

  Student copyWith({String? id, String? name, String? email, String? course}) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      course: course ?? this.course,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, email: $email, course: $course}';
  }
}
