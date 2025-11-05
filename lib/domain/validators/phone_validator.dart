class PhoneValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Enter phone';
    final clean = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\+?\d{6,15}$').hasMatch(clean)) return 'Enter valid phone';
    return null;
  }
}