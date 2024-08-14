import 'package:explension/services/expense.dart';
import 'package:explension/services/expense_category.dart';
import 'package:explension/services/expense_source.dart';
import 'package:explension/services/expense_sub_category.dart';
import 'package:explension/utils/logger.dart';
import 'package:get_it/get_it.dart';

// sl = service locator
GetIt sl = GetIt.instance;

Future<void> setupInjector() async {
  final logger = Logger();

  sl.registerLazySingleton(() => ExpenseService(logger));
  sl.registerLazySingleton(() => ExpenseSourceService(logger));
  sl.registerLazySingleton(() => ExpenseCategoryService(logger));
  sl.registerLazySingleton(() => ExpenseSubCategoryService(logger));
}
