import 'package:explension/services/expense.dart';
import 'package:explension/services/source.dart';
import 'package:get_it/get_it.dart';

// sl = service locator
GetIt sl = GetIt.instance;

Future<void> setupInjector() async {
  sl.registerLazySingleton(() => ExpenseService());
  sl.registerLazySingleton(() => ExpenseSourceService());
}
