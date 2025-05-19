import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/validators.dart';

class StudentForm extends StatefulWidget {
  final Function(Student) onSubmit;
  final String submitButtonText;
  final Student? initialStudent;

  const StudentForm({
    Key? key,
    required this.onSubmit,
    this.submitButtonText = 'Save',
    this.initialStudent,
  }) : super(key: key);

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _courseController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with initial values if provided
    _nameController = TextEditingController(
      text: widget.initialStudent?.name ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialStudent?.email ?? '',
    );
    _courseController = TextEditingController(
      text: widget.initialStudent?.course ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.initialStudent?.id ?? '',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        course: _courseController.text.trim(),
      );

      widget.onSubmit(student);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textInputAction: TextInputAction.next,
              validator: Validators.validateName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            // Course Field
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              textInputAction: TextInputAction.done,
              validator: Validators.validateCourse,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                widget.submitButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
