import 'package:explension/models/expense_category.dart';
import 'package:explension/models/expense_source.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final ExpenseCategory category;
  @HiveField(3)
  ExpenseCategory? subCategory;
  @HiveField(4)
  final ExpenseSource source;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  @HiveField(7)
  String? note;

  Expense({
    required this.amount,
    required this.category,
    this.subCategory,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });
}
