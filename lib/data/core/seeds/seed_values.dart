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

final defaultSubCategories = [
  Category(parentId: 0, name: "Breakfast"),
  Category(parentId: 0, name: "Lunch"),
  Category(parentId: 0, name: "Dinner"),
  Category(parentId: 1, name: "Parking"),
  Category(parentId: 1, name: "Gasoline"),
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
