import 'package:explension/data/core/constants/const_values.dart';
import 'package:explension/models/expense_category.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:explension/models/expense.dart';
import 'package:explension/models/expense_source.dart';

class HiveDataSource {
  /// Init Hive Local Storage
  static Future<void> init() async {
    await Hive.initFlutter();

    /// Register the adapter
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(ExpenseSourceAdapter());
    Hive.registerAdapter(ExpenseCategoryAdapter());

    /// Open the boxes
    await Hive.openBox<Expense>(ConstValues.expenseBox);
    await Hive.openBox<ExpenseSource>(ConstValues.expenseSourceBox);
    await Hive.openBox<ExpenseCategory>(ConstValues.expenseCategoryBox);
  }

  /// Get the boxes
  static Box<Expense> get expenseBox =>
      Hive.box<Expense>(ConstValues.expenseBox);
  static Box<ExpenseSource> get expenseSourceBox =>
      Hive.box<ExpenseSource>(ConstValues.expenseSourceBox);
  static Box<ExpenseCategory> get expenseCategoryBox =>
      Hive.box<ExpenseCategory>(ConstValues.expenseCategoryBox);
}
