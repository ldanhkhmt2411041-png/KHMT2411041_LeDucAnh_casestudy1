import 'package:flutter/material.dart';

/// Model thống kê chi tiêu theo từng danh mục
class CategoryStatModel {
  final String category;
  final double totalAmount;
  final int count;
  final double percentage; // 0.0 -> 100.0

  const CategoryStatModel({
    required this.category,
    required this.totalAmount,
    required this.count,
    required this.percentage,
  });

  /// Icon tương ứng theo danh mục
  IconData get icon {
    switch (category.toLowerCase().trim()) {
      case 'ăn uống':
        return Icons.restaurant;
      case 'di chuyển':
      case 'xăng xe':
        return Icons.directions_car;
      case 'thu nhập':
      case 'lương':
      case 'tiền lương':
      case 'thưởng':
        return Icons.attach_money;
      case 'mua sắm':
        return Icons.shopping_bag;
      case 'giáo dục':
      case 'học phí':
        return Icons.school;
      case 'giải trí':
        return Icons.sports_esports;
      case 'sức khỏe':
      case 'y tế':
        return Icons.local_hospital;
      default:
        return Icons.category;
    }
  }

  /// Màu sắc tương ứng theo danh mục
  Color get color {
    switch (category.toLowerCase().trim()) {
      case 'ăn uống':
        return const Color(0xFFFF7043);
      case 'di chuyển':
      case 'xăng xe':
        return const Color(0xFF29B6F6);
      case 'thu nhập':
      case 'lương':
      case 'tiền lương':
      case 'thưởng':
        return const Color(0xFF66BB6A);
      case 'mua sắm':
        return const Color(0xFFAB47BC);
      case 'giáo dục':
      case 'học phí':
        return const Color(0xFF26A69A);
      case 'giải trí':
        return const Color(0xFFFFB74D);
      case 'sức khỏe':
      case 'y tế':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF78909C);
    }
  }

  /// Định dạng số tiền VNĐ
  String get formattedAmount {
    int intVal = totalAmount.round();
    String s = intVal.abs().toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = s.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return '$formatted đ';
  }
}
