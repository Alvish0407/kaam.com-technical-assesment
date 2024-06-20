extension ValidatorsX on String {
  bool get isValidEmail {
    const emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(emailPattern).hasMatch(this);
  }

  // At least 8 characters long.
  // Contains both uppercase and lowercase letters.
  // Includes at least one numeric digit.
  // Has at least one special character (e.g., @, #, $, etc.).
  bool get isPasswordStrong {
    const passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    return RegExp(passwordPattern).hasMatch(this);
  }
}
