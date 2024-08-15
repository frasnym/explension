import 'package:explension/data/core/seeds/seed_values.dart';
import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/category.dart';
import 'package:explension/utils/logger.dart';

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
        await _categoryBox.addAll(defaultCategories);
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
