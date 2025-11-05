class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Please enter email';
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Enter valid email';
    return null;
  }
}