import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/utils/logger.dart';
import 'package:hive/hive.dart';

class ExpenseService {
  final logger = Logger();
  final Box _expenseBox = HiveDataSource().expenseBox;

  Future<void> addExpense(Expense expense) async {
    const serviceName = "ExpenseService-addExpense";

    try {
      await _expenseBox.add(expense);
    } catch (e) {
      logger.logError(serviceName, e);
    } finally {
      logger.logService(serviceName, expense.toString());
    }
  }

  List<Expense> getExpenses() {
    return _expenseBox.values.cast<Expense>().toList();
  }
}
