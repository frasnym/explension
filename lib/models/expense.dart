import 'package:explension/models/category.dart';
import 'package:explension/models/wallet.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final double amount;
  @HiveField(1)
  final Category category;
  @HiveField(2)
  Category? subCategory;
  @HiveField(3)
  final Wallet wallet;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime updatedAt;
  @HiveField(6)
  String? note;

  Expense({
    required this.amount,
    required this.category,
    this.subCategory,
    required this.wallet,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'amount': amount,
      'category': category.toJson(),
      'subCategory': subCategory?.toJson(),
      'wallet': wallet.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'note': note,
    };
  }
}
