import 'package:explension/services/expense.dart';
import 'package:explension/services/category.dart';
import 'package:explension/services/wallet.dart';
import 'package:explension/services/sub_category.dart';
import 'package:explension/utils/logger.dart';
import 'package:get_it/get_it.dart';

// sl = service locator
GetIt sl = GetIt.instance;

Future<void> setupInjector() async {
  final logger = Logger();

  sl.registerLazySingleton(() => ExpenseService(logger));
  sl.registerLazySingleton(() => WalletService(logger));
  sl.registerLazySingleton(() => CategoryService(logger));
  sl.registerLazySingleton(() => SubCategoryService(logger));
}
