import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/expense_category.dart';
import 'package:explension/utils/logger.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryService {
  final logger = Logger();
  final _expenseCategoryBox = HiveDataSource.expenseCategoryBox;

  // Add a method to initialize default data
  Future<void> initializeDefaultData() async {
    try {
      if (_expenseCategoryBox.isEmpty) {
        await _expenseCategoryBox.addAll([
          ExpenseCategory(
              id: 1,
              name: 'Food & Drink',
              icon: Icons.restaurant,
              color: Colors.orange.value),
          ExpenseCategory(
              id: 2,
              name: 'Transport',
              icon: Icons.local_shipping,
              color: Colors.yellow.value),
          ExpenseCategory(
              id: 3, name: 'Home', icon: Icons.home, color: Colors.brown.value),
          ExpenseCategory(id: 4, parentId: 1, name: "Breakfast"),
          ExpenseCategory(id: 5, parentId: 1, name: "Lunch"),
          ExpenseCategory(id: 6, parentId: 1, name: "Dinner"),
          ExpenseCategory(id: 7, parentId: 2, name: "Parking"),
          ExpenseCategory(id: 8, parentId: 2, name: "Gasoline"),
        ]);
      }
    } catch (e) {
      print(e); // TODO: use logger
    }
  }

  // Get all data from the Hive box
  List<ExpenseCategory> list() {
    return _expenseCategoryBox.values
        .cast<ExpenseCategory>()
        .where((c) => c.parentId == null)
        .toList();
  }
}
