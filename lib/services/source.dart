import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/expense_source.dart';
import 'package:explension/utils/logger.dart';
import 'package:hive/hive.dart';

class ExpenseSourceService {
  final logger = Logger();
  final Box _expenseSourceBox = HiveDataSource().expenseSourceBox;

  // Add a method to initialize default sources
  Future<void> initializeDefaultSources() async {
    if (_expenseSourceBox.isEmpty) {
      final defaultSources = [
        ExpenseSource(id: 1, name: 'Cash'),
        ExpenseSource(id: 2, name: 'Gopay'),
        ExpenseSource(id: 3, name: 'OVO'),
      ];
      await _expenseSourceBox.addAll(defaultSources);
    }
  }

  // Get all sources from the Hive box
  List<ExpenseSource> getSources() {
    return _expenseSourceBox.values.cast<ExpenseSource>().toList();
  }
}
