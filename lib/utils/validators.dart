class Validators {

  // ── NOMBRE ──
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  // ── EMAIL ──
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ── CONTRASEÑA ──
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // ── CONFIRMAR CONTRASEÑA ──
  static String? validateConfirmPassword(String? value, String password) {
    final basicError = validatePassword(value);
    if (basicError != null) return basicError;

    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ── NÚMERO POSITIVO ──
  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value.trim());
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }

  // ── PASO DE RECETA ──
  static String? validateStep(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Step description is required';
    }
    if (value.trim().length < 5) {
      return 'Step description is too short';
    }
    return null;
  }
}