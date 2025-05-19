import 'package:flutter/material.dart';
import 'package:studentmanagement/screens/add_students_screen.dart';
import 'screens/student_list_screen.dart';
import 'services/student_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the StudentService
  final studentService = StudentService();
  await studentService.init();

  runApp(MyApp(studentService: studentService));
}

class MyApp extends StatelessWidget {
  final StudentService studentService;

  const MyApp({Key? key, required this.studentService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[300]!, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: StudentListScreen(studentService: studentService),
      routes: {
        '/add':
            (context) => AddStudentScreen(
              studentService: studentService,
              onStudentAdded: () {
                Navigator.pop(context);
              },
            ),
      },
    );
  }
}
