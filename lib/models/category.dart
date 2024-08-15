import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 3)
class Category extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int? iconCodePoint;

  @HiveField(3)
  int? parentId;

  @HiveField(4)
  int? color;

  Category({
    required this.id,
    required this.name,
    IconData? icon,
    this.parentId,
    this.color,
  }) : iconCodePoint = icon?.codePoint;

  IconData? get icon => iconCodePoint == null
      ? null
      : IconData(iconCodePoint!, fontFamily: 'MaterialIcons');

  Color? get colorValue => color == null ? null : Color(color!);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'parentId': parentId,
      'color': color,
    };
  }
}
