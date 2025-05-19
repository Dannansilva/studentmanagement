import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';

class StudentService {
  static const String _storageKey = 'students';
  final _uuid = Uuid();

  List<Student> _students = [];

  final _studentsStreamController = StreamController<List<Student>>.broadcast();

  Stream<List<Student>> get studentsStream => _studentsStreamController.stream;

  static final StudentService _instance = StudentService._internal();

  factory StudentService() {
    return _instance;
  }

  StudentService._internal();

  Future<void> init() async {
    await _loadStudents();
  }

  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final studentsJson = prefs.getString(_storageKey);

    if (studentsJson != null) {
      final List<dynamic> decodedData = jsonDecode(studentsJson);
      _students = decodedData.map((item) => Student.fromJson(item)).toList();
      _notifyListeners();
    }
  }

  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final studentsJson = jsonEncode(
      _students.map((student) => student.toJson()).toList(),
    );
    await prefs.setString(_storageKey, studentsJson);
  }

  List<Student> getAllStudents() {
    return List.unmodifiable(_students);
  }

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Student> addStudent(String name, String email, String course) async {
    final student = Student(
      id: _uuid.v4(),
      name: name,
      email: email,
      course: course,
    );

    _students.add(student);
    await _saveStudents();
    _notifyListeners();

    return student;
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final index = _students.indexWhere(
      (student) => student.id == updatedStudent.id,
    );

    if (index != -1) {
      _students[index] = updatedStudent;
      await _saveStudents();
      _notifyListeners();
    } else {
      throw Exception('Student not found');
    }
  }

  Future<void> deleteStudent(String id) async {
    _students.removeWhere((student) => student.id == id);
    await _saveStudents();
    _notifyListeners();
  }

  void _notifyListeners() {
    _studentsStreamController.add(List.unmodifiable(_students));
  }

  void dispose() {
    _studentsStreamController.close();
  }
}
