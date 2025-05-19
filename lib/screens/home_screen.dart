import 'package:flutter/material.dart';
import 'package:studentmanagement/screens/add_students_screen.dart';
import '../models/student.dart';
import '../screens/student_list_screen.dart';
import '../services/student_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentService _studentService = StudentService();
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      StudentListScreen(studentService: _studentService),
      AddStudentScreen(
        studentService: _studentService,
        onStudentAdded: _onStudentAdded,
      ),
    ];
  }

  void _onStudentAdded() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Management System',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Student'),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
