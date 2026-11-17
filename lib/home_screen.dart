import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/transaction_model.dart';
import 'add_screen.dart';
import 'edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý thu chi',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isBalanceVisible = true;
  bool _isLoading = true;

  List<TransactionModel> _transactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Nạp toàn bộ dữ liệu từ SQLite database
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await DatabaseHelper.instance.getAllTransactions();
      final totalIncome = await DatabaseHelper.instance.getTotalIncome();
      final totalExpense = await DatabaseHelper.instance.getTotalExpense();
      final currentBalance = await DatabaseHelper.instance.getCurrentBalance();

      if (mounted) {
        setState(() {
          _transactions = transactions;
          _totalIncome = totalIncome;
          _totalExpense = totalExpense;
          _currentBalance = currentBalance;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  /// Điều hướng sang màn hình Thêm giao dịch và tải lại khi hoàn thành
  Future<void> _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  /// Điều hướng sang màn hình Sửa giao dịch và tải lại khi hoàn thành
  Future<void> _navigateToEditScreen(TransactionModel item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(transaction: item),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Quản lý thu chi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined,
                    color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Card Số dư hiện tại (Gradient xanh)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'SỐ DƯ HIỆN TẠI',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isBalanceVisible = !_isBalanceVisible;
                                        });
                                      },
                                      child: Icon(
                                        _isBalanceVisible
                                            ? Icons.remove_red_eye
                                            : Icons.visibility_off,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isBalanceVisible
                                      ? '${TransactionModel.formatCurrency(_currentBalance)} đ'
                                      : '****** đ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Biểu tượng Ví tiền
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              size: 56,
                              color: Color(0xFFFFD54F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Thống kê Tổng Thu nhập / Tổng Chi tiêu
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFA5D6A7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_downward,
                                  color: Color(0xFF2E7D32), size: 18),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TỔNG THU NHẬP',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${TransactionModel.formatCurrency(_totalIncome)} đ',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFCDD2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_upward,
                                  color: Color(0xFFC62828), size: 18),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TỔNG CHI TIÊU',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${TransactionModel.formatCurrency(_totalExpense)} đ',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC62828),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Tiêu đề danh sách: Giao dịch gần đây & Xem tất cả
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Giao dịch gần đây',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: _loadData,
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2979FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. Danh sách Giao dịch gần đây
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_transactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: Column(
                      children: const [
                        Icon(Icons.receipt_long_outlined,
                            size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Chưa có giao dịch nào',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Nhấn nút (+) để thêm giao dịch đầu tiên',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _transactions[index];

                      return InkWell(
                        onTap: () => _navigateToEditScreen(item),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon Danh mục
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: item.categoryColor.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item.categoryIcon,
                                  color: item.categoryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Tên giao dịch, Danh mục và Ngày
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          item.category,
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          item.date,
                                          style: const TextStyle(
                                            color: Colors.black38,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Số tiền hiển thị (+ hoặc -)
                              Text(
                                item.formattedAmount,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: item.isIncome
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE53935),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),

      // 5. Nút Thêm giao dịch (Floating Action Button)
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddScreen,
        backgroundColor: const Color(0xFF2979FF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      // 6. Thanh Điều hướng Dưới (Bottom Navigation Bar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF2979FF),
        unselectedItemColor: Colors.black45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Báo cáo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
        ],
      ),
    );
  }
}
