import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/category.dart';
import 'package:explension/utils/logger.dart';

class SubCategoryService {
  final Logger logger;
  final _categoryBox = HiveDataSource.categoryBox;

  SubCategoryService(this.logger);

  List<Category> listByParentId(int parentId) {
    return _categoryBox.values
        .cast<Category>()
        .where((c) => c.parentId == parentId)
        .toList();
  }
}
