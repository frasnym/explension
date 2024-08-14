import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/expense_category.dart';
import 'package:explension/utils/logger.dart';

class ExpenseSubCategoryService {
  final logger = Logger();
  final _expenseCategoryBox = HiveDataSource.expenseCategoryBox;

  List<ExpenseCategory> listByParentId(int parentId) {
    return _expenseCategoryBox.values
        .cast<ExpenseCategory>()
        .where((c) => c.parentId == parentId)
        .toList();
  }
}
