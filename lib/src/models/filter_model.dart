import 'package:flutter/material.dart';

class NewsCategoryModel extends ChangeNotifier {
  String? _selectedCategory;

  get selectedCategory => _selectedCategory;

  void updateFilter(String category) {
    this._selectedCategory = category;
    notifyListeners();
  }
}
