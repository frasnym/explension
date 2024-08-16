import 'package:hive/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 1)
class Wallet extends HiveObject {
  @HiveField(0)
  final String name;

  Wallet({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      'name': name,
    };
  }
}
