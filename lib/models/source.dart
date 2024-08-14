import 'package:hive/hive.dart';

part 'source.g.dart';

@HiveType(typeId: 2)
class Source {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  Source({
    required this.id,
    required this.name,
  });
}
