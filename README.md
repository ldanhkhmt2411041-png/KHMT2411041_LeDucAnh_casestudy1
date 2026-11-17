# Expense Manager - Quản lý chi tiêu cá nhân

**Case Study 1: Lập trình di động với Flutter**

- **Họ và tên:** Lê Đức Anh
- **MSSV:** KHMT2411041
- **Email:** ldanhkhmt2411041@student.ctuet.edu.vn
- **Repository:** [https://github.com/ldanhkhmt2411041-png/KHMT2411041_LeDucAnh_casestudy1](https://github.com/ldanhkhmt2411041-png/KHMT2411041_LeDucAnh_casestudy1)

---

## Danh sách nhánh và tiến độ các buổi thực hành

| Nhánh | Buổi | Nội dung thực hiện | Trạng thái |
|---|---|---|---|
| `buoi1` | Buổi 1 | Khởi tạo dự án Flutter, cấu hình môi trường, đưa code lên GitHub repo. | Hoàn thành |
| `buoi2` | Buổi 2 | Xây dựng giao diện màn hình Chào mừng (Welcome Screen - Expense Manager). | Hoàn thành |
| `buoi3` | Buổi 3 | Xây dựng 2 màn hình Thêm giao dịch (`add_screen.dart`) và Sửa giao dịch (`edit_screen.dart`). | Hoàn thành |
| `buoi4` | Buổi 4 | Xây dựng giao diện màn hình Dashboard quản lý thu chi (`home_screen.dart`). | Hoàn thành |
| `buoi5` | Buổi 5 | Thiết kế và xây dựng cơ sở dữ liệu SQLite cho ứng dụng Expense Manager. | Hoàn thành |

---

## Chi tiết Buổi 5: Thiết kế và xây dựng Database SQLite

### 1. Thư viện sử dụng
- `sqflite`: ^2.3.3+1 (Hỗ trợ tương tác cơ sở dữ liệu SQLite trên thiết bị)
- `path`: ^1.9.0 (Quản lý đường dẫn tập tin cơ sở dữ liệu)
- `intl`: ^0.19.0 (Hỗ trợ định dạng số tiền VNĐ và ngày tháng)

### 2. Thiết kế bảng cơ sở dữ liệu (SQLite Schema)

#### Bảng `categories` (Danh mục giao dịch)
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Mã danh mục |
| `name` | TEXT | NOT NULL UNIQUE | Tên danh mục (Ăn uống, Di chuyển, Lương...) |
| `type` | INTEGER | NOT NULL | 0: Chi tiêu, 1: Thu nhập |
| `icon_name` | TEXT | NOT NULL | Tên icon tương ứng |
| `color_value` | INTEGER | NOT NULL | Mã màu hex tương ứng |

#### Bảng `transactions` (Lịch sử giao dịch thu/chi)
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Mã giao dịch |
| `title` | TEXT | NOT NULL | Tiêu đề giao dịch |
| `amount` | REAL | NOT NULL | Số tiền giao dịch |
| `date` | TEXT | NOT NULL | Ngày thực hiện (DD/MM/YYYY) |
| `category` | TEXT | NOT NULL | Tên danh mục |
| `type` | INTEGER | NOT NULL | 0: Chi tiêu, 1: Thu nhập |
| `note` | TEXT | NULL | Ghi chú chi tiết |
| `created_at` | TEXT | NOT NULL | Thời điểm tạo bản ghi (ISO 8601) |

### 3. Cấu trúc mã nguồn trong `lib/`
```text
lib/
├── database/
│   └── database_helper.dart      # Quản trị SQLite Singleton, tạo bảng, CRUD, hàm thống kê
├── models/
│   ├── category_model.dart       # Model danh mục, toMap(), fromMap()
│   └── transaction_model.dart    # Model giao dịch, format tiền tệ, mapping icon/màu sắc
├── add_screen.dart               # Giao diện Thêm giao dịch
├── edit_screen.dart              # Giao diện Sửa giao dịch
├── home_screen.dart              # Giao diện Dashboard Quản lý thu chi
└── main.dart                     # Giao diện Chào mừng (WelcomeScreen) & Entrypoint
```

### 4. Các chức năng CRUD và Thống kê đã triển khai trong `DatabaseHelper`
- `insertTransaction(TransactionModel item)`: Thêm mới giao dịch.
- `getTransactionById(int id)`: Xem chi tiết giao dịch theo ID.
- `getAllTransactions()`: Lấy toàn bộ danh sách giao dịch.
- `getRecentTransactions({int limit})`: Lấy danh sách giao dịch gần nhất cho Dashboard.
- `getTransactionsByType(int type)`: Lọc giao dịch theo Thu nhập hoặc Chi tiêu.
- `getTransactionsByCategory(String category)`: Lọc giao dịch theo danh mục.
- `updateTransaction(TransactionModel item)`: Cập nhật giao dịch.
- `deleteTransaction(int id)`: Xóa giao dịch.
- `getTotalIncome()`: Tính tổng thu nhập.
- `getTotalExpense()`: Tính tổng chi tiêu.
- `getCurrentBalance()`: Tính số dư hiện tại (Tổng thu - Tổng chi).
- Tự động nạp dữ liệu mẫu ban đầu (Seeding initial transactions & categories) khớp 100% với giao diện Dashboard thiết kế ở Buổi 4.
