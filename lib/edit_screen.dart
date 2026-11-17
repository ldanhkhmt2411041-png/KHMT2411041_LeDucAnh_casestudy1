import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/transaction_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const EditTransactionScreen(),
    );
  }
}

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const EditTransactionScreen({super.key, this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late int selectedType;
  late String selectedCategory;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<String> expenseCategories = [
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Giáo dục',
    'Giải trí',
    'Sức khỏe',
    'Khác'
  ];

  final List<String> incomeCategories = [
    'Thu nhập',
    'Lương',
    'Thưởng',
    'Khác'
  ];

  List<String> get currentCategories =>
      selectedType == 0 ? expenseCategories : incomeCategories;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      selectedType = t.type;
      selectedCategory = t.category;
      _amountController.text = TransactionModel.formatCurrency(t.amount);
      _dateController.text = t.date;
      _noteController.text = t.note ?? t.title;
    } else {
      // Giá trị mặc định mô phỏng giao diện
      selectedType = 0;
      selectedCategory = 'Ăn uống';
      _amountController.text = '100.000';
      _dateController.text = '12/04/2025';
      _noteController.text = 'Ăn trưa';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _updateTransaction() async {
    final rawAmount = _amountController.text.trim().replaceAll('.', '').replaceAll(',', '');
    if (rawAmount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền!')),
      );
      return;
    }

    final double? amount = double.tryParse(rawAmount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số tiền không hợp lệ!')),
      );
      return;
    }

    final note = _noteController.text.trim();
    final title = note.isNotEmpty ? note : selectedCategory;

    if (widget.transaction != null && widget.transaction!.id != null) {
      final updated = widget.transaction!.copyWith(
        title: title,
        amount: amount,
        date: _dateController.text.trim(),
        category: selectedCategory,
        type: selectedType,
        note: note.isNotEmpty ? note : null,
      );

      try {
        await DatabaseHelper.instance.updateTransaction(updated);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã cập nhật giao dịch thành công!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi cập nhật giao dịch: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Trường hợp mở màn hình độc lập không truyền transaction
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteTransaction() async {
    if (widget.transaction == null || widget.transaction!.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa giao dịch "${widget.transaction!.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await DatabaseHelper.instance.deleteTransaction(widget.transaction!.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã xóa giao dịch thành công!'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi xóa giao dịch: $e')),
          );
        }
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase().trim()) {
      case 'ăn uống':
        return Icons.restaurant;
      case 'di chuyển':
        return Icons.directions_car;
      case 'mua sắm':
        return Icons.shopping_bag;
      case 'giáo dục':
        return Icons.school;
      case 'giải trí':
        return Icons.sports_esports;
      case 'sức khỏe':
        return Icons.local_hospital;
      case 'thu nhập':
      case 'lương':
      case 'thưởng':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase().trim()) {
      case 'ăn uống':
        return const Color(0xFFFF5252);
      case 'di chuyển':
        return const Color(0xFF29B6F6);
      case 'mua sắm':
        return const Color(0xFFAB47BC);
      case 'giáo dục':
        return const Color(0xFF26A69A);
      case 'giải trí':
        return const Color(0xFFFFB74D);
      case 'sức khỏe':
        return const Color(0xFFEF5350);
      case 'thu nhập':
      case 'lương':
      case 'thưởng':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF78909C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Sửa giao dịch',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.transaction != null && widget.transaction!.id != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: _deleteTransaction,
              tooltip: 'Xóa giao dịch',
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Tab Chọn Chi tiêu / Thu nhập
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedType = 0;
                                    if (!expenseCategories.contains(selectedCategory)) {
                                      selectedCategory = expenseCategories.first;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: selectedType == 0
                                        ? const Color(0xFFFF5252)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Chi tiêu',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedType == 0
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedType = 1;
                                    if (!incomeCategories.contains(selectedCategory)) {
                                      selectedCategory = incomeCategories.first;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: selectedType == 1
                                        ? const Color(0xFF4CAF50)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Thu nhập',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedType == 1
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Danh mục
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD0D5DD)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentCategories.contains(selectedCategory)
                                ? selectedCategory
                                : currentCategories.first,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            items: currentCategories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(category).withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(category),
                                        size: 18,
                                        color: _getCategoryColor(category),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      category,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedCategory = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Số tiền
                      const Text(
                        'Số tiền',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'đ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. Ngày giao dịch
                      const Text(
                        'Ngày giao dịch',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_today_outlined,
                              size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 5. Ghi chú
                      const Text(
                        'Ghi chú',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Nút Lưu
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
