String? validateEmail(String emailValue) {
  if (emailValue.isEmpty) return "Enter a valid email";
  return null;
}

String? validatePassword(String passwordValue) {
  if (passwordValue.isEmpty) {
    return "Enter a password";
  } else if (passwordValue.length < 5) {
    return "Password should be at least 5 characters long";
  }
  return null;
}

String? validateText(String value) {
  if (value?.isEmpty != false) {
    return "Enter a valid text";
  }
  return null;
}
