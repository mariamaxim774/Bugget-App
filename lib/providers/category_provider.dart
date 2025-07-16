import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  Category? _selectedCategory; 

  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void setSelectedCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
