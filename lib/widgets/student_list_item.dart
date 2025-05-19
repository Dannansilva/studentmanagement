import 'package:flutter/material.dart';
import '../models/student.dart';
import '../screens/student_detail_screen.dart';

class StudentListItem extends StatelessWidget {
  final Student student;
  final Function(Student) onDelete;
  final Function(Student) onEdit;

  const StudentListItem({
    Key? key,
    required this.student,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Course: ${student.course}'),
            const SizedBox(height: 2),
            Text(
              student.email,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit(student),
              tooltip: 'Edit Student',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context),
              tooltip: 'Delete Student',
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailScreen(studentId: student.id),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${student.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete(student);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
