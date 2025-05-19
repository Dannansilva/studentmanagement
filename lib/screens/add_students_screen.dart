import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../utils/validators.dart';

class AddStudentScreen extends StatefulWidget {
  final StudentService studentService;
  final VoidCallback onStudentAdded;

  const AddStudentScreen({
    Key? key,
    required this.studentService,
    required this.onStudentAdded,
  }) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _courseController = TextEditingController();

  bool _isSubmitting = false;

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
        await widget.studentService.addStudent(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _courseController.text.trim(),
        );

        if (mounted) {
          // Call the callback function to notify parent widget
          widget.onStudentAdded();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student added successfully')),
          );

          // Clear the form
          _nameController.clear();
          _emailController.clear();
          _courseController.clear();
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
                            'Add Student',
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
