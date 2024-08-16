import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 3)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int? iconCodePoint;

  @HiveField(2)
  dynamic parentId;

  @HiveField(3)
  int? color;

  Category({
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
      'key': key,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'parentId': parentId,
      'color': color,
    };
  }
}
