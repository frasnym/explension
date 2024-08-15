import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/category.dart';
import 'package:explension/utils/logger.dart';
import 'package:flutter/material.dart';

class CategoryService {
  final String serviceName = "CategoryService";
  final Logger logger;
  final _categoryBox = HiveDataSource.categoryBox;

  CategoryService(this.logger);

  // Add a method to initialize default data
  Future<void> initializeDefaultData() async {
    const funcName = "initializeDefaultData";

    try {
      if (_categoryBox.isEmpty) {
        await _categoryBox.addAll([
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
          Category(
              id: 3, name: 'Home', icon: Icons.home, color: Colors.brown.value),
          Category(id: 4, parentId: 1, name: "Breakfast"),
          Category(id: 5, parentId: 1, name: "Lunch"),
          Category(id: 6, parentId: 1, name: "Dinner"),
          Category(id: 7, parentId: 2, name: "Parking"),
          Category(id: 8, parentId: 2, name: "Gasoline"),
        ]);
      }
    } catch (e) {
      logger.error(serviceName, funcName, e);
    } finally {
      logger.info(serviceName, funcName, "Default data initialized");
    }
  }

  // Get all data from the Hive box
  List<Category> list() {
    return _categoryBox.values
        .cast<Category>()
        .where((c) => c.parentId == null)
        .toList();
  }
}
