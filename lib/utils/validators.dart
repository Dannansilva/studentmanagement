class Validators {
  // Validate name (required, min length)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Validate email (required, format)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // Simple email regex pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Validate course (required)
  static String? validateCourse(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Course is required';
    }
    return null;
  }
}
