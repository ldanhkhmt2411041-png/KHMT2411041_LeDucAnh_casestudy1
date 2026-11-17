import 'package:flutter/material.dart';

/// Model biểu diễn một giao dịch tài chính (Thu nhập hoặc Chi tiêu)
class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;
  final int type; // 0: Chi tiêu (Expense), 1: Thu nhập (Income)
  final String? note;
  final String? createdAt;

  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
    this.createdAt,
  });

  /// Kiểm tra có phải giao dịch thu nhập không
  bool get isIncome => type == 1;

  /// Kiểm tra có phải giao dịch chi tiêu không
  bool get isExpense => type == 0;

  /// Format số tiền có dấu (+ / -) và đơn vị đ (Ví dụ: +8.000.000 đ hoặc -50.000 đ)
  String get formattedAmount {
    final prefix = isIncome ? '+' : '-';
    final formattedNumber = formatCurrency(amount);
    return '$prefix$formattedNumber đ';
  }

  /// Format số tiền không dấu (Ví dụ: 8.000.000 đ)
  String get rawFormattedAmount => '${formatCurrency(amount)} đ';

  /// Hàm hỗ trợ định dạng số tiền theo chuẩn phân cách hàng nghìn bằng dấu chấm (.)
  static String formatCurrency(double val) {
    int intVal = val.round();
    String s = intVal.abs().toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = s.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return formatted;
  }

  /// Lấy Icon phù hợp với danh mục giao dịch
  IconData get categoryIcon {
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
      case 'nhà cửa':
      case 'tiền điện':
      case 'tiền nước':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  /// Lấy màu sắc đặc trưng theo danh mục giao dịch
  Color get categoryColor {
    switch (category.toLowerCase().trim()) {
      case 'ăn uống':
        return const Color(0xFFFF7043); // Cam
      case 'di chuyển':
      case 'xăng xe':
        return const Color(0xFF29B6F6); // Xanh dương nhạt
      case 'thu nhập':
      case 'lương':
      case 'tiền lương':
      case 'thưởng':
        return const Color(0xFF66BB6A); // Xanh lá
      case 'mua sắm':
        return const Color(0xFFAB47BC); // Tím
      case 'giáo dục':
      case 'học phí':
        return const Color(0xFF26A69A); // Xanh ngọc
      case 'giải trí':
        return const Color(0xFFFFB74D); // Vàng cam
      case 'sức khỏe':
      case 'y tế':
        return const Color(0xFFEF5350); // Đỏ hồng
      default:
        return const Color(0xFF78909C); // Xám xanh
    }
  }

  /// Chuyển đổi đối tượng TransactionModel sang Map để lưu trữ vào SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'type': type,
      'note': note ?? '',
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Tạo đối tượng TransactionModel từ Map dữ liệu đọc từ SQLite
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      category: map['category'] as String,
      type: map['type'] as int,
      note: map['note'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  /// Tạo bản sao có cập nhật một số thuộc tính
  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    String? date,
    String? category,
    int? type,
    String? note,
    String? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, date: $date, category: $category, type: $type)';
  }
}
