class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length < 6) return 'Password must be 6+ chars';
    return null;
  }
}