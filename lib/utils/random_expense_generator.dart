import 'dart:math';
import 'package:explension/models/expense.dart';
import 'package:explension/services/category.dart';
import 'package:explension/services/wallet.dart';
import 'package:explension/services/sub_category.dart';
import 'package:explension/injector.dart';

// TODO: Unused
Expense generateRandomExpense() {
  final random = Random();

  final wallets = sl<WalletService>().list();
  final randomWallet = wallets[random.nextInt(wallets.length)];

  final categories = sl<CategoryService>().list();
  final randomCategory = categories[random.nextInt(categories.length)];

  final newExpense = Expense(
    amount: (random.nextInt(9) + 1).toDouble(),
    category: randomCategory,
    wallet: randomWallet,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    note: 'Test Note',
  );

  final subCategories =
      sl<SubCategoryService>().listByParentId(randomCategory.key);
  if (subCategories.isNotEmpty) {
    final randomSubCategory =
        subCategories[random.nextInt(subCategories.length)];

    newExpense.subCategory = randomSubCategory;
  }

  return newExpense;
}
