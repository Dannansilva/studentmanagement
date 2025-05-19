import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import '../utils/validators.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentService = StudentService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _courseController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing student data
    _nameController = TextEditingController(text: widget.student.name);
    _emailController = TextEditingController(text: widget.student.email);
    _courseController = TextEditingController(text: widget.student.course);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final updatedStudent = widget.student.copyWith(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          course: _courseController.text.trim(),
        );

        await _studentService.updateStudent(updatedStudent);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: Validators.validateName,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _courseController,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                  validator: Validators.validateCourse,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitForm(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text(
                            'Update Student',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
