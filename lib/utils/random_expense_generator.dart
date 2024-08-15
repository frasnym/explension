import 'dart:math';
import 'package:explension/models/expense.dart';
import 'package:explension/models/expense_source.dart';
import 'package:explension/services/expense_category.dart';
import 'package:explension/services/expense_sub_category.dart';
import 'package:explension/injector.dart';

Expense generateRandomExpense(List<ExpenseSource> expenseSources) {
  final random = Random();

  final randomSource = expenseSources[random.nextInt(expenseSources.length)];

  final categories = sl<ExpenseCategoryService>().list();
  final randomCategory = categories[random.nextInt(categories.length)];

  final newExpense = Expense(
    amount: (random.nextInt(9) + 1).toDouble(),
    category: randomCategory,
    source: randomSource,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    note: 'Test Note',
  );

  final subCategories =
      sl<ExpenseSubCategoryService>().listByParentId(randomCategory.id);
  if (subCategories.isNotEmpty) {
    final randomSubCategory =
        subCategories[random.nextInt(subCategories.length)];

    newExpense.subCategory = randomSubCategory;
  }

  return newExpense;
}
