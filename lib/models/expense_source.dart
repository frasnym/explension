import 'package:hive/hive.dart';

part 'expense_source.g.dart';

@HiveType(typeId: 1)
class ExpenseSource {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  ExpenseSource({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
