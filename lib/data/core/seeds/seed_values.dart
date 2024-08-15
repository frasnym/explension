import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:explension/models/category.dart';

final defaultCategories = [
  Category(
      id: 1,
      name: 'Food & Drink',
      icon: Icons.restaurant,
      color: Colors.orange.value),
  Category(
      id: 2,
      name: 'Transport',
      icon: Icons.local_shipping,
      color: Colors.yellow.value),
  Category(id: 3, name: 'Home', icon: Icons.home, color: Colors.brown.value),
  Category(id: 4, parentId: 1, name: "Breakfast"),
  Category(id: 5, parentId: 1, name: "Lunch"),
  Category(id: 6, parentId: 1, name: "Dinner"),
  Category(id: 7, parentId: 2, name: "Parking"),
  Category(id: 8, parentId: 2, name: "Gasoline"),
];

final defaultWallets = [
  Wallet(id: 1, name: 'Cash'),
  Wallet(id: 2, name: 'Gopay'),
  Wallet(id: 3, name: 'OVO'),
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
