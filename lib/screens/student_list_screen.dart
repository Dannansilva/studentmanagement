import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  final StudentService studentService;

  const StudentListScreen({Key? key, required this.studentService})
    : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();

    widget.studentService.studentsStream.listen((students) {
      setState(() {
        _students = students;
      });
    });
  }

  void _loadStudents() {
    setState(() {
      _students = widget.studentService.getAllStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _students.isEmpty
              ? const Center(
                child: Text(
                  'No students yet. Add some!',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          student.name.isNotEmpty
                              ? student.name[0].toUpperCase()
                              : '',
                        ),
                      ),
                      title: Text(student.name),
                      subtitle: Text(student.course),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    StudentDetailScreen(studentId: student.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
