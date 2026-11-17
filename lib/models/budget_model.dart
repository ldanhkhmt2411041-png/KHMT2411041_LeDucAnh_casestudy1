/// Model biểu diễn ngân sách chi tiêu theo danh mục
class BudgetModel {
  final int? id;
  final String category;
  final double monthlyLimit;
  final String month; // Định dạng MM/yyyy (ví dụ: '09/2024')

  const BudgetModel({
    this.id,
    required this.category,
    required this.monthlyLimit,
    required this.month,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'category': category,
      'monthly_limit': monthlyLimit,
      'month': month,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as int?,
      category: map['category'] as String,
      monthlyLimit: (map['monthly_limit'] is int)
          ? (map['monthly_limit'] as int).toDouble()
          : (map['monthly_limit'] as num).toDouble(),
      month: map['month'] as String,
    );
  }
}
