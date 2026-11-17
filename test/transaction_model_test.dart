import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/transaction_model.dart';
import 'package:untitled/models/category_model.dart';

void main() {
  group('TransactionModel Unit Tests', () {
    test('TransactionModel toMap and fromMap serialization', () {
      final transaction = TransactionModel(
        id: 1,
        title: 'Ăn trưa',
        amount: 50000.0,
        date: '03/09/2024',
        category: 'Ăn uống',
        type: 0,
        note: 'Ăn trưa cùng đồng nghiệp',
        createdAt: '2024-09-03T12:00:00Z',
      );

      final map = transaction.toMap();
      expect(map['title'], 'Ăn trưa');
      expect(map['amount'], 50000.0);
      expect(map['type'], 0);
      expect(map['category'], 'Ăn uống');

      final reconstructed = TransactionModel.fromMap(map);
      expect(reconstructed.id, 1);
      expect(reconstructed.title, 'Ăn trưa');
      expect(reconstructed.amount, 50000.0);
      expect(reconstructed.isExpense, true);
      expect(reconstructed.isIncome, false);
      expect(reconstructed.formattedAmount, '-50.000 đ');
    });

    test('TransactionModel income calculation and formatting', () {
      final income = TransactionModel(
        id: 2,
        title: 'Lương tháng 9',
        amount: 8000000.0,
        date: '01/09/2024',
        category: 'Thu nhập',
        type: 1,
        note: 'Lương tháng 9',
      );

      expect(income.isIncome, true);
      expect(income.isExpense, false);
      expect(income.formattedAmount, '+8.000.000 đ');
    });

    test('CategoryModel serialization', () {
      final category = CategoryModel(
        id: 1,
        name: 'Ăn uống',
        type: 0,
        iconName: 'restaurant',
        colorValue: 0xFFFF7043,
      );

      final map = category.toMap();
      expect(map['name'], 'Ăn uống');
      expect(map['type'], 0);

      final reconstructed = CategoryModel.fromMap(map);
      expect(reconstructed.name, 'Ăn uống');
      expect(reconstructed.isExpense, true);
    });
  });
}
