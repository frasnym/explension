import 'package:explension/services/expense.dart';
import 'package:explension/services/expense_category.dart';
import 'package:explension/services/expense_sub_category.dart';
import 'package:flutter/material.dart';
import 'package:explension/injector.dart';
import 'package:explension/services/expense_source.dart';
import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:explension/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init data source
  await HiveDataSource.init();

  // Init injector
  await setupInjector();

  // Init data
  await sl<ExpenseSourceService>().initializeDefaultData();
  await sl<ExpenseCategoryService>().initializeDefaultData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explension',
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        primaryColor: Colors.purple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        expenseService: sl<ExpenseService>(),
        expenseCategoryService: sl<ExpenseCategoryService>(),
        expenseSourceService: sl<ExpenseSourceService>(),
        expenseSubCategoryService: sl<ExpenseSubCategoryService>(),
      ),
    );
  }
}
