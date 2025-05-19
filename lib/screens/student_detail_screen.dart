import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import 'edit_student_screen.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;

  const StudentDetailScreen({Key? key, required this.studentId})
    : super(key: key);

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final StudentService _studentService = StudentService();
  Student? _student;

  @override
  void initState() {
    super.initState();
    _loadStudent();

    _studentService.studentsStream.listen((_) {
      _loadStudent();
    });
  }

  void _loadStudent() {
    setState(() {
      _student = _studentService.getStudentById(widget.studentId);
    });
  }

  void _deleteStudent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _studentService.deleteStudent(widget.studentId);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student deleted successfully')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student Details')),
        body: const Center(child: Text('Student not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentScreen(student: _student!),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteStudent),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Text(
                  _student!.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),
            DetailItem(icon: Icons.badge, label: 'ID', value: _student!.id),
            DetailItem(
              icon: Icons.person,
              label: 'Name',
              value: _student!.name,
            ),
            DetailItem(
              icon: Icons.email,
              label: 'Email',
              value: _student!.email,
            ),
            DetailItem(
              icon: Icons.school,
              label: 'Course',
              value: _student!.course,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(value, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
