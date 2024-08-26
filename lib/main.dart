import 'package:explension/screens/auth/login.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/category.dart';
import 'package:flutter/material.dart';
import 'package:explension/injector.dart';
import 'package:explension/services/wallet.dart';
import 'package:explension/data/data_source/local/hive_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  await dotenv.load(
      fileName: isProduction ? ".env.production" : ".env.development");

  // Init data source
  await HiveDataSource.init();

  // Init injector
  await setupInjector();

  // Init data
  await sl<WalletService>().initializeDefaultData();
  await sl<CategoryService>().initializeDefaultData();
  await sl<ExpenseService>().initializeDefaultData();

  // Init Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.purple,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
    ),
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
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
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
    useMaterial3: true,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explension',
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.light,
      home: LoginPage(),
    );
  }
}
