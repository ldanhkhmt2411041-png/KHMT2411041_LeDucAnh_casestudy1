import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/category_stat_model.dart';
import 'package:untitled/models/budget_model.dart';

void main() {
  group('Buoi 7 Models & Advanced Feature Tests', () {
    test('CategoryStatModel percentage and formatting test', () {
      final stat = CategoryStatModel(
        category: 'Ăn uống',
        totalAmount: 1500000.0,
        count: 5,
        percentage: 50.0,
      );

      expect(stat.category, 'Ăn uống');
      expect(stat.totalAmount, 1500000.0);
      expect(stat.percentage, 50.0);
      expect(stat.formattedAmount, '1.500.000 đ');
      expect(stat.icon, isNotNull);
      expect(stat.color, isNotNull);
    });

    test('BudgetModel serialization test', () {
      final budget = BudgetModel(
        id: 1,
        category: 'Ăn uống',
        monthlyLimit: 2000000.0,
        month: '09/2024',
      );

      final map = budget.toMap();
      expect(map['category'], 'Ăn uống');
      expect(map['monthly_limit'], 2000000.0);
      expect(map['month'], '09/2024');

      final reconstructed = BudgetModel.fromMap(map);
      expect(reconstructed.id, 1);
      expect(reconstructed.category, 'Ăn uống');
      expect(reconstructed.monthlyLimit, 2000000.0);
    });
  });
}
