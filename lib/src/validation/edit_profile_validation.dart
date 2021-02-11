import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/validation/validation_item.dart';

class EditProfileValidation with ChangeNotifier {
  ValidationItem _name = ValidationItem.empty();
  ValidationItem _emailId = ValidationItem.empty();
  ValidationItem _dob = ValidationItem.empty();

  void setInitialValues({String name, String email, String dob}) {
    _name = ValidationItem(name, null);
    _emailId = ValidationItem(email, null);
    _dob = ValidationItem(dob, null);
  }

  // Getters
  ValidationItem get name => _name;

  ValidationItem get emailId => _emailId;

  ValidationItem get dob => _dob;

  // Setters
  void changeName(String value) {
    if (value?.isEmpty != false) {
      _name = ValidationItem(null, "Name must not be empty");
    } else {
      _name = ValidationItem(value, null);
    }
    notifyListeners();
  }

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

  void changeDob(String value) {
    print("change dob");
    if (value?.isEmpty != false) {
      _dob = ValidationItem(null, "DOB must not be empty");
    } else {
      try {
        DateFormat(DateFormats.DateOfBirth).parse(value);
      } on FormatException catch (e) {
        _dob = ValidationItem(null, "Invalid date format");
        notifyListeners();
        return;
      }
      _dob = ValidationItem(value, null);
    }
    notifyListeners();
  }

  bool isValid() {
    return name.value?.isNotEmpty == true &&
        emailId.value?.isNotEmpty == true &&
        dob.value?.isNotEmpty == true;
  }

  void submitForm() {
    print("Name: ${name.value}");
    print("Email: ${emailId.value}");
    print("DOB: ${dob.value}");
  }
}
