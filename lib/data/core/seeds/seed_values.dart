import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:explension/models/category.dart';

final defaultCategories = [
  Category(
      name: 'Food & Drink', icon: Icons.restaurant, color: Colors.orange.value),
  Category(
      name: 'Transport',
      icon: Icons.local_shipping,
      color: Colors.yellow.value),
  Category(name: 'Home', icon: Icons.home, color: Colors.brown.value),
];

final defaultSubCategoris = [
  Category(parentId: defaultCategories[0].key, name: "Breakfast"),
  Category(parentId: defaultCategories[0].key, name: "Lunch"),
  Category(parentId: defaultCategories[0].key, name: "Dinner"),
  Category(parentId: defaultCategories[1].key, name: "Parking"),
  Category(parentId: defaultCategories[1].key, name: "Gasoline"),
];

final defaultWallets = [
  Wallet(name: 'Cash'),
  Wallet(name: 'Gopay'),
  Wallet(name: 'OVO'),
];

final DateTime twoMonthsAgo = DateTime.now().subtract(const Duration(days: 60));

final defaultExpenses = [
  Expense(
      amount: 100,
      category: defaultCategories[0],
      wallet: defaultWallets[0],
      createdAt: twoMonthsAgo,
      updatedAt: twoMonthsAgo,
      note: "Two months ago")
];
