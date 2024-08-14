import 'package:explension/models/source.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final int categoryId;
  @HiveField(3)
  int? subCategoryId;
  @HiveField(4)
  final Source source;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  @HiveField(7)
  String? note;

  Expense({
    required this.amount,
    required this.categoryId,
    this.subCategoryId,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });
}
