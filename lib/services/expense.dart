import 'dart:async';

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
      _expensesStreamController.add(_expenseBox.values.toList());
    } catch (e) {
      logger.error(serviceName, funcName, e);
    } finally {
      logger.info(serviceName, funcName, expense.toJson().toString());
    }
  }

  // TODO: Search better approach to show oldest data first
  List<Expense> list() {
    return _expenseBox.values.cast<Expense>().toList().reversed.toList();
  }

  // TODO: Search better approach to show oldest data first
  Stream<List<Expense>> stream() {
    return _expenseBox.watch().map((event) {
      return _expenseBox.values.toList().reversed.toList();
    });
  }

  final _expensesStreamController = StreamController<List<Expense>>();
}
