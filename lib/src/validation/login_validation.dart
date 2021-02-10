import 'package:flutter/material.dart';
import 'package:news_app/src/validation/validation_item.dart';

class LoginValidation with ChangeNotifier {
  ValidationItem _emailId = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  // Getters
  ValidationItem get emailId => _emailId;

  ValidationItem get password => _password;

  // Setters
  void changeEmailId(String value) {
    if (value.isEmpty != false) {
      _emailId = ValidationItem(null, "Email ID must not be empty");
    } else if (!value.contains("@") || !value.contains(".")) {
      _emailId = ValidationItem(null, "Enter a valid email ID");
    } else {
      _emailId = ValidationItem(value, null);
    }
    notifyListeners();
  }

  void changePassword(String value) {
    if (value.isEmpty != false) {
      _password = ValidationItem(null, "Password must not be empty");
    } else {
      _password = ValidationItem(value, null);
    }
    notifyListeners();
  }

  bool isValid() {
    return emailId.value?.isNotEmpty == true &&
        password.value?.isNotEmpty == true;
  }

  void submitForm() {
    print("Email ID: ${emailId.value}");
    print("Password: ${password.value}");
  }
}
