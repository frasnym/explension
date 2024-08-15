import 'package:explension/data/core/constants/const_values.dart';
import 'package:explension/models/category.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';

class HiveDataSource {
  /// Init Hive Local Storage
  static Future<void> init() async {
    await Hive.initFlutter();

    /// Register the adapter
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(WalletAdapter());
    Hive.registerAdapter(CategoryAdapter());

    /// Open the boxes
    await Hive.openBox<Expense>(ConstValues.expenseBox);
    await Hive.openBox<Wallet>(ConstValues.walletBox);
    await Hive.openBox<Category>(ConstValues.categoryBox);
  }

  /// Get the boxes
  static Box<Expense> get expenseBox =>
      Hive.box<Expense>(ConstValues.expenseBox);
  static Box<Wallet> get walletBox => Hive.box<Wallet>(ConstValues.walletBox);
  static Box<Category> get categoryBox =>
      Hive.box<Category>(ConstValues.categoryBox);
}
