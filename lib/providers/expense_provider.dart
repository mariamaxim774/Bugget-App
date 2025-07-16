import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  double totalExpenses = 0;

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    totalExpenses += expense.amount;
    notifyListeners();
  }

  Map<String, List<Expense>> groupExpenses({
    bool day = false,
    bool month = false,
    bool year = false,
    bool byCategory = false,
  }) {
    final Map<String, List<Expense>> grouped = {};

    for (var expense in _expenses) {
      String key = '';

      
      if (byCategory) {
        key += expense.category.name;
      }

      if (year) {
        key += (key.isNotEmpty ? ' | ' : '') + expense.date.year.toString();
      }

      if (month) {
        final monthStr = expense.date.month.toString().padLeft(2, '0');
        key += (key.isNotEmpty ? '/' : '') + monthStr;
      }

      if (day) {
        final dayStr = expense.date.day.toString().padLeft(2, '0');
        key += (key.isNotEmpty ? '/' : '') + dayStr;
      }

      if (key.isEmpty) {
        key = 'All'; 
      }

      grouped.putIfAbsent(key, () => []).add(expense);
    }

    return grouped;
  }
}
