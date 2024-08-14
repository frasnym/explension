import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/utils/logger.dart';

class ExpenseService {
  final String serviceName = "ExpenseService";
  final Logger logger;
  final _expenseBox = HiveDataSource.expenseBox;

  ExpenseService(this.logger);

  Future<void> create(Expense expense) async {
    const funcName = "create";

    try {
      await _expenseBox.add(expense);
    } catch (e) {
      logger.error(serviceName, funcName, e);
    } finally {
      logger.info(serviceName, funcName, expense.toJson().toString());
    }
  }

  List<Expense> list() {
    return _expenseBox.values.cast<Expense>().toList();
  }
}
