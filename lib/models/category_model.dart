import 'package:flutter/material.dart';

/// Model biểu diễn danh mục thu / chi
class CategoryModel {
  final int? id;
  final String name;
  final int type; // 0: Chi tiêu (Expense), 1: Thu nhập (Income)
  final String iconName;
  final int colorValue;

  const CategoryModel({
    this.id,
    required this.name,
    required this.type,
    required this.iconName,
    required this.colorValue,
  });

  bool get isIncome => type == 1;
  bool get isExpense => type == 0;

  Color get color => Color(colorValue);

  IconData get icon {
    switch (iconName.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'attach_money':
        return Icons.attach_money;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'school':
        return Icons.school;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'home':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'type': type,
      'icon_name': iconName,
      'color_value': colorValue,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as int,
      iconName: map['icon_name'] as String? ?? 'category',
      colorValue: map['color_value'] as int? ?? 0xFF78909C,
    );
  }
}
