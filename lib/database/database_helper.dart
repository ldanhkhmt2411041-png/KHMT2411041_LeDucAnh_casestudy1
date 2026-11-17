import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/category_stat_model.dart';
import '../models/budget_model.dart';

/// Lớp quản trị cơ sở dữ liệu SQLite cho ứng dụng Expense Manager
class DatabaseHelper {
  // Triển khai Singleton Pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Tên cơ sở dữ liệu và phiên bản
  static const String _dbName = 'expense_manager.db';
  static const int _dbVersion = 2;

  // Tên các bảng
  static const String tableTransactions = 'transactions';
  static const String tableCategories = 'categories';
  static const String tableBudgets = 'budgets';
  static const String tableSettings = 'app_settings';

  // Các trường của bảng transactions
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colAmount = 'amount';
  static const String colDate = 'date';
  static const String colCategory = 'category';
  static const String colType = 'type'; // 0: Chi tiêu, 1: Thu nhập
  static const String colNote = 'note';
  static const String colCreatedAt = 'created_at';

  // Các trường của bảng categories
  static const String colCatId = 'id';
  static const String colCatName = 'name';
  static const String colCatType = 'type';
  static const String colCatIcon = 'icon_name';
  static const String colCatColor = 'color_value';

  /// Lấy instance của Database, nếu chưa có thì khởi tạo
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  /// Khởi tạo và mở cơ sở dữ liệu SQLite
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  /// Tạo các bảng dữ liệu ban đầu
  Future<void> _createDB(Database db, int version) async {
    // 1. Tạo bảng categories
    await db.execute('''
      CREATE TABLE $tableCategories (
        $colCatId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCatName TEXT NOT NULL UNIQUE,
        $colCatType INTEGER NOT NULL,
        $colCatIcon TEXT NOT NULL,
        $colCatColor INTEGER NOT NULL
      )
    ''');

    // 2. Tạo bảng transactions
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colAmount REAL NOT NULL,
        $colDate TEXT NOT NULL,
        $colCategory TEXT NOT NULL,
        $colType INTEGER NOT NULL,
        $colNote TEXT,
        $colCreatedAt TEXT NOT NULL
      )
    ''');

    // 3. Tạo bảng budgets (Ngân sách chi tiêu)
    await db.execute('''
      CREATE TABLE $tableBudgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        monthly_limit REAL NOT NULL,
        month TEXT NOT NULL,
        UNIQUE(category, month)
      )
    ''');

    // 4. Tạo bảng app_settings (Cài đặt cấu hình)
    await db.execute('''
      CREATE TABLE $tableSettings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Nạp dữ liệu ban đầu
    await _seedCategories(db);
    await _seedInitialTransactions(db);
    await _seedInitialBudgets(db);
  }

  /// Nâng cấp cơ sở dữ liệu khi cập nhật phiên bản
  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableBudgets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT NOT NULL,
          monthly_limit REAL NOT NULL,
          month TEXT NOT NULL,
          UNIQUE(category, month)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableSettings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');

      await _seedInitialBudgets(db);
    }
  }

  /// Nạp các danh mục mặc định cho chi tiêu và thu nhập
  Future<void> _seedCategories(Database db) async {
    final List<Map<String, dynamic>> defaultCategories = [
      {colCatName: 'Ăn uống', colCatType: 0, colCatIcon: 'restaurant', colCatColor: 0xFFFF7043},
      {colCatName: 'Di chuyển', colCatType: 0, colCatIcon: 'directions_car', colCatColor: 0xFF29B6F6},
      {colCatName: 'Mua sắm', colCatType: 0, colCatIcon: 'shopping_bag', colCatColor: 0xFFAB47BC},
      {colCatName: 'Giáo dục', colCatType: 0, colCatIcon: 'school', colCatColor: 0xFF26A69A},
      {colCatName: 'Giải trí', colCatType: 0, colCatIcon: 'sports_esports', colCatColor: 0xFFFFB74D},
      {colCatName: 'Sức khỏe', colCatType: 0, colCatIcon: 'local_hospital', colCatColor: 0xFFEF5350},
      {colCatName: 'Khác', colCatType: 0, colCatIcon: 'category', colCatColor: 0xFF78909C},
      {colCatName: 'Thu nhập', colCatType: 1, colCatIcon: 'attach_money', colCatColor: 0xFF66BB6A},
      {colCatName: 'Lương', colCatType: 1, colCatIcon: 'attach_money', colCatColor: 0xFF4CAF50},
      {colCatName: 'Thưởng', colCatType: 1, colCatIcon: 'attach_money', colCatColor: 0xFF81C784},
    ];

    for (final cat in defaultCategories) {
      await db.insert(tableCategories, cat, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// Nạp các giao dịch mẫu ban đầu đúng với giao diện Dashboard
  Future<void> _seedInitialTransactions(Database db) async {
    final List<Map<String, dynamic>> initialData = [
      {
        colTitle: 'Ăn trưa',
        colAmount: 50000.0,
        colDate: '03/09/2024',
        colCategory: 'Ăn uống',
        colType: 0,
        colNote: 'Ăn trưa cùng đồng nghiệp',
        colCreatedAt: '2024-09-03T12:00:00Z',
      },
      {
        colTitle: 'Xăng xe',
        colAmount: 100000.0,
        colDate: '03/09/2024',
        colCategory: 'Di chuyển',
        colType: 0,
        colNote: 'Đổ xăng xe máy',
        colCreatedAt: '2024-09-03T08:30:00Z',
      },
      {
        colTitle: 'Lương tháng 9',
        colAmount: 8000000.0,
        colDate: '01/09/2024',
        colCategory: 'Thu nhập',
        colType: 1,
        colNote: 'Lương công ty chuyển khoản tháng 9',
        colCreatedAt: '2024-09-01T09:00:00Z',
      },
      {
        colTitle: 'Mua sắm',
        colAmount: 300000.0,
        colDate: '31/08/2024',
        colCategory: 'Mua sắm',
        colType: 0,
        colNote: 'Mua quần áo đồ dùng cá nhân',
        colCreatedAt: '2024-08-31T15:20:00Z',
      },
      {
        colTitle: 'Học phí',
        colAmount: 500000.0,
        colDate: '30/08/2024',
        colCategory: 'Giáo dục',
        colType: 0,
        colNote: 'Học phí khóa học kỹ năng mềm',
        colCreatedAt: '2024-08-30T10:00:00Z',
      },
    ];

    for (final item in initialData) {
      await db.insert(tableTransactions, item);
    }
  }

  /// Nạp ngân sách ban đầu
  Future<void> _seedInitialBudgets(Database db) async {
    final List<Map<String, dynamic>> budgets = [
      {'category': 'Ăn uống', 'monthly_limit': 2000000.0, 'month': '09/2024'},
      {'category': 'Di chuyển', 'monthly_limit': 500000.0, 'month': '09/2024'},
      {'category': 'Mua sắm', 'monthly_limit': 1000000.0, 'month': '09/2024'},
    ];
    for (final b in budgets) {
      await db.insert(tableBudgets, b, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // ==========================================
  // CÁC PHƯƠNG THỨC CRUD CHO TRANSACTIONS
  // ==========================================

  Future<TransactionModel> insertTransaction(TransactionModel item) async {
    final db = await instance.database;
    final id = await db.insert(tableTransactions, item.toMap());
    return item.copyWith(id: id);
  }

  Future<TransactionModel?> getTransactionById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTransactions,
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TransactionModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<TransactionModel>> getAllTransactions({String? orderBy}) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      orderBy: orderBy ?? '$colId DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      orderBy: '$colId DESC',
      limit: limit,
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> getTransactionsByType(int type) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      where: '$colType = ?',
      whereArgs: [type],
      orderBy: '$colId DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      tableTransactions,
      where: '$colCategory = ?',
      whereArgs: [category],
      orderBy: '$colId DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  /// Tìm kiếm giao dịch theo từ khóa
  Future<List<TransactionModel>> searchTransactions(String keyword) async {
    final db = await instance.database;
    final pattern = '%$keyword%';
    final result = await db.query(
      tableTransactions,
      where: '$colTitle LIKE ? OR $colNote LIKE ? OR $colCategory LIKE ?',
      whereArgs: [pattern, pattern, pattern],
      orderBy: '$colId DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  /// Lọc giao dịch nâng cao theo loại và danh mục
  Future<List<TransactionModel>> getFilteredTransactions({
    int? type,
    String? category,
    String? keyword,
  }) async {
    final db = await instance.database;
    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    if (type != null) {
      whereClauses.add('$colType = ?');
      whereArgs.add(type);
    }

    if (category != null && category.isNotEmpty && category != 'Tất cả') {
      whereClauses.add('$colCategory = ?');
      whereArgs.add(category);
    }

    if (keyword != null && keyword.trim().isNotEmpty) {
      whereClauses.add('($colTitle LIKE ? OR $colNote LIKE ?)');
      final p = '%${keyword.trim()}%';
      whereArgs.add(p);
      whereArgs.add(p);
    }

    final where = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;
    final result = await db.query(
      tableTransactions,
      where: where,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: '$colId DESC',
    );

    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<int> updateTransaction(TransactionModel item) async {
    final db = await instance.database;
    return await db.update(
      tableTransactions,
      item.toMap(),
      where: '$colId = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableTransactions,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTransactions() async {
    final db = await instance.database;
    return await db.delete(tableTransactions);
  }

  // ==========================================
  // CÁC HÀM THỐNG KÊ TÍNH TOÁN NÂNG CAO
  // ==========================================

  Future<double> getTotalIncome() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM($colAmount) as total FROM $tableTransactions WHERE $colType = 1',
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  Future<double> getTotalExpense() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM($colAmount) as total FROM $tableTransactions WHERE $colType = 0',
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  Future<double> getCurrentBalance() async {
    final double income = await getTotalIncome();
    final double expense = await getTotalExpense();
    return income - expense;
  }

  /// Báo cáo chi tiêu theo từng danh mục kèm tỉ lệ phần trăm
  Future<List<CategoryStatModel>> getCategorySpendingReport() async {
    final db = await instance.database;
    final double totalExpense = await getTotalExpense();

    final result = await db.rawQuery('''
      SELECT $colCategory, SUM($colAmount) as total, COUNT($colId) as count
      FROM $tableTransactions
      WHERE $colType = 0
      GROUP BY $colCategory
      ORDER BY total DESC
    ''');

    return result.map((row) {
      final category = row[colCategory] as String;
      final amount = (row['total'] as num).toDouble();
      final count = row['count'] as int;
      final percentage = totalExpense > 0 ? (amount / totalExpense) * 100 : 0.0;

      return CategoryStatModel(
        category: category,
        totalAmount: amount,
        count: count,
        percentage: percentage,
      );
    }).toList();
  }

  // ==========================================
  // CÁC PHƯƠNG THỨC CHO BUDGETS & SETTINGS
  // ==========================================

  Future<int> setBudget(String category, double limit, String month) async {
    final db = await instance.database;
    return await db.insert(
      tableBudgets,
      {'category': category, 'monthly_limit': limit, 'month': month},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BudgetModel>> getAllBudgets(String month) async {
    final db = await instance.database;
    final result = await db.query(
      tableBudgets,
      where: 'month = ?',
      whereArgs: [month],
    );
    return result.map((m) => BudgetModel.fromMap(m)).toList();
  }

  /// Đặt lại cơ sở dữ liệu về trạng thái mẫu ban đầu
  Future<void> resetToInitialData() async {
    final db = await instance.database;
    await db.delete(tableTransactions);
    await db.delete(tableCategories);
    await db.delete(tableBudgets);
    await _seedCategories(db);
    await _seedInitialTransactions(db);
    await _seedInitialBudgets(db);
  }

  // ==========================================
  // CÁC PHƯƠNG THỨC CHO CATEGORIES
  // ==========================================

  Future<List<CategoryModel>> getAllCategories({int? type}) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result;
    if (type != null) {
      result = await db.query(
        tableCategories,
        where: '$colCatType = ?',
        whereArgs: [type],
      );
    } else {
      result = await db.query(tableCategories);
    }
    return result.map((map) => CategoryModel.fromMap(map)).toList();
  }

  Future<int> insertCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.insert(
      tableCategories,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
