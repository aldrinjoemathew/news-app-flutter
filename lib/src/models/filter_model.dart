import 'package:flutter/material.dart';

class NewsCategoryModel extends ChangeNotifier {
  String? _selectedCategory;

  get selectedCategory => _selectedCategory;

  void updateFilter(String category) {
    if (category == _selectedCategory) {
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }
    notifyListeners();
  }
}
