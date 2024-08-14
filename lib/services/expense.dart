import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/utils/logger.dart';

class ExpenseService {
  final logger = Logger();
  final _expenseBox = HiveDataSource.expenseBox;

  Future<void> create(Expense expense) async {
    const serviceName = "ExpenseService-addExpense";

    try {
      await _expenseBox.add(expense);
    } catch (e) {
      logger.logError(serviceName, e);
    } finally {
      logger.logService(serviceName, expense.toString());
    }
  }

  List<Expense> list() {
    return _expenseBox.values.cast<Expense>().toList();
  }
}
